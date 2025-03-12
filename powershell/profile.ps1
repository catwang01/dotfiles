if (Test-Path ~/.config/profiles/profile_public.ps1)
{
    Import-Module ~/.config/profiles/profile_public.ps1
}

if (Test-Path ~/.config/profiles/profile_private.ps1)
{
    Import-Module ~/.config/profiles/profile_private.ps1
}
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
