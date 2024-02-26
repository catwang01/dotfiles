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
        [string]$workingDirectory=$null
    )
    Register-ScheduledJob -InitializationScript { Set-Location $workingDirectory }  -FilePath $filePath -Name $jobName  -RunNow
}