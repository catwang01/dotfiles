Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

$moduleName = "ZLocation"

if (Get-Module $moduleName) 
{ 
    Write-Host "$moduleName is installed!" 
}
else
{ 
    Install-Module $moduleName -Scope CurrentUser -Force 
}