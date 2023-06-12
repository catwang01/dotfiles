if (Test-Path ~/.config/profiles/profile_public.ps1)
{
    Import-Module ~/.config/profiles/profile_public.ps1
}

if (Test-Path ~/.config/profiles/profile_private.ps1)
{
    Import-Module ~/.config/profiles/profile_private.ps1
}