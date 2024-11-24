#!/bin/bash
this_dir=$(dirname -- "$( readlink -f -- "$0"; )")

# check if is macos 11 or newer
macos_version=$(sw_vers -productVersion)
major_version=$(echo $macos_version | cut -d '.' -f 1)

if [ "$major_version" -ge 11 ]; then
    echo "macOS version is 11 or newer"
    echo "Downloading Karabiner-VirtualHIDDevice-Manager..."
    downloadPath="$HOME/Downloads/Karabiner-DriverKit-VirtualHIDDevice-5.0.0.pkg"
    curl 'https://raw.githubusercontent.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/refs/heads/main/dist/Karabiner-DriverKit-VirtualHIDDevice-5.0.0.pkg' -k -L -o "$downloadPath"
    if [ "$?" -ne 0 ]; then
        echo "Failed to download Karabiner-VirtualHIDDevice-Manager!"
        exit 1
    fi
    sudo installer -verbose -pkg "$downloadPath" -target /
    /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
else
    echo "macOS version is older than 11"
fi

# check if kanata is installed by brew
if brew list -1 | grep -q "^kanata\$"; then
    echo "Kanata is already installed"
else
    echo "Kanata is not installed, installing now"
    brew install kanata
fi

cd "$this_dir/../../general-keybindings/kanata" || exit
python3 register.py