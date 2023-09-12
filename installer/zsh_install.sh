#!/bin/sh

# Check if Zsh is already installed
if command -v zsh >/dev/null 2>&1; then
    echo "Zsh is already installed."
else
    # Determine the package manager based on available commands
    if command -v apt-get >/dev/null 2>&1; then
        package_manager="apt-get"
    elif command -v dnf >/dev/null 2>&1; then
        package_manager="dnf"
    elif command -v yum >/dev/null 2>&1; then
        package_manager="yum"
    elif command -v pacman >/dev/null 2>&1; then
        package_manager="pacman"
    else
        echo "bad pacman"
        exit 1
    fi

    case "$package_manager" in
        "apt")
            sudo apt install -y zsh
            ;;
        "dnf" | "yum")
            sudo dnf install -y zsh
            ;;
        "pacman")
            sudo pacman -Sy --noconfirm zsh
            ;;
        "brew")
            brew install zsh
            ;;
    esac

    # Change the default shell to Zsh for the current user
    if [ "$SHELL" != "$(command -v zsh)" ]; then
        chsh -s "$(command -v zsh)"
        echo "Zsh is now your default shell."
    fi

    echo "Zsh installation completed."
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "OMZ installed"
else
    echo "OMZ already installed"
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    echo "P10K installated"
else
    echo "P10K already installed"
fi

