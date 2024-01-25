. "$PSScriptRoot\utils.ps1"

winget-install Autohotkey.Autohotkey

$jobName = "Dotfile-Autohotkey"
$path = ".\general-keybings\autohotkeys\run-autohotkeys.ps1"

$jobExists = $false
try 
{
    Get-ScheduledJob $jobName
}
catch
{
    $trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:30
    Register-ScheduledJob -Trigger $trigger -FilePath $path -Name Dotfile-Autohotkey
    Write-Host "Schedule job ${jobName} is registered successfully"
    $jobExists = $true
}
if ($jobExists)
{

    Write-Host "Scheduled Job ${jobName} already exists, no need to create it"
}