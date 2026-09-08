#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ "$(id -u)" -eq 0 ]; then
    install_cmd=install
else
    install_cmd="sudo install"
fi

$install_cmd -Dm755 "$script_dir/run.sh" \
    /usr/local/bin/exwm-session
$install_cmd -Dm644 "$script_dir/exwm.desktop" \
    /usr/local/share/xsessions/exwm.desktop

printf '%s\n' "Installed EXWM session files."
