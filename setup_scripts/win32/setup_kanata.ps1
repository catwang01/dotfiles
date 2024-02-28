using namespace System.IO;
. "$PSScriptRoot\utils.ps1"

$targetDir = [System.IO.Path]::Combine($PSScriptRoot, "..", "..", "general-keybindings", "kanata")
$exePath  = [System.IO.Path]::Combine($targetDir, "kanata.exe")
$downloadUrl = "https://github.com/jtroo/kanata/releases/download/v1.5.0/kanata.exe"
if (Test-Path $exePath) 
{
    Write-Host "kanata is already installed"
} 
else
{
    Write-Host "kanata is not installed, start installing it"
    Invoke-WebRequest $downloadUrl -OutFile $exePath
    Write-Host "kanata is installed successfully"
}

$startupPath = [System.IO.Path]::Combine($targetDir, "run.ps1")
$scheduleJobName = "dotfile-Kanata"

Write-Host "The current startup script is $startupPath"

if (Test-Path $startupPath)
{
    Write-Host "kanata startup script is found, try to register it"
    Register-StartUp -startupPath $startupPath `
            -scheduleJobName $scheduleJobName `
            -workingDirectory $targetDir
    # Create-StartupScript -FilePath $startupPath -SymbolName $scheduleJobName
}
else
{
    Write-Host "kanata startup script is not found"
}