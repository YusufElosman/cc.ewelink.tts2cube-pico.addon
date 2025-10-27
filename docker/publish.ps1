# PowerShell script for publishing Docker image on Windows
# Usage: .\publish.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TTS2CUBE-Pico Docker Image Publisher" -ForegroundColor Cyan
Write-Host "  Platform: Windows (PowerShell)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Read version from file
$version = Get-Content -Path "../version" -Raw
$version = $version.Trim()

Write-Host "Version: $version" -ForegroundColor Green
Write-Host ""

# 1. Input Docker image name
$imageName = Read-Host "Docker image name (e.g., username/tts2cube-pico)"

if ([string]::IsNullOrWhiteSpace($imageName)) {
    Write-Host "Error: Image name cannot be empty!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Building Docker images..." -ForegroundColor Yellow
Write-Host ""

# 2. Build Docker image
Write-Host "Building: ${imageName}:latest" -ForegroundColor Cyan
docker build -t $imageName --platform=linux/arm/v7 .

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to build ${imageName}:latest" -ForegroundColor Red
    exit 1
}

Write-Host "Building: ${imageName}:v${version}" -ForegroundColor Cyan
docker build -t "${imageName}:v${version}" --platform=linux/arm/v7 .

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to build ${imageName}:v${version}" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host ""

# 3. Login Docker Hub account
Write-Host "Docker Hub Login" -ForegroundColor Yellow
$username = Read-Host "Docker Hub username"
$password = Read-Host "Docker Hub password" -AsSecureString

# Convert secure string to plain text for docker login
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)
$plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

Write-Host ""
Write-Host "Logging in to Docker Hub..." -ForegroundColor Cyan
echo $plainPassword | docker login -u $username --password-stdin

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Docker Hub login failed!" -ForegroundColor Red
    exit 1
}

Write-Host "Login successful!" -ForegroundColor Green
Write-Host ""

# 4. Push Docker images
Write-Host "Pushing Docker images..." -ForegroundColor Yellow
Write-Host ""

Write-Host "Pushing: ${imageName}:latest" -ForegroundColor Cyan
docker push $imageName

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to push ${imageName}:latest" -ForegroundColor Red
    docker logout
    exit 1
}

Write-Host "Pushing: ${imageName}:v${version}" -ForegroundColor Cyan
docker push "${imageName}:v${version}"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to push ${imageName}:v${version}" -ForegroundColor Red
    docker logout
    exit 1
}

Write-Host ""
Write-Host "Push completed successfully!" -ForegroundColor Green
Write-Host ""

# 5. Logout Docker Hub account
Write-Host "Logging out from Docker Hub..." -ForegroundColor Cyan
docker logout

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Published successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Images published:" -ForegroundColor Cyan
Write-Host "  - ${imageName}:latest" -ForegroundColor White
Write-Host "  - ${imageName}:v${version}" -ForegroundColor White
Write-Host ""
Write-Host "You can now pull the image on iHost:" -ForegroundColor Yellow
Write-Host "  docker pull ${imageName}:latest" -ForegroundColor White
Write-Host ""
