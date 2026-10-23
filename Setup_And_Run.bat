@echo off
setlocal enabledelayedexpansion
title LumiHUD - Setup & Launcher

echo ======================================================
echo    ✦ LumiHUD - Universal Hardware Monitor Setup ✦
echo ======================================================
echo.

cd /d "%~dp0"

:: 1. Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Python is not installed on this PC.
    echo [*] Attempting to install Python automatically via winget...
    winget install Python.Python.3.12 --silent --accept-package-agreements --accept-source-agreements
    if %errorlevel% neq 0 (
        echo [X] Could not auto-install Python. Please install Python from https://www.python.org/
        pause
        exit /b 1
    )
    echo [*] Python installed! Please restart this script once.
    pause
    exit /b 0
)

:: 2. Check and install Python dependencies
echo [*] Checking dependencies (PyQt6, psutil, pywin32)...
pip install -r requirements.txt --quiet --disable-pip-version-check
if %errorlevel% neq 0 (
    echo [!] Installing dependencies...
    pip install PyQt6 psutil pywin32
)

:: 3. Create Desktop Shortcut for easy 1-click launch anytime
echo [*] Creating Desktop Shortcut...
powershell -NoProfile -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\LumiHUD.lnk'); $Shortcut.TargetPath = '%~dp0Run_Monitor.bat'; $Shortcut.WorkingDirectory = '%~dp0'; $Shortcut.Description = 'LumiHUD - Live Hardware Monitor'; $Shortcut.Save()" >nul 2>&1

:: 4. Launch LumiHUD silently
echo [*] Launching LumiHUD...
start "" pythonw "%~dp0monitor.py"
echo [OK] LumiHUD is now running! You can also use the Desktop shortcut.
timeout /t 2 >nul
exit
