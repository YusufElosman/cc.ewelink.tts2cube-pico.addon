@echo off

call npm install

REM Config server
set SERVER_DATA_PATH=%cd%\packages\server\data
if not exist "%SERVER_DATA_PATH%" mkdir "%SERVER_DATA_PATH%"
if not exist "%SERVER_DATA_PATH%\audio" mkdir "%SERVER_DATA_PATH%\audio"

(
echo ENABLE_MIDDLEWARE_LOG=1
echo ENABLE_MIDDLEWARE_AUTH=1
echo ENABLE_PRINT_BUILDINFO=0
echo CONFIG_CUBE_HOSTNAME=ihost.local
echo CONFIG_AUDIO_DATA_PATH=%SERVER_DATA_PATH%
echo CONFIG_TOKEN_DATA_PATH=%SERVER_DATA_PATH%
echo APP_NAME="TTS2CUBE-Pico"
echo LOG_LEVEL=debug
) > .\packages\server\.env
