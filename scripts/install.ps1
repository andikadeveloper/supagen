# install.ps1 - Supagen CLI Windows Installation Script
# Check if the script is running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script requires administrative privileges. Please run it as an administrator."
    exit 1
}

# Check current execution policy
$executionPolicy = Get-ExecutionPolicy
if ($executionPolicy -ne "RemoteSigned") {
    Write-Host "Current execution policy is $executionPolicy. Changing it to RemoteSigned for this session."
    
    try {
        # Temporarily set the execution policy for the current session
        Set-ExecutionPolicy RemoteSigned -Scope Process -Force
        Write-Host "Execution policy changed to RemoteSigned for this session."
    } catch {
        Write-Host -ForegroundColor Red "Failed to change execution policy. Please run the script as an administrator and manually adjust the policy."
        exit 1
    }
}

Function CleanUp {
    Remove-Item -Path "$env:USERPROFILE\supagen.zip" -Force -ErrorAction SilentlyContinue
}

Function Write-ErrorLine {
    param ($msg)
    Write-Host -ForegroundColor Red "error: $msg"
    exit 1
}

Function Write-Info {
    param ($msg)
    Write-Host -ForegroundColor Gray $msg
}

Function Write-Success {
    param ($msg)
    Write-Host -ForegroundColor Green $msg
}

# Detect OS architecture
$ARCH = if ([Environment]::Is64BitOperatingSystem) { 'x64' } else { 'x86' }
$github_repo = "supagen/supagen"

# Get the latest Supagen version
try {
    $SUPAGEN_VERSION = Invoke-RestMethod -Uri "https://api.github.com/repos/$github_repo/releases/latest" | Select-Object -ExpandProperty tag_name
} catch {
    Write-ErrorLine "Failed to fetch the latest Supagen version from GitHub."
}

# Construct the download URL based on the architecture and version
$downloadUrl = "https://github.com/$github_repo/releases/download/$SUPAGEN_VERSION/supagen-$SUPAGEN_VERSION-windows-$ARCH.zip"
Write-Info "Attempting to download from: $downloadUrl"

# Define destination folder and file paths
$destinationFolder = "$env:USERPROFILE\supagen"
$zipFilePath = "$destinationFolder\supagen.zip"

if (-not (Test-Path -Path $destinationFolder)) {
    New-Item -Path $destinationFolder -ItemType Directory
}

# Download Supagen CLI
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFilePath -ErrorAction Stop
    Write-Info "Downloaded Supagen CLI successfully."
} catch {
    Write-ErrorLine "Failed to download Supagen from $downloadUrl. $_"
}

# Check if the ZIP file was downloaded successfully
if (-not (Test-Path -Path $zipFilePath) -or (Get-Item $zipFilePath).Length -lt 1024) {
    Write-ErrorLine "The downloaded file is missing or too small. Please check the download URL."
}

# Extract the ZIP file
Write-Info "Extracting Supagen CLI..."
try {
    # Check if the file is a valid ZIP archive before extracting
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipFilePath, $destinationFolder)
    Write-Info "Extraction completed successfully."
} catch {
    Write-ErrorLine "Extraction failed. Please check if the file is a valid ZIP archive. $_"
}

$PathFolder = "$env:USERPROFILE\supagen\supagen"

# Verify installation
$supagenBat = "$destinationFolder\supagen\supagen.bat"
if (-not (Test-Path -Path $supagenBat)) {
    Write-ErrorLine "supagen.bat not found in the extracted folder. Please check the installation."
}

# Add Supagen to the PATH
$envPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
if (-not $envPath.Contains($PathFolder)) {
    [System.Environment]::SetEnvironmentVariable("Path", "$envPath;$PathFolder", [System.EnvironmentVariableTarget]::User)
    Write-Success "Supagen CLI has been added to the PATH."
} else {
    Write-Info "Supagen CLI is already in the PATH."
}

# Function to check Supagen version
function supagen_version {
    Clear-Host
    & "$supagenBat" version
    & "$supagenBat"
}

# Step 4: Verify Installation
try {
    $output = & "$supagenBat" version 2>&1 | Out-String

    # Output should be parsed to find the version number
    if ($output -match "Version:\s*(.*)") {
        $INSTALLED_SUPAGEN_VERSION = $matches[1].Trim()
        if ($INSTALLED_SUPAGEN_VERSION -eq $SUPAGEN_VERSION) {
            Write-Success "Supagen $INSTALLED_SUPAGEN_VERSION installed successfully."
            Write-Success "Please close this window and open a new one for using supagen."
        } else {
            Write-ErrorLine "Supagen version verification failed. Installed version: $INSTALLED_SUPAGEN_VERSION, Expected version: $SUPAGEN_VERSION."
        }
    } else {
        Write-ErrorLine "Failed to parse Supagen version output. Output: $output"
    }
} catch {
    Write-ErrorLine "Installation failed. Exiting. $_"
}

# Run the supagen_version function after successful installation
Write-Info "Running Supagen version check and command execution..."
try {
    supagen_version
} catch {
    Write-ErrorLine "Failed to execute Supagen command. $_"
}

Write-Success "Installation complete. Please close this window and open a new one for using supagen."