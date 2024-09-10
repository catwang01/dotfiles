# TODO: extract the common code to a shared script
# this logic can be used for softwares like altdrag, kanata, keyviz, listary, which should be autostarted:
. "$PSScriptRoot\utils.ps1"

Set-StrictMode -Version Latest

$keyVizHome = "$HOME/AppData/Local/Programs/Keyviz"
$exePath = "$keyVizHome\Keyviz.exe"

if (Test-Path $exePath)
{
    Write-Host "Keyviz is already installed"
}
else
{
    Write-Host "Keyviz is not installed, start installing it..."
    winget-install "keyviz"
    Write-Host "Keyviz is installed successfully"
}

$scriptBlock = [scriptblock]::Create(@"
    if (Get-Process | Where-Object { `$_.Name -eq 'Keyviz' })
    {
        Write-Host "Keyviz is already running"
    }
    else
    {
        & $exePath
    }
"@)

&$scriptBlock

Register-StartUp -scriptBlock $scriptBlock `
        -scheduleJobName "dotfile-Keyviz" `
        -workingDirectory $keyVizHome