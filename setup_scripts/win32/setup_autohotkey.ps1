. "$PSScriptRoot\utils.ps1"

winget-install Autohotkey.Autohotkey

$jobName = "Dotfile-Autohotkey"
$path = ".\general-keybindings\autohotkeys\run-autohotkeys.ps1"

$jobExists = $false
try 
{
    Get-ScheduledJob $jobName
}
catch
{
    $trigger = New-JobTrigger -Once -At "09/12/2013 1:00:00" -RepetitionInterval (New-TimeSpan -Minutes 2) -RepetitionDuration (New-Timespan -Hours 48)
    Register-ScheduledJob -Trigger $trigger -FilePath $path -Name Dotfile-Autohotkey
    Write-Host "Schedule job ${jobName} is registered successfully"
    $jobExists = $true
}
if ($jobExists)
{

    Write-Host "Scheduled Job ${jobName} already exists, no need to create it"
}