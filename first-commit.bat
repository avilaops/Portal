@echo off
REM Script para primeiro commit no GitHub

echo.
echo ========================================
echo ?? Avila Portal - Primeiro Commit
echo ========================================
echo.

REM Verificar se está em um repo git
if not exist .git (
    echo ?? Inicializando repositorio Git...
    git init
    git branch -M main
) else (
    echo ? Repositorio Git ja existe
)

echo.
echo ?? Adicionando arquivos...
git add .

echo.
echo ?? Criando commit...
git commit -m "?? feat: Initial commit - Avila Portal v0.1.0" -m "- Backend completo em Rust (Actix-web)" -m "- Frontend completo em WASM (Yew)" -m "- Autenticacao JWT" -m "- Dashboard executivo" -m "- 10 produtos integrados" -m "- Design system sofisticado" -m "- Docker + CI/CD" -m "- 80+ arquivos criados" -m "" -m "Stack: 100%% Rust + WebAssembly" -m "Zero dependencias de terceiros (runtime)"

echo.
echo ?? Configurando remote (se nao existir)...
git remote add origin https://github.com/avilaops/portal.git 2>nul

echo.
echo ?? Enviando para GitHub...
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ? Push concluido com sucesso!
    echo.
    echo ?? Repositorio: https://github.com/avilaops/portal
    echo.
) else (
    echo.
    echo ??  Erro no push. Possiveis causas:
    echo    - Repositorio remoto nao existe
    echo    - Sem permissao de escrita
    echo    - Conflitos com commits existentes
    echo.
    echo Execute manualmente:
    echo    git push -u origin main --force
    echo.
)

pause
