@echo off
TITLE CodeLab AI - Mobile Flutter (API PRODUKSI web.id)
cd /d "%~dp0"
flutter run --dart-define=API_BASE_URL=https://api.codelab-ai.web.id/api/v1
