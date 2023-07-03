Set-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge `
                -Name ConfigureKeyboardShortcuts `
                -Value '{"disabled": ["downloads"]}'