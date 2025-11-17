@echo off
echo.
echo ========================================
echo ?? Instalando Rust
echo ========================================
echo.

echo ?? Baixando rustup-init.exe...
powershell -Command "Invoke-WebRequest -Uri 'https://win.rustup.rs/x86_64' -OutFile '%TEMP%\rustup-init.exe'"

echo.
echo ?? Executando instalador do Rust...
echo    Escolha a opcao padrao (1) quando perguntado
echo.

%TEMP%\rustup-init.exe

echo.
echo ? Rust instalado!
echo.
echo ?? IMPORTANTE: Feche e abra o terminal novamente para usar o Rust
echo.
echo Depois execute:
echo    setup.bat
echo.
pause
