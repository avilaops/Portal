#!/usr/bin/env pwsh

# Script PowerShell para Windows - Setup completo

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "?? Avila Portal - Setup Completo" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar Rust
Write-Host "?? Verificando Rust..." -ForegroundColor Yellow
if (Get-Command cargo -ErrorAction SilentlyContinue) {
    $rustVersion = cargo --version
    Write-Host "? Rust encontrado: $rustVersion" -ForegroundColor Green
} else {
    Write-Host "? Rust não encontrado!" -ForegroundColor Red
    Write-Host "   Instale de: https://rustup.rs/" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# Adicionar target WASM
Write-Host "?? Adicionando target wasm32-unknown-unknown..." -ForegroundColor Yellow
rustup target add wasm32-unknown-unknown
Write-Host "? Target WASM adicionado" -ForegroundColor Green

Write-Host ""

# Instalar Trunk
Write-Host "?? Verificando Trunk..." -ForegroundColor Yellow
if (Get-Command trunk -ErrorAction SilentlyContinue) {
    Write-Host "? Trunk já instalado" -ForegroundColor Green
} else {
    Write-Host "?? Instalando Trunk..." -ForegroundColor Yellow
    cargo install trunk
    Write-Host "? Trunk instalado" -ForegroundColor Green
}

Write-Host ""

# Instalar SQLx CLI
Write-Host "?? Verificando SQLx CLI..." -ForegroundColor Yellow
if (Get-Command sqlx -ErrorAction SilentlyContinue) {
    Write-Host "? SQLx CLI já instalado" -ForegroundColor Green
} else {
    Write-Host "?? Instalando SQLx CLI..." -ForegroundColor Yellow
    cargo install sqlx-cli --features postgres
    Write-Host "? SQLx CLI instalado" -ForegroundColor Green
}

Write-Host ""

# Copiar .env
Write-Host "??  Configurando ambiente..." -ForegroundColor Yellow
if (Test-Path "backend\.env") {
    Write-Host "? Arquivo .env já existe" -ForegroundColor Green
} else {
    Copy-Item "backend\.env.example" "backend\.env"
    Write-Host "? Arquivo .env criado" -ForegroundColor Green
    Write-Host "??  Configure backend\.env antes de continuar!" -ForegroundColor Yellow
}

Write-Host ""

# Verificar Docker
Write-Host "?? Verificando Docker..." -ForegroundColor Yellow
if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host "? Docker encontrado" -ForegroundColor Green
    Write-Host ""
    Write-Host "?? Iniciando PostgreSQL e Redis..." -ForegroundColor Yellow
    docker-compose up -d postgres redis
    Write-Host "? Serviços Docker iniciados" -ForegroundColor Green
} else {
    Write-Host "??  Docker não encontrado" -ForegroundColor Yellow
    Write-Host "   Instale PostgreSQL e Redis manualmente" -ForegroundColor Yellow
    Write-Host "   Ou instale Docker: https://docs.docker.com/get-docker/" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "? Setup Concluído!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "?? Próximos passos:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   1. Configure backend\.env (se ainda não fez)" -ForegroundColor White
Write-Host "   2. Terminal 1 - Backend:" -ForegroundColor White
Write-Host "      cd backend" -ForegroundColor Gray
Write-Host "      cargo run" -ForegroundColor Gray
Write-Host ""
Write-Host "   3. Terminal 2 - Frontend:" -ForegroundColor White
Write-Host "      cd frontend" -ForegroundColor Gray
Write-Host "      trunk serve --open" -ForegroundColor Gray
Write-Host ""
Write-Host "?? Portal: http://localhost:8080" -ForegroundColor Cyan
Write-Host "?? API: http://localhost:8080/api" -ForegroundColor Cyan
Write-Host "?? Health: http://localhost:8080/api/health" -ForegroundColor Cyan
Write-Host ""
