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
        $triggerName,
        [Parameter(Mandatory)]
        $filePath,
        $options,
        [string]$workdingDirectory=$null
    )
    Register-ScheduledJob -FilePath $filePath -Name $jobName  -RunNow

    $CurrentAction = (Get-ScheduledTask -TaskName $jobName).actions

    $Params = @{
        Id               = $CurrentAction.Id
        Argument         = $CurrentAction.Arguments
        Execute          = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
    }

    if ($null -ne $workdingDirectory) {
        $Params.Add('WorkingDirectory', $workdingDirectory)
    }

    $NewAction = New-ScheduledTaskAction @Params

    $NewAction.Id = $CurrentAction.Id

    Set-ScheduledTask -TaskName $jobName -TaskPath '\Microsoft\Windows\PowerShell\ScheduledJobs\' -Action $NewAction
}