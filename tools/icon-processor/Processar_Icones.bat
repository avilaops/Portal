@echo off
REM =========================================
REM Processador de Icones - Interface Grafica
REM =========================================

title Processador de Icones 2025

REM Verifica se Python esta instalado
python --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo [ERRO] Python nao encontrado!
    echo.
    echo Por favor, instale o Python 3.x de:
    echo https://www.python.org/downloads/
    echo.
    pause
    exit /b 1
)

REM Verifica se as dependencias estao instaladas
echo Verificando dependencias...
python -c "import rembg, PIL, numpy, tkinter" >nul 2>&1
if errorlevel 1 (
    echo.
    echo [AVISO] Instalando dependencias necessarias...
    echo.
    pip install rembg pillow numpy
    if errorlevel 1 (
        echo.
        echo [ERRO] Falha ao instalar dependencias!
        echo.
        pause
        exit /b 1
    )
)

REM Executa a interface grafica
echo.
echo Iniciando Processador de Icones...
echo.
python "%~dp0icon_processor_gui.py"

REM Se houver erro na execucao
if errorlevel 1 (
    echo.
    echo [ERRO] Ocorreu um erro ao executar o programa!
    echo.
    pause
)

exit /b 0
