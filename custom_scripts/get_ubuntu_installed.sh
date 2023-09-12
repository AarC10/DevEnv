dpkg --get-selections | awk '!/deinstall|purge|hold/ {print $1}' > installed_packages.txt
