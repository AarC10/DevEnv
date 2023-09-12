#!/bin/sh

install_packages() {
    local package_manager
    if command -v apt-get >/dev/null 2>&1; then
        package_manager="apt-get"
    elif command -v dnf >/dev/null 2>&1; then
        package_manager="dnf"
    elif command -v yum >/dev/null 2>&1; then
        package_manager="yum"
    elif command -v pacman >/dev/null 2>&1; then
        package_manager="pacman"
    else
        echo "reeeeee"
        exit 1
    fi

    # Install packages using the determined package manager
    sudo "$package_manager" install -y \
        curl \
        git \
        python3 \
        npm \
        yarn \
        build-essential \
        imagemagick \
        openocd \
        trello \
        python3-dev \
        python2.7-dev \
        qt5-default \
        cmake \
        gcc \
        g++ \
        arduino \
        screen \
        vim \
        valgrind \
        gdbserver \
        ttf-mscorefonts-installer \
        mysql-server \
        php-mysql \
        clang \
        ninja-build \
        pkg-config \
        libgtk-3-dev \
        liblzma-dev \
        qemu-kvm \
        libvirt-daemon-system \
        libvirt-clients \
        bridge-utils \
        clang-format \
        telnet \
        xdg-utils \
        xdg-desktop-portal-gtk \
        xdg-desktop-portal-kde \
        ifconfig \
        influx \
        influxdb \
        xclip \
        docker \
        apt-transport-https \
        software-properties-common \
        maven \
        laptop-mode-tools \
        sdkmanager \
        angular \
        metasploit
}

# Run the installation function
install_packages

