
$scriptDirectory = [System.IO.Path]::Combine($PSScriptRoot, "..", "..", "git", "custom", "win32")
Write-Host "Scaning scripts under '$scriptDirectory'"

$scriptPaths = ls $scriptDirectory

$scriptPaths | ForEach-Object {
    $scriptPath = $_.FullName
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($scriptPath)
    $aliasName = $fileName.TrimStart("git-")
    $unixStyleScriptPath = $scriptPath.Replace("\", "/")

    Write-Host "Registering alias 'git $aliasName' for $($_.Name)"
    git config --global "alias.$aliasName" "!Powershell -NoProfile -ExecutionPolicy Bypass -File $unixStyleScriptPath"
}