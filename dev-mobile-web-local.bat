@echo off
TITLE CodeLab AI - Web Flutter (API LOKAL localhost:8080)
cd /d "%~dp0"
if exist "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe" (
    set "CHROME_EXECUTABLE=C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
) else if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\Application\brave.exe" (
    set "CHROME_EXECUTABLE=%LOCALAPPDATA%\BraveSoftware\Brave-Browser\Application\brave.exe"
)
flutter run -d chrome
