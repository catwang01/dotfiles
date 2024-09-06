$root = $PSScriptRoot
if ('' -eq $root -or $null -eq $root)
{
    $root = $pwd
}
$exePath = [System.IO.Path]::Combine($root, "kanata.exe")
$configPath = [System.IO.Path]::Combine($root, "spacefn.kbd")

if (@(Get-Process | Where-Object { $_.Name -eq 'kanata' }).Count -gt 0)
{
    Write-Host "kanata is already running"
}
else
{
    & $exePath --cfg $configPath
}