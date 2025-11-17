# Deploy Portal Avila Inc para Azure Static Web App
# Script de deploy automatizado

param(
    [string]$Environment = "production",
    [switch]$CreateNew = $false
)

$ErrorActionPreference = "Stop"

Write-Host "🌐 Deploy Portal Avila Inc para Azure" -ForegroundColor Cyan
Write-Host "Environment: $Environment" -ForegroundColor Yellow
Write-Host ""

# Verificar se está no diretório correto
$portalPath = "c:\Users\nicol\OneDrive\Avila\Portal"
if (-not (Test-Path $portalPath)) {
    Write-Host "❌ Diretório Portal não encontrado!" -ForegroundColor Red
    exit 1
}

Set-Location $portalPath

# Verificar arquivos necessários
$requiredFiles = @("index.html", "styles.css", "script.js", "staticwebapp.config.json", "swa-cli.config.json")
foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "❌ Arquivo $file não encontrado!" -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ $file encontrado" -ForegroundColor Green
}

Write-Host ""

# Verificar SWA CLI instalado
Write-Host "🔍 Verificando SWA CLI..." -ForegroundColor Cyan
$swaVersion = npx @azure/static-web-apps-cli --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  SWA CLI não encontrado. Instalando..." -ForegroundColor Yellow
    npm install -g @azure/static-web-apps-cli
} else {
    Write-Host "✅ SWA CLI versão: $swaVersion" -ForegroundColor Green
}

Write-Host ""

if ($CreateNew) {
    # Criar novo Static Web App via Azure CLI
    Write-Host "🏗️  Criando novo Static Web App..." -ForegroundColor Cyan

    $resourceGroup = "avila-portal-rg"
    $appName = "portal-avila-inc"
    $location = "eastus2"

    # Verificar se resource group existe
    $rgExists = az group exists --name $resourceGroup 2>&1
    if ($rgExists -eq "false") {
        Write-Host "📦 Criando resource group $resourceGroup..." -ForegroundColor Yellow
        az group create --name $resourceGroup --location $location
    }

    # Criar Static Web App
    Write-Host "🌐 Criando Static Web App $appName..." -ForegroundColor Yellow
    az staticwebapp create `
        --name $appName `
        --resource-group $resourceGroup `
        --location $location `
        --sku Free `
        --source https://github.com/avilaops/Avila-Framework `
        --branch main `
        --app-location "/Portal" `
        --output-location "" `
        --login-with-github

    Write-Host "✅ Static Web App criado com sucesso!" -ForegroundColor Green
    Write-Host ""
}

# Obter deployment token
Write-Host "🔑 Obtendo deployment token..." -ForegroundColor Cyan

$resourceGroup = "avila-portal-rg"
$appName = "portal-avila-inc"

$deploymentToken = az staticwebapp secrets list `
    --name $appName `
    --resource-group $resourceGroup `
    --query "properties.apiKey" `
    --output tsv 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Não foi possível obter token automaticamente." -ForegroundColor Yellow
    Write-Host "Por favor, execute manualmente:" -ForegroundColor Yellow
    Write-Host "az staticwebapp secrets list --name $appName --resource-group $resourceGroup --query 'properties.apiKey' -o tsv" -ForegroundColor Gray
    Write-Host ""
    $deploymentToken = Read-Host "Cole o deployment token aqui"
}

if ([string]::IsNullOrWhiteSpace($deploymentToken)) {
    Write-Host "❌ Deployment token não fornecido!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Token obtido com sucesso" -ForegroundColor Green
Write-Host ""

# Deploy
Write-Host "🚀 Iniciando deploy para $Environment..." -ForegroundColor Cyan
Write-Host ""

$env:SWA_CLI_DEPLOYMENT_TOKEN = $deploymentToken

npx @azure/static-web-apps-cli deploy `
    --env $Environment `
    --deployment-token $deploymentToken `
    --no-use-keychain

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "🎉 Deploy concluído com sucesso!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 URLs de acesso:" -ForegroundColor Cyan
    Write-Host "   - Portal: https://portal.avila.inc" -ForegroundColor White
    Write-Host "   - Azure: https://$appName.azurestaticapps.net" -ForegroundColor White
    Write-Host ""
    Write-Host "📋 Próximos passos:" -ForegroundColor Yellow
    Write-Host "   1. Configurar DNS customizado (portal.avila.inc)" -ForegroundColor White
    Write-Host "   2. Configurar certificado SSL" -ForegroundColor White
    Write-Host "   3. Testar em produção" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "❌ Erro no deploy!" -ForegroundColor Red
    Write-Host "Verifique os logs acima para mais detalhes." -ForegroundColor Yellow
    exit 1
}
