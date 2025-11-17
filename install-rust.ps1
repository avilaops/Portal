#!/usr/bin/env pwsh

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "?? Instalador Automático do Rust" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se Rust já está instalado
if (Get-Command cargo -ErrorAction SilentlyContinue) {
    Write-Host "? Rust já está instalado!" -ForegroundColor Green
    cargo --version
    rustc --version
    Write-Host ""
    Write-Host "Para atualizar, execute: rustup update" -ForegroundColor Yellow
    exit 0
}

Write-Host "?? Baixando rustup-init..." -ForegroundColor Yellow

$tempFile = "$env:TEMP\rustup-init.exe"

try {
    Invoke-WebRequest -Uri "https://win.rustup.rs/x86_64" -OutFile $tempFile
    Write-Host "? Download completo!" -ForegroundColor Green
} catch {
    Write-Host "? Erro ao baixar rustup-init" -ForegroundColor Red
    Write-Host "Baixe manualmente de: https://rustup.rs/" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "?? Instalando Rust..." -ForegroundColor Yellow
Write-Host ""
Write-Host "??  IMPORTANTE:" -ForegroundColor Yellow
Write-Host "   - Escolha a opção PADRÃO (1) quando perguntado" -ForegroundColor White
Write-Host "   - Aguarde a instalação completa" -ForegroundColor White
Write-Host ""

# Executar instalador
& $tempFile

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "? Instalação Concluída!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "?? PRÓXIMOS PASSOS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   1. FECHE este terminal" -ForegroundColor White
Write-Host "   2. ABRA um NOVO terminal" -ForegroundColor White
Write-Host "   3. Execute: cargo --version" -ForegroundColor White
Write-Host "   4. Se funcionar, execute: .\setup.ps1" -ForegroundColor White
Write-Host ""
Write-Host "?? Depois disso, o portal estará pronto para rodar!" -ForegroundColor Cyan
Write-Host ""

# Limpar arquivo temporário
Remove-Item $tempFile -ErrorAction SilentlyContinue
