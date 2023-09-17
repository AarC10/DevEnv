#!/bin/sh

# Check if Zsh is already installed
if command -v zsh >/dev/null 2>&1; then
    echo "Zsh is already installed."
else
    . ../get_pacman.sh


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

