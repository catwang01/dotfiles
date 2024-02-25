$root = $PSScriptRoot
$configPath = [System.IO.Path]::Combine($root, "spacefn.kbd")
& "$root/kanata.exe" --cfg $configPath