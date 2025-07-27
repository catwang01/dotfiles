. "$PSScriptRoot\utils.ps1"

winget-install nvm

$ret = nvm list

if ($ret -match "No installations") {
    Write-Host "No node installations found. Installing latest version..."
    nvm install latest
}