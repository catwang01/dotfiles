. "$PSScriptRoot\utils.ps1"
choco install altdrag -y

$exePath = Get-ChocoInstallPath -PackageName "AltDrag"
if ([String]::IsNullOrEmpty($exePath)) {
    Write-Host "AltDrag not found, please install it first"
    exit 1
}

Register-AsStartUpTask -TaskName "AltDrag" -ExecutablePath $exePath -LogonType "Interactive" -Force
Get-ScheduledTask -TaskName "AltDrag" | Start-ScheduledTask

# $altDragHome = "$env:APPDATA\AltDrag"
# $exePath = "$altDragHome\AltDrag.exe"
# $scriptBlock = [scriptblock]::Create(@"
#         if (Get-Process | Where-Object { `$_.Name -eq 'AltDrag' })
#         {
#             Write-Host "AltDrag is already running"
#         }
#         else
#         {
#             & $exePath
#         }
# "@)

# &$scriptBlock

# Register-StartUp -scriptBlock $scriptBlock `
#         -scheduleJobName "dotfile-AltDrag" `
#         -workingDirectory $altDragHome

# Create-StartupScript -ScriptBlock {
#         $altDragHome = "$env:APPDATA\AltDrag"
#         $exePath = "$altDragHome\AltDrag.exe"
#         & $exePath
# } -SymbolName "dotfile-AltDrag"