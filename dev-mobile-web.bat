@echo off
TITLE CodeLab AI - Web Flutter (API PRODUKSI web.id)
cd /d "%~dp0"
if exist "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe" (
    set "CHROME_EXECUTABLE=C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
) else if exist "%LOCALAPPDATA%\BraveSoftware\Brave-Browser\Application\brave.exe" (
    set "CHROME_EXECUTABLE=%LOCALAPPDATA%\BraveSoftware\Brave-Browser\Application\brave.exe"
)
flutter run -d chrome --dart-define=API_BASE_URL=https://api.codelab-ai.web.id/api/v1
