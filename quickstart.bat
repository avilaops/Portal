@echo off
REM Quick start com Docker - Windows

echo.
echo ========================================
echo ?? Avila Portal - Quick Start
echo ========================================
echo.

REM Verificar Docker
where docker >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ? Docker nao encontrado. Instale: https://docs.docker.com/get-docker/
    pause
    exit /b 1
)

echo ? Docker encontrado
echo.

REM Criar .env se não existir
if not exist backend\.env (
    echo ?? Criando arquivo .env...
    copy backend\.env.example backend\.env
)

REM Iniciar serviços
echo ?? Iniciando PostgreSQL e Redis...
docker-compose up -d postgres redis

echo.
echo ? Aguardando servicos ficarem prontos...
timeout /t 5 /nobreak >nul

echo.
echo ? Servicos prontos!
echo.
echo ?? Proximos passos:
echo    Terminal 1 - Backend:
echo    cd backend ^&^& cargo run
echo.
echo    Terminal 2 - Frontend:
echo    cd frontend ^&^& trunk serve --open
echo.
echo ?? Portal: http://localhost:8080
echo ?? PostgreSQL: localhost:5432
echo ?? Redis: localhost:6379
echo.
pause
