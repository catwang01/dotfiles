# $DebugPreference = 'Continue'

$env:Path += ";$env:ProgramFiles\Git\bin"
$env:Path += ";$env:ProgramFiles\Git\usr\bin"

if (Get-Module -ListAvailable PowershellGet) {
  Import-Module PowerShellGet
}

# PSReadLine
if (Get-InstalledModule PSReadLine) {
  Write-Debug "PSReadLine is installed"
  Import-Module PSReadline
  try {
    if ($host.Version.Major -eq 7) {
      #only PS 7 supports HistoryAndPlug
      Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    }
    else {
      Set-PSReadLineOption -PredictionSource History
    }

    #add background color to the prediction preview
    Set-PSReadLineOption -Colors @{InlinePrediction = "$([char]0x1b)[36;7;238m]" }
  }
  catch {
    # Write-Error "run into error"
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

  $global:prevKeyPressTime = 0  
  
  Set-PSReadLineKeyHandler -Chord 'j' -ScriptBlock {  
    $currentTime = [System.DateTime]::Now.Ticks  
    $timeDifference = $currentTime - $global:prevKeyPressTime  
    $global:prevKeyPressTime = $currentTime  
  
    if ([Microsoft.PowerShell.PSConsoleReadLine]::InViInsertMode() -and $timeDifference -gt 1000000) {  
      $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")  
      if ($key.Character -eq 'k') {  
        [Microsoft.PowerShell.PSConsoleReadLine]::ViCommandMode()  
      }  
      else {  
        [Microsoft.Powershell.PSConsoleReadLine]::Insert('j')  
        [Microsoft.Powershell.PSConsoleReadLine]::Insert($key.Character)  
      }  
    }  
    else {  
      [Microsoft.Powershell.PSConsoleReadLine]::Insert('j')  
    }  
  }  

  if ($host.Version.Major -eq 7) {
    #change the key to accept suggestions (default is right arrow)
    Set-PSReadLineKeyHandler -Function AcceptSuggestion -Key 'ctrl+l'
  }
}
else {
  Write-Debug "PSReadLine not installed"
}

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

if (Get-Command oh-my-posh) {
  Write-Debug "oh-my-posh is installed"
  $env:Path += ";$HOME\AppData\Local\Programs\oh-my-posh\bin\"
  # add the path of thems, will be used in the next sections
  $env:POSH_THEMES_PATH = "$HOME\AppData\Local\Programs\oh-my-posh\themes\"
  oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\stelbent-compact.minimal.omp.json" | Invoke-Expression
  # $env:POSH_GIT_ENABLED = $true
}
else {
  Write-Debug "oh-my-posh is not installed"
}

$env:Path += ";$env:ProgramFiles\Neovim\bin\"

# https://docs.gitignore.io/install/command-line
#For PowerShell v3
Function gig {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$list
  )
  $params = ($list | ForEach-Object { [uri]::EscapeDataString($_) }) -join ","
  Invoke-WebRequest -Uri "https://www.toptal.com/developers/gitignore/api/$params" | select -ExpandProperty content | Out-File -FilePath $(Join-Path -path $pwd -ChildPath ".gitignore") -Encoding ascii
}


if (Get-InstalledModule ZLocation) {
  Write-Debug "ZLocation is installed"
  Import-Module ZLocation
}
else {
  Write-Debug "ZLocation not installed"
}

# Anaconda3
$env:ANACONDA3_HOME = "$HOME\Anaconda3"
$env:Path += ";$env:ANACONDA3_HOME"

# unison
$env:UNISON_HOME = "$HOME\source\Notes\Softwares\unison"
$env:Path += ";$env:UNISON_HOME\bin"

if (Get-Command carapace) {
  Write-Debug "carapace is installed"
  $env:Path += ";$env:LOCALAPPDATA\Microsoft\WinGet\Packages\rsteube.Carapace_Microsoft.Winget.Source_8wekyb3d8bbwe\"
  Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
  # carapace only support PS 7
  if ($host.Version.Major -eq 7) {
    Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
    carapace _carapace | Out-String | Invoke-Expression
  }
}
else {
  Write-Debug "carapace not installed"
}

$env:PYTHONIOENCODING="utf-8"
iex $($(thefuck --alias) | Out-String)