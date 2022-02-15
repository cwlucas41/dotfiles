#!/bin/bash

# Script idempotently installs dependencies and configures system
# To be run *after* cloning and linking the repo

# Setup chrome
wget -qO - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

# Setup spotify
wget -qO - https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

# Setup vscode
wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
rm packages.microsoft.gpg

# Setup alacritty
sudo add-apt-repository ppa:mmstick76/alacritty

# System 76 repo
sudo apt-add-repository -y ppa:system76-dev/stable

# Upgrade from all sources
upgrade-all

# Apt packages that can be auto installed
sudo apt install \
    alacritty \
    blueman \
    brightnessctl \
    build-essential \
    clipit \
    code \
    fonts-powerline \
    git \
    google-chrome-stable \
    htop \
    jq \
    libreoffice \
    mlocate \
    moreutils \
    pavucontrol \
    playerctl \
    policykit-1-gnome \
    py3status \
    python3-pydbus \
    rsync \
    rxvt-unicode-256color \
    slurp \
    spotify-client \
    ssmtp \
    sway \
    swayidle \
    swaylock \
    system76-driver \
    tldr \
    tmux \
    tree \
    vim \
    wl-clipboard \
    zsh

# interception tools dep
sudo apt install
    cmake \
    libboost-all-dev \
    libevdev-dev \
    libsystemd-dev \
    libudev-dev \
    libyaml-cpp-dev

# Install snaps
sudo snap install \
    bitwarden \
    bw \
    discord \
    spotify

sudo snap install --classic \
    slack

# set preferred shell
sudo chsh -s /bin/zsh $USER

# set preferred browser
sudo update-alternatives --set x-www-browser $(which google-chrome-stable)

# create expected dirs
mkdir -p "$HOME/workplace"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# gives permission to change brightness
sudo usermod -aG video "$USER"

# configure udevmon jobs
cat <<'EOF' | sudo tee /etc/interception/udevmon.yaml > /dev/null
- JOB: intercept -g $DEVNODE | caps2esc -m 1 | uinput -d $DEVNODE
  DEVICE:
    EVENTS:
      EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
EOF


echo "\nThe following must be installed/configured manually:"
command -v caps2esc >/dev/null || echo "    caps2esc            https://gitlab.com/interception/linux/plugins/caps2esc"
