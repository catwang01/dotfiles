. "$PSScriptRoot\utils.ps1"
choco install altdrag -y

$altDragHome = "$env:APPDATA\AltDrag"
$exePath = "$altDragHome\AltDrag.exe"
$scriptBlock = [scriptblock]::Create("& $exePath")

&$scriptBlock

Register-StartUp -scriptBlock $scriptBlock `
        -scheduleJobName "dotfile-AltDrag" `
        -workingDirectory $altDragHome

# Create-StartupScript -ScriptBlock {
#         $altDragHome = "$env:APPDATA\AltDrag"
#         $exePath = "$altDragHome\AltDrag.exe"
#         & $exePath
# } -SymbolName "dotfile-AltDrag"