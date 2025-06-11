# Find Git installation directory (adjust this if your Git is installed somewhere else)
$gitBasePath = "E:\Program\editmypdf_ai_project\Git"

# Possible Git cmd folder paths
$possiblePaths = @(
    "$gitBasePath\cmd",
    "$gitBasePath\bin",
    "$gitBasePath\usr\bin"
)

# Find the first valid Git cmd folder
$gitCmdPath = $possiblePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $gitCmdPath) {
    Write-Host "Git cmd folder not found. Please verify Git installation path." -ForegroundColor Red
    exit 1
}

# Get current user PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

# Check if Git path is already in PATH
if ($currentPath -notlike "*$gitCmdPath*") {
    # Append Git path to user PATH
    $newPath = "$currentPath;$gitCmdPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "Git cmd folder added to PATH successfully:" -ForegroundColor Green
    Write-Host $gitCmdPath
} else {
    Write-Host "Git cmd folder already exists in PATH." -ForegroundColor Yellow
}

Write-Host "Please restart your terminal or Command Prompt to apply changes." -ForegroundColor Cyan
