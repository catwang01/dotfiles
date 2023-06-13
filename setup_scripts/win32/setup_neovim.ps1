$res = winget show neovim
if ($res -contains "No packages")
{
    winget install neovim
}
else
{
    Write-Host "Neovim is already installed"
}