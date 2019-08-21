#!/bin/bash
# Script idempotently installs dependencies and configures system
# To be run *after* cloning and linking the repo

# Setup Spotify
wget -q -O - https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

# Setup i3
/usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2019.02.01_all.deb keyring.deb SHA256:176af52de1a976f103f9809920d80d02411ac5e763f695327de9fa6aff23f416
sudo dpkg -i ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
rm keyring.deb

# Setup chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

# System 76 repo
sudo apt-add-repository -y ppa:system76-dev/stable

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
    network-manager-openvpn \
    network-manager-openvpn-gnome \
    openvpn \
    pavucontrol \
    policykit-1-gnome \
    py3status \
    python3-pydbus \
    rsync \
    rxvt-unicode-256color \
    scrot \
    spotify-client \
    system76-driver \
    tldr \
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
