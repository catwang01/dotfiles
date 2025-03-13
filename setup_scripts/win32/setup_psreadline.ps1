# Check if PSReadLine module is installed
$psReadLineModule = Get-Module -ListAvailable -Name PSReadLine

if ($psReadLineModule) {
    # Get the installed version of PSReadLine
    $installedVersion = $psReadLineModule.Version
    Write-Host "PSReadLine module is installed. Current version: $installedVersion"

    # Define the minimum version you want (e.g., 2.1.0)
    $minVersion = [version] "2.1.0"

    # Compare versions
    if ($installedVersion -lt $minVersion) {
        Write-Host "PSReadLine version is outdated. Updating..."
        
        # Update PSReadLine module
        Install-Module -Name PSReadLine -Force -SkipPublisherCheck
        Write-Host "PSReadLine has been updated to the latest version."
    } else {
        Write-Host "PSReadLine is up-to-date."
    }
} else {
    Write-Host "PSReadLine module is not installed. Installing..."

    # Install PSReadLine module if not installed
    Install-Module -Name PSReadLine -Force -SkipPublisherCheck
    Write-Host "PSReadLine has been installed."
}