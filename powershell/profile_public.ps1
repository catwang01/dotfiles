# $DebugPreference = 'Continue'

# Measure-Script {

$env:Path += ";$env:ProgramFiles\Git\bin"
$env:Path += ";$env:ProgramFiles\Git\usr\bin"

# try {
#   Import-Module PowerShellGet
# }
# catch {
#   Write-Debug "PowerShellGet not installed"
# }

$env:Path += ";$HOME\AppData\Local\Programs\Microsoft VS Code\bin"

# PSReadLine
try {
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

  Set-PSReadLineKeyHandler -Chord 'j' -ScriptBlock {  
    if ([Microsoft.PowerShell.PSConsoleReadLine]::InViInsertMode()) {
      $currentTime = [System.DateTime]::Now.Ticks  
      $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")  
      $nextTime = [System.DateTime]::Now.Ticks  
      $timeDifference = $nextTime - $currentTime
      if ($timeDifference -lt 1000000) {  
        if ($key.Character -eq 'k') {  
          [Microsoft.PowerShell.PSConsoleReadLine]::ViCommandMode()  
        }  
        else
        {
          [Microsoft.Powershell.PSConsoleReadLine]::Insert('j')  
          [Microsoft.Powershell.PSConsoleReadLine]::Insert($key.Character)  
        }
      } 
      else
      {
        [Microsoft.Powershell.PSConsoleReadLine]::Insert('j')  
        [Microsoft.Powershell.PSConsoleReadLine]::Insert($key.Character)  
      }
    }  
  }  

  # Define the custom paste handler function
  function CustomPasteHandler {
      param($key, $arg)
      Add-Type -AssemblyName System.Windows.Forms
      $clipboardContent = [System.Windows.Forms.Clipboard]::GetText()
      [Microsoft.PowerShell.PSConsoleReadLine]::Insert($clipboardContent)
  }

  # Bind the custom paste handler to Ctrl+v
  Set-PSReadLineKeyHandler -Chord "Ctrl+p" -ScriptBlock {
      CustomPasteHandler
  }

  if ($host.Version.Major -eq 7) {
    #change the key to accept suggestions (default is right arrow)
    Set-PSReadLineKeyHandler -Function AcceptSuggestion -Key 'ctrl+l'
  }
}
catch {
  Write-Debug "PSReadLine not installed"
}

function _sudo {
  Start-Process powershell -Verb RunAs -ArgumentList "cd $pwd; $args; pause"
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

try {
  Write-Debug "oh-my-posh is installed"
  $env:Path += ";$HOME\AppData\Local\Programs\oh-my-posh\bin\"
  # add the path of thems, will be used in the next sections
  $env:POSH_THEMES_PATH = "$HOME\AppData\Local\Programs\oh-my-posh\themes\"
  oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\stelbent-compact.minimal.omp.json" | Invoke-Expression
  # $env:POSH_GIT_ENABLED = $true
}
catch {
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
  $content = Invoke-WebRequest -Uri "https://www.toptal.com/developers/gitignore/api/$params" | Select-Object -ExpandProperty content 
  if ($content)
  {
    $content | Out-File -FilePath $(Join-Path -path $pwd -ChildPath ".gitignore") -Encoding ascii -Append
  }
}


# try {
#   Import-Module ZLocation
#   Write-Debug "ZLocation is installed"
# } 
# catch {
#   Write-Debug "ZLocation not installed"
# }

# Anaconda3
$env:ANACONDA3_HOME = "$HOME\Anaconda3"
$env:Path += ";$env:ANACONDA3_HOME"

# unison
$env:UNISON_HOME = "C:\ProgramData\chocolatey\lib\unison\tools"
$env:Path += ";$env:UNISON_HOME\bin"

try {
  Write-Debug "carapace is installed"
  $env:Path += ";$env:LOCALAPPDATA\Microsoft\WinGet\Packages\rsteube.Carapace_Microsoft.Winget.Source_8wekyb3d8bbwe\"
  Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
  # carapace only support PS 7
  if ($host.Version.Major -eq 7) {
    Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
    carapace _carapace | Out-String | Invoke-Expression
  }
}
catch {
  Write-Debug "carapace not installed"
}

# try {
#   $env:PYTHONIOENCODING = "utf-8"
#   iex $($(thefuck --alias) | Out-String)
# }
# catch {
#   Write-Debug "thefuck is not installed"
# }

# adding possible path for winmerge into the $env:PATH
$env:Path += ";${env:ProgramFiles(x86)}\WinMerge\"
$env:Path += ";$HOME\AppData\Local\Programs\WinMerge\"

$outputPath = Get-ChildItem "${env:ProgramFiles(x86)}\azcopy*"
$env:Path += ";$outputPath"

function mydebugpy {
  python -m debugpy --listen 5678 --wait-for-client $args
}
# }
