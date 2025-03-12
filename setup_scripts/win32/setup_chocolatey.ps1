
try
{ 
    choco
    Write-Host 'chocolatey is installed!'
}
catch 
{
    Write-Host 'chocolatey is not installed yet. Installing it...'
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}