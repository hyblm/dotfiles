#!/bin/sh
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
launcher=/usr/local/bin/exwm-session
desktop=/usr/local/share/xsessions/exwm.desktop

if [ "$(id -u)" -eq 0 ]; then
    install_cmd=install
    rm_cmd=rm
    rmdir_cmd=rmdir
else
    install_cmd="sudo install"
    rm_cmd="sudo rm"
    rmdir_cmd="sudo rmdir"
fi

confirm_changed_file() {
    path=$1
    expected=$2

    if [ ! -e "$path" ]; then
        return 1
    fi

    if cmp -s "$expected" "$path"; then
        return 0
    fi

    printf 'File differs from the EXWM repository version: %s\n' "$path" >&2
    printf 'Remove it anyway? [y/N] ' >&2
    if [ ! -t 0 ]; then
        printf 'Cannot prompt without a terminal; leaving it untouched.\n' >&2
        return 1
    fi

    answer=
    IFS= read -r answer || true
    case $answer in
        y|Y|yes|YES) return 0 ;;
        *) printf 'Leaving %s untouched.\n' "$path" >&2; return 1 ;;
    esac
}

removed=0
if confirm_changed_file "$launcher" "$script_dir/run.sh"; then
    $rm_cmd -- "$launcher"
    removed=1
fi
if confirm_changed_file "$desktop" "$script_dir/exwm.desktop"; then
    $rm_cmd -- "$desktop"
    removed=1
fi

# Remove now-empty install directories only; never remove non-empty directories.
if [ "$removed" -eq 1 ]; then
    $rmdir_cmd /usr/local/share/xsessions 2>/dev/null || true
    $rmdir_cmd /usr/local/bin 2>/dev/null || true
fi

printf '%s\n' 'EXWM session files uninstalled (modified files not confirmed for removal were kept).'
