@echo off
setlocal

set "EXE_NAME=webview_tv_player.exe"
set "WEBVIEW2_URL=https://go.microsoft.com/fwlink/p/?LinkId=2124703"
set "INSTALLER_NAME=MicrosoftEdgeWebview2Setup.exe"

echo Checking WebView2 Runtime...

reg query "HKLM\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}" /v pv >nul 2>&1
if %errorlevel% equ 0 (
    echo WebView2 Runtime is already installed.
    start "" "%~dp0%EXE_NAME%" %*
    exit /b
)

reg query "HKLM\SOFTWARE\Microsoft\EdgeUpdate\Clients\{F3017226-FE2A-4295-8BDF-00C3A9A7E4C5}" /v pv >nul 2>&1
if %errorlevel% equ 0 (
    echo WebView2 Runtime is already installed.
    start "" "%~dp0%EXE_NAME%" %*
    exit /b
)

echo WebView2 Runtime not found. Downloading...
powershell -Command "Invoke-WebRequest -Uri '%WEBVIEW2_URL%' -OutFile '%~dp0%INSTALLER_NAME%'"

echo Installing WebView2 Runtime (this may take a moment)...
start /wait "" "%~dp0%INSTALLER_NAME%" /silent /install

del "%~dp0%INSTALLER_NAME%" 2>nul

echo Starting application...
start "" "%~dp0%EXE_NAME%" %*

endlocal
