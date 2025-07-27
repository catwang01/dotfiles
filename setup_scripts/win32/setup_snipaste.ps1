. "$PSScriptRoot\utils.ps1"

choco install snipaste -y

$snipastePath = Get-ChocoInstallPath -PackageName "Snipaste"

if ([String]::IsNullOrEmpty($snipastePath)) {
    Write-Host "Snipaste not found, please install it first"
    exit 1
}

$exePath = "$snipastePath\Snipaste.exe"
Register-AsStartUpTask -TaskName "Snipaste" -ExecutablePath $exePath -LogonType "Interactive" -Force
Get-ScheduledTask -TaskName "Snipaste" | Start-ScheduledTask