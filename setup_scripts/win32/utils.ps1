function winget-install
{
    Param(
        [string]$package_name
    )
    $res = winget list $package_name
    if ([System.String]::Join("", $res).Contains("No installed package"))
    {
        Write-Host "$package_name is not installed, installing..."
        winget install $package_name
        Write-Host "$package_name is installed"
    }
    else
    {
        Write-Host "$package_name is already installed"
    }
}

function EasyRegistry-Job
{
    Param(
        [Parameter(Mandatory)]
        [string]$jobName,
        # make this required
        [Parameter(Mandatory)]
        $trigger,
        $options,
        [scriptblock]$scriptBlock=$null,
        [string]$filePath=$null,
        [string]$workingDirectory=$null
    )

    $initBlock = [scriptblock]::Create(@" 
        if ('' -ne '$workingDirectory') {
            Set-Location $workingDirectory 
        } 
        # echo "The working directory is `$pwd" | Out-File -Append -FilePath "C:\Users\Public\Documents\log.txt"
"@)
    if ("" -eq $filePath -and $null -eq $scriptBlock)
    {
        throw "Either filePath or scriptBlock is required, no one is provided"
    }
    elseif ("" -ne $filePath -and $null -ne $scriptBlock)
    {
        throw "Either filePath or scriptBlock is required, both are provided: filePath=$filePath, scriptBlock=$scriptBlock"
    }
    elseif ("" -ne $filePath) {
        Register-ScheduledJob -InitializationScript $initBlock -FilePath $filePath -Name $jobName -RunNow -Trigger $trigger -ScheduledJobOption $options
    } 
    else {
        Register-ScheduledJob -InitializationScript $initBlock -ScriptBlock $scriptBlock -Name $jobName -RunNow -Trigger $trigger -ScheduledJobOption $options
    }
}

function Register-StartUp
{
    Param(
        [string]$startupPath=$null,
        [scriptblock]$scriptBlock=$null,
        [Parameter(Mandatory)]
        [string]$scheduleJobName,
        [Parameter(Mandatory)]
        [string]$workingDirectory
    )
    $isScheduledJobExists = $true
    try
    {
        Get-ScheduledJob $scheduleJobName -ErrorAction Stop
    }
    catch
    {
        Write-Host "Working Directory: $workingDirectory"
        $isScheduledJobExists = $false
        Write-Host "Scheduled Job doesn't exist, register it!"
        $jobOptions = New-ScheduledJobOption -RunElevated -ContinueIfGoingOnBattery -StartIfOnBattery
        $trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:30
        EasyRegistry-Job -jobName $scheduleJobName `
                            -trigger $trigger `
                            -options $jobOptions `
                            -filePath $startupPath `
                            -scriptBlock $scriptBlock `
                            -workingDirectory $workingDirectory
    }
    if ($isScheduledJobExists)
    {
        Write-Host "Scheduled Job already exists, no need to create it"
    }
    else
    {
        Write-Host "Scheduled Job is registered successfully"
    }
}
function Create-StartupScript 
{
    param(
        [parameter(Mandatory=$true, Position=0, ParameterSetName='FilePath')]
        [string]$FilePath,

        [parameter(Mandatory=$true, Position=0, ParameterSetName='ScriptBlock')]
        [scriptblock]$ScriptBlock,

        [parameter(Mandatory=$true)]
        [string]$SymbolName
    )

    if ($PSCmdlet.ParameterSetName -eq 'FilePath') {
        $ScriptPath = $FilePath
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'ScriptBlock') {
        $ScriptPath = $null  # Nullify $ScriptPath for direct execution of script block
    }

    $StartupFolderPath = [System.IO.Path]::Combine($env:APPDATA, 'Microsoft\Windows\Start Menu\Programs\Startup')
    $ShortcutPath = Join-Path $StartupFolderPath "$SymbolName.lnk"

    $Shell = New-Object -ComObject WScript.Shell
    $Shortcut = $Shell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = "powershell.exe"
    
    if ($ScriptPath -ne $null) {
        $Shortcut.Arguments = "-NoProfile -NonInterative -ExecutionPolicy Bypass -File `"$ScriptPath`""
    } else {
        $EncodedScriptBlock = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($ScriptBlock.ToString()))
        $Shortcut.Arguments = "-NoProfile -NonInterative -ExecutionPolicy Bypass -EncodedCommand $EncodedScriptBlock"
    }

    $Shortcut.Save()

    Write-Host "Startup script shortcut created: $ShortcutPath"
}

# Example usage:
# Either provide a file path:
# Create-StartupScript -FilePath 'C:\Path\To\Your\Script.ps1'

# Or provide a script block:
# Create-StartupScript -ScriptBlock { Write-Host "Hello, World!" }