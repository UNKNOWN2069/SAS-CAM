@echo off

setlocal enabledelayedexpansion

set PYTHON_PATH=C:\Users\Maske\AppData\Local\Programs\Python\Python311\python.exe

if not exist "%PYTHON_PATH%" (
    echo [ERROR] Python not found at: %PYTHON_PATH%
    echo.
    echo Please ensure Python 3.11 is installed in the default location
    echo Or edit this file to set the correct PYTHON_PATH
    pause
    exit /b 1
)

echo [INFO] Starting SAS-CAM...
echo.
"%PYTHON_PATH%" "%~dp0start.py"

if errorlevel 1 (
    echo.
    echo [ERROR] Application exited with error code: %errorlevel%
    pause
)
