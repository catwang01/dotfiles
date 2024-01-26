using namespace System.IO;
. .\utils.ps1

$targetDir = [System.IO.Path]::Combine($PSScriptRoot, "..", "..", "general-keybings", "kanata")
$exePath  = [System.IO.Path]::Combine($targetDir, "kanata.exe")
$downloadUrl = "https://github.com/jtroo/kanata/releases/download/v1.5.0/kanata.exe"
if (Test-Path $exePath) 
{
    Write-Host "kanata is already installed"
} 
else
{
    Write-Host "kanata is not installed, start installing it"
    Invoke-WebRequest $downloadUrl -OutFile $exePath
    Write-Host "kanata is installed successfully"
}

$startupPath = [System.IO.Path]::Combine($targetDir, "run.ps1")
$scheduleJobName = "dotfile-Kanata"

Write-Host "The current startup script is $startupPath"

if (Test-Path $startupPath)
{
    Write-Host "kanata startup script is found, try to register it"
    $isScheduledJobExists = $true
    try
    {
        Get-ScheduledJob $scheduleJobName -ErrorAction Stop
    }
    catch
    {
        $isScheduledJobExists = $false
        Write-Host "Scheduled Job doesn't exist, register it!"
        $trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:30
        EasyRegistry-Job -jobName $scheduleJobName `
                            -triggerName $trigger `
                            -filePath $startupPath `
                            -workdingDirectory $targetDir
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
else
{
    Write-Host "kanata startup script is not found"
}