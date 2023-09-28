#!/bin/sh
#
# Script Name: get_installed
#
# Author: Aaron Chan
#
# Description: Yoink all installed packages

. ../get_pacman.sh

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
