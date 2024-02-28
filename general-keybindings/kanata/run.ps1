$root = $PSScriptRoot
if ('' -eq $root -or $null -eq $root)
{
    $root = $pwd
}
$exePath = [System.IO.Path]::Combine($root, "kanata.exe")
$configPath = [System.IO.Path]::Combine($root, "spacefn.kbd")

& $exePath --cfg $configPath