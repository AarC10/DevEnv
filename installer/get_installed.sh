#!/bin/sh

if command -v apt-get >/dev/null 2>&1; then
    PACKAGE_MANAGER="apt"
elif command -v dnf >/dev/null 2>&1; then
    PACKAGE_MANAGER="dnf"
elif command -v yum >/dev/null 2>&1; then
    PACKAGE_MANAGER="yum"
elif command -v zypper >/dev/null 2>&1; then
    PACKAGE_MANAGER="zypper"
elif command -v pacman >/dev/null 2>&1; then
    PACKAGE_MANAGER="pacman"
else
    echo "deadbeef :("
    exit 1
fi

# List installed packages based on the identified package manager
case "$PACKAGE_MANAGER" in
    "apt")
        dpkg --get-selections | awk '!/deinstall|purge|hold/ {print $1}'
        ;;
    "dnf" | "yum")
        rpm -qa
        ;;
    "zypper")
        zypper se --installed-only | awk '{print $3}'
        ;;
    "pacman")
        pacman -Qq;;
esac
