#!/bin/bash
this_dir=$(dirname -- "$( readlink -f -- "$0"; )")

. general/log.sh

ret="$(ps aux | grep Karabiner-VirtualHIDDevice-Daemon | grep -v 'grep' | wc -l)"
if [[ $ret -eq 0 ]];
then
    log info "Karabiner-VirtualHIDDevice-Daemon is not running, let's start a one"
    sudo '/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon' &
else
    log info "Karabiner-VirtualHIDDevice-Daemon is already running"
fi

KANATA_PATH="/usr/local/bin/kanata"
log info "Kanata path: $KANATA_PATH"
if [[ "$OSTYPE" == "darwin"* ]]; then
    log info "macOS detected"
    sudo "$KANATA_PATH" --cfg "$this_dir/spacefn-mac.kbd"
else
    log info "Non macOS detected"
    sudo "$KANATA_PATH" --cfg "$this_dir/spacefn.kbd"
fi