@echo off

cls
setlocal enabledelayedexpansion

set PYTHON_PATH=
set PIP_PATH=

if exist "C:\Users\Maske\AppData\Local\Programs\Python\Python311\python.exe" (
    set PYTHON_PATH=C:\Users\Maske\AppData\Local\Programs\Python\Python311\python.exe
    set PIP_PATH=C:\Users\Maske\AppData\Local\Programs\Python\Python311\Scripts\pip.exe
) else if exist "C:\Program Files\Python311\python.exe" (
    set PYTHON_PATH=C:\Program Files\Python311\python.exe
    set PIP_PATH=C:\Program Files\Python311\Scripts\pip.exe
) else (

    set PYTHON_PATH=python
    set PIP_PATH=pip
)

echo.
echo     █████████    █████████    █████████               █████████    █████████   ██████   ██████
echo    ███▒▒▒▒▒███  ███▒▒▒▒▒███  ███▒▒▒▒▒███             ███▒▒▒▒▒███  ███▒▒▒▒▒███ ▒▒██████ ██████ 
echo   ▒███    ▒▒▒  ▒███    ▒███ ▒███    ▒▒▒             ███     ▒▒▒  ▒███    ▒███  ▒███▒█████▒███ 
echo   ▒▒█████████  ▒███████████ ▒▒█████████  ██████████▒███          ▒███████████  ▒███▒▒███ ▒███ 
echo    ▒▒▒▒▒▒▒▒███ ▒███▒▒▒▒▒███  ▒▒▒▒▒▒▒▒███▒▒▒▒▒▒▒▒▒▒ ▒███          ▒███▒▒▒▒▒███  ▒███ ▒▒▒  ▒███ 
echo    ███    ▒███ ▒███    ▒███  ███    ▒███           ▒▒███     ███ ▒███    ▒███  ▒███      ▒███ 
echo   ▒▒█████████  █████   █████▒▒█████████             ▒▒█████████  █████   █████ █████     █████
echo     ▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒   ▒▒▒▒▒  ▒▒▒▒▒▒▒▒▒               ▒▒▒▒▒▒▒▒▒  ▒▒▒▒▒   ▒▒▒▒▒ ▒▒▒▒▒     ▒▒▒▒▒
echo.
echo  ============================================================================
echo  Version: 1.0.0
echo  Status: Installing dependencies for SAS-CAM...
echo.
echo  ============================================================================
echo.

%PYTHON_PATH% --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH
    echo.
    echo Python path: %PYTHON_PATH%
    echo.
    echo Please install Python from: https://www.python.org/downloads/
    echo During installation, make sure to check "Add Python to PATH"
    echo.
    pause
    exit /b 1
)

echo [INFO] Python is installed. Checking version...
for /f "tokens=2" %%i in ('%PYTHON_PATH% --version 2^>^&1') do set PYTHON_VERSION=%%i
echo [SUCCESS] Python %PYTHON_VERSION% detected
echo.

%PIP_PATH% --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] pip is not available
    echo [INFO] Attempting to install pip...
    %PYTHON_PATH% -m ensurepip --upgrade
    if errorlevel 1 (
        echo [ERROR] Failed to install pip
        pause
        exit /b 1
    )
)

echo [INFO] pip is available and ready
%PIP_PATH% --version
echo.

echo [INFO] Setting up virtual environment...
if not exist "venv" (
    echo [ACTION] Creating virtual environment...
    %PYTHON_PATH% -m venv venv
    if errorlevel 1 (
        echo [WARNING] Failed to create virtual environment
        echo [INFO] Continuing without venv...
    ) else (
        echo [SUCCESS] Virtual environment created
        call venv\Scripts\activate.bat
        echo [SUCCESS] Virtual environment activated
    )
)

echo.
echo ============================================================================
echo [ACTION] Installing Python dependencies...
echo ============================================================================
echo.

if exist "requirements.txt" (
    echo [INFO] Installing packages from requirements.txt...
    %PIP_PATH% install -r requirements.txt --upgrade
    
    if errorlevel 1 (
        echo [ERROR] Failed to install some packages
        echo [INFO] Please check your internet connection and try again
        pause
        exit /b 1
    )
) else (
    echo [ERROR] requirements.txt not found
    pause
    exit /b 1
)

echo.
echo ============================================================================
echo [SUCCESS] Installation completed successfully!
echo ============================================================================
echo.
echo You can now run the application with:
echo.
echo For more information, see README.md
echo.
run.bat
pause
