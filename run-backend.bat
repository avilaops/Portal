@echo off
echo.
echo ========================================
echo Backend - Portal Avila
echo ========================================
echo.
echo Iniciando servidor Rust...
echo.

cd backend
set DATABASE_URL=sqlite:portal.db
cargo run --bin server

pause
