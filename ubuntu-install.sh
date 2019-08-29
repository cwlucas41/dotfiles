#!/bin/bash
set -x

# Script idempotently installs dependencies and configures system
# To be run *after* cloning and linking the repo

# Setup i3
/usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2019.02.01_all.deb keyring.deb SHA256:176af52de1a976f103f9809920d80d02411ac5e763f695327de9fa6aff23f416
sudo dpkg -i ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
rm keyring.deb

# Setup chrome
wget -qO - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

# Setup vscode
wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
rm packages.microsoft.gpg

# packages that can be auto installed
sudo apt update
sudo apt upgrade
sudo apt install \
    arandr \
    at \
    blueman \
    build-essential \
    clipit \
    code \
    compton \
    feh \
    git \
    google-chrome-stable \
    hsetroot \
    htop \
    i3 \
    jq \
    libreoffice \
    libxi-dev `# xbanish dependency` \
    libxt-dev `# xbanish dependency` \
    moreutils \
    pavucontrol \
    policykit-1-gnome \
    py3status \
    python3-pydbus \
    rsync \
    rxvt-unicode-256color \
    scrot \
    ssmtp \
    tldr \
    tmux \
    vim \
    xbacklight \
    xcape \
    xclip \
    xscreensaver \
    zsh

# Install snaps
sudo snap refresh
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

# Set up udev keyboard rule
cat << EOF | sudo tee /etc/udev/rules.d/99-usb-keyboard.rules > /dev/null
ACTION=="add", SUBSYSTEM=="input", RUN+="/bin/su $USER -c '/bin/cat $HOME/bin/keyboard | /usr/bin/at now'"
EOF
sudo udevadm control --reload
udevadm trigger

echo "
The following must be installed/configured manually:
    playerctl           https://github.com/acrisci/playerctl/releases
    powerline-fonts     https://github.com/powerline/fonts
    xbanish             https://github.com/jcs/xbanish/releases
    ssh keys
"

