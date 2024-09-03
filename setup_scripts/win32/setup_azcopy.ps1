# download zip from https://aka.ms/downloadazcopy-v10-windows and extract to C:\azcopy
$uri = "https://aka.ms/downloadazcopy-v10-windows"
$zipPath = "$HOME\Downloads\azcopy.zip"
$extractPath = "${env:ProgramFiles(x86)}"
$executablePath = "$extractPath\azcopy.exe"

if (Test-Path $executablePath)
{
    Write-Host "azcopy already exists in $extractPath, no need to download again"
    exit 0
}
else
{
    if (Test-Path $zipPath)
    {
        Write-Host "azcopy.zip exists, no need to download again"
    }
    else
    {
        Write-Host "Downloading azcopy.zip from $uri"
        Invoke-WebRequest -Uri $uri -OutFile $zipPath
        Write-Host "Downloaded azcopy.zip to $zipPath"
    }
    Write-Host "Extracting azcopy.zip to $extractPath"
    #  extract zip
    Expand-Archive -Path $zipPath -DestinationPath $extractPath
}