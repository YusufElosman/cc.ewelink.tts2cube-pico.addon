@echo off
REM Batch script for publishing Docker image on Windows
REM Usage: publish.bat

echo ========================================
echo   TTS2CUBE-Pico Docker Image Publisher
echo   Platform: Windows (Batch)
echo ========================================
echo.

REM Read version from file
set /p IMAGE_VERSION=<..\version
echo Version: %IMAGE_VERSION%
echo.

REM 1. Input Docker image name
set /p IMAGE_NAME="Docker image name (e.g., username/tts2cube-pico): "

if "%IMAGE_NAME%"=="" (
    echo Error: Image name cannot be empty!
    pause
    exit /b 1
)

echo.
echo Building Docker images...
echo.

REM 2. Build Docker image
echo Building: %IMAGE_NAME%:latest
docker build -t %IMAGE_NAME% --platform=linux/arm/v7 .

if errorlevel 1 (
    echo Error: Failed to build %IMAGE_NAME%:latest
    pause
    exit /b 1
)

echo Building: %IMAGE_NAME%:v%IMAGE_VERSION%
docker build -t %IMAGE_NAME%:v%IMAGE_VERSION% --platform=linux/arm/v7 .

if errorlevel 1 (
    echo Error: Failed to build %IMAGE_NAME%:v%IMAGE_VERSION%
    pause
    exit /b 1
)

echo.
echo Build completed successfully!
echo.

REM 3. Login Docker Hub account
echo Docker Hub Login
set /p USERNAME="Docker Hub username: "
set /p PASSWORD="Docker Hub password: "

echo.
echo Logging in to Docker Hub...
docker login -u=%USERNAME% -p=%PASSWORD%

if errorlevel 1 (
    echo Error: Docker Hub login failed!
    pause
    exit /b 1
)

echo Login successful!
echo.

REM 4. Push Docker images
echo Pushing Docker images...
echo.

echo Pushing: %IMAGE_NAME%:latest
docker push %IMAGE_NAME%

if errorlevel 1 (
    echo Error: Failed to push %IMAGE_NAME%:latest
    docker logout
    pause
    exit /b 1
)

echo Pushing: %IMAGE_NAME%:v%IMAGE_VERSION%
docker push %IMAGE_NAME%:v%IMAGE_VERSION%

if errorlevel 1 (
    echo Error: Failed to push %IMAGE_NAME%:v%IMAGE_VERSION%
    docker logout
    pause
    exit /b 1
)

echo.
echo Push completed successfully!
echo.

REM 5. Logout Docker Hub account
echo Logging out from Docker Hub...
docker logout

echo.
echo ========================================
echo   Published successfully!
echo ========================================
echo.
echo Images published:
echo   - %IMAGE_NAME%:latest
echo   - %IMAGE_NAME%:v%IMAGE_VERSION%
echo.
echo You can now pull the image on iHost:
echo   docker pull %IMAGE_NAME%:latest
echo.

pause
