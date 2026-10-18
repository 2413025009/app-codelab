@echo off
TITLE CodeLab AI - Mobile Flutter
cd /d "%~dp0"
if exist "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe" (
    set "CHROME_EXECUTABLE=C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
) else if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\Application\brave.exe" (
    set "CHROME_EXECUTABLE=%LOCALAPPDATA%\BraveSoftware\Brave-Browser\Application\brave.exe"
)
flutter run -d chrome