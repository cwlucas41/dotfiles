#!/bin/bash
# Script idempotently installs dependencies and configures system
# To be run *after* cloning and linking the repo

# Setup Spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

# Setup i3
/usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2019.02.01_all.deb keyring.deb SHA256:176af52de1a976f103f9809920d80d02411ac5e763f695327de9fa6aff23f416
sudo dpkg -i ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
rm keyring.deb

# packages that can be auto installed
sudo apt update
sudo apt install \
    arandr \
    blueman \
    build-essential \
    clipit \
    feh \
    git \
    google-chrome-stable \
    htop \
    i3 \
    jq \
    libreoffice \
    libxi-dev `# xbanish dependency` \
    libxt-dev `# xbanish dependency` \
    moreutils \
    pavucontrol \
    pidgin \
    pidgin-libnotify \
    rsync \
    rxvt-unicode-256color \
    scrot \
    spotify-client \
    tmux \
    vim \
    xbacklight \
    xcape \
    xclip \
    xscreensaver \
    zsh

# packages that must be manual (for now)
echo "
The following must be installed manually:
    playerctl
    powerline-fonts
    xbanish
"

# set preferred shell
sudo chsh -s /bin/zsh $USER

# Set up udev keyboard rule
#echo "SUBSYSTEM==\"input\", ACTION==\"add\", RUN+=\"/bin/bash $HOME/.bin/keyboard\"" |
#    sudo tee /etc/udev/rules.d/99-usb-keyboard.rules > /dev/null
#sudo chmod +x /etc/udev/rules.d/99-usb-keyboard.rules
#sudo udevadm control --reload
#udevadm trigger
