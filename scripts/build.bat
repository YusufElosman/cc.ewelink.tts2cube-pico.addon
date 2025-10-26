@echo off
setlocal enabledelayedexpansion

REM Read version from file
set /p build_version=<version

REM Clear web .env
if exist packages\web\.env del packages\web\.env
echo VITE_VERSION=%build_version%> packages\web\.env

REM Clean and create build directory
if exist build rmdir /s /q build
mkdir build

REM Run lerna build
call npx lerna run build

REM Copy server files
xcopy /E /I /Y packages\server\dist build\server

REM Copy web files
xcopy /E /I /Y packages\web\dist build\public

REM Copy docker files
copy docker\Dockerfile build\
copy docker\publish.sh build\
copy docker\.dockerignore build\
copy version build\

REM Create buildinfo
(
echo Build Version: %build_version%
echo Build Date: %date% %time%
) > .\build\buildinfo
