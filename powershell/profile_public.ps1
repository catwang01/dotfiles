Set-Alias -Name git -Value "$Env:ProgramFiles\Git\bin\git.exe"
$env:Path += ";$env:ProgramFiles\Git\usr\bin"

# PSReadLine
Import-Module PSReadline
if ($host.Version.Major -eq 7) {
    #only PS 7 supports HistoryAndPlug
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
}
else {
    Set-PSReadLineOption -PredictionSource History
}

Set-PSReadLineOption -EditMode vi

$ESC = "$([char]0x1b)"
$OnViModeChange = [scriptblock] {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "${ESC}[1 q"
    }
    else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "${ESC}[5 q"
    }
}

Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $OnViModeChange

Set-PSReadLineKeyHandler -Chord 'j' -ScriptBlock {
    if ([Microsoft.PowerShell.PSConsoleReadLine]::InViInsertMode()) {
        $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        if ($key.Character -eq 'k') {
            [Microsoft.PowerShell.PSConsoleReadLine]::ViCommandMode()
        }
        else {
            [Microsoft.Powershell.PSConsoleReadLine]::Insert('j')
            [Microsoft.Powershell.PSConsoleReadLine]::Insert($key.Character)
        }
    }
}

#add background color to the prediction preview
Set-PSReadLineOption -Colors @{InlinePrediction = "$([char]0x1b)[36;7;238m]" }
#change the key to accept suggestions (default is right arrow)
Set-PSReadLineKeyHandler -Function AcceptSuggestion -Key 'ctrl+l'

#For PowerShell v3
Function gig {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$list
    )
    $params = ($list | ForEach-Object { [uri]::EscapeDataString($_) }) -join ","
    Invoke-WebRequest -Uri "https://www.toptal.com/developers/gitignore/api/$params" | Select-Object -ExpandProperty content | Out-File -FilePath $(Join-Path -path $pwd -ChildPath ".gitignore") -Encoding ascii
}

function _sudo {
    $ss = "$args ; pause"
    Start-Process powershell -Verb runAs -ArgumentList $ss
}
set-alias -name sudo -value _sudo

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

$env:Path += ";$HOME\AppData\Local\Programs\oh-my-posh\bin\"
# add the path of thems, will be used in the next sections
$env:POSH_THEMES_PATH = "$HOME\AppData\Local\Programs\oh-my-posh\themes\"
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\stelbent-compact.minimal.omp.json" | Invoke-Expression

$env:Path += ";$env:ProgramFiles\Neovim\bin\"