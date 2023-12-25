try {
    oh-my-posh version
}
catch {
    Write-Host "The oh-my-posh is not installed, Installing it now"
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
}