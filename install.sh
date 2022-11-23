#!/bin/env bash
if [[ "$(id -u)" == "0" ]]; then
    echo -ne "Script can not be run as root user\n"
    exit 0
fi

# Setup
AUR_HELPER="yay"

install()
{
    sudo pacman -S --noconfirm --needed "$@"
}
install_aur()
{
    "$AUR_HELPER" -S --noconfirm --needed "$@"
}

# Install pacman packages
PKGS=(
    'gnome-keyring'
    'gcc'
    'stow'
    'curl'
    'moreutils'
    'qtile'
    'neovim'
    'zsh'
    'kitty'
    'xterm'
    'rofi'
    'networkmanager'
    'network-manager-applet'
    'seahorse'
    'cbatticon'
    'flameshot'
    'psensor'
    'feh'
    'variety'
    'lxqt-policykit-agent'
    'lightdm'
    'lightdm-webkit2-greeter'
    'lightdm-webkit-theme-litarvan'
    'variety'
    'starship'
    'neofetch'
    'onefetch'
    'firefox'
    'bpytop'
    'pavucontrol'
    'audacious'
    'mpv'
    'celluloid'
    'ncdu'
    'tumbler'
    'thunar'
    'thunderbird'
    'steam'
    'lutris'
    'onlyoffice-desktopeditors'
    'python-pip'
    'python-poetry'
    'xclip'
    'qt5ct'
    'lxappearance'
    'dunst'
)
for pkg in "${PKGS[@]}"; do
    install "$pkg"
done

# Services
SERVICES_DISABLE=(
)
for service in "${SERVICES_DISABLE[@]}"; do
    sudo systemctl disable "$service"
done

SERVICES=(
    'lightdm'
    'NetworkManager'
)
for service in "${SERVICES[@]}"; do
    sudo systemctl enable "$service.service"
done

# Install AUR helper
if ! command -v "$AUR_HELPER"; then
    git clone https://aur.archlinux.org/"$AUR_HELPER".git
    pushd "$AUR_HELPER" && makepkg -si && popd || exit
    rm -rf "$AUR_HELPER"
fi

# Install AUR packages
AUR_PKGS=(
    'rofi-greenclip'
    'picom-jonaburg-git'
    'proton-ge-custom-bin'
    'vimix-icon-theme'
    'juno-theme-git'
    'bibata-cursor-theme-bin'
    'qt5-styleplugins'
)
for pkg in "${AUR_PKGS[@]}"; do
    install_aur "$pkg"
done

# Set up personal config files
rm "$HOME/.bash_profile"
curl https://raw.githubusercontent.com/Rolv-Apneseth/.dotfiles/main/bin/.local/bin/dotfiles | /bin/env bash
