@echo off
REM Script de setup inicial do Avila Portal (Windows)

echo.
echo ========================================
echo ?? Avila Portal - Setup Inicial
echo ========================================
echo.

REM Verificar Rust
where cargo >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ? Rust nao encontrado. Instale de: https://rustup.rs/
    pause
    exit /b 1
) else (
    echo ? Rust encontrado
    rustc --version
)

REM Adicionar target WASM
echo.
echo ?? Adicionando target wasm32-unknown-unknown...
rustup target add wasm32-unknown-unknown

REM Instalar Trunk
where trunk >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ?? Instalando Trunk...
    cargo install trunk
) else (
    echo ? Trunk ja instalado
)

REM Instalar SQLx CLI
where sqlx >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ?? Instalando SQLx CLI...
    cargo install sqlx-cli --features postgres
) else (
    echo ? SQLx CLI ja instalado
)

REM Copiar .env
echo.
echo ??  Configurando variaveis de ambiente...
if not exist backend\.env (
    copy backend\.env.example backend\.env
    echo ? Arquivo .env criado em backend\
    echo ??  Configure as variaveis em backend\.env conforme necessario
) else (
    echo ? Arquivo .env ja existe
)

echo.
echo ? Setup concluido!
echo.
echo ?? Proximos passos:
echo    1. Configure backend\.env com suas credenciais
echo    2. Inicie PostgreSQL e Redis (use Docker ou instale local)
echo    3. Rode as migracoes: cd backend ^&^& sqlx migrate run
echo    4. Inicie o backend: cd backend ^&^& cargo run
echo    5. Em outro terminal, inicie o frontend: cd frontend ^&^& trunk serve
echo.
echo ?? O portal estara disponivel em http://localhost:8080
echo.
pause
