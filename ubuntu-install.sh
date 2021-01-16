#!/bin/bash
set -x

# Script idempotently installs dependencies and configures system
# To be run *after* cloning and linking the repo

# Setup i3
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2020.02.03_all.deb keyring.deb SHA256:c5dd35231930e3c8d6a9d9539c846023fe1a08e4b073ef0d2833acd815d80d48
sudo dpkg -i ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
rm keyring.deb

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

# Upgrade from all sources
upgrade-all

# Apt packages that can be auto installed
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
    needrestart \
    pavucontrol \
    policykit-1-gnome \
    py3status \
    python3-pydbus \
    rsync \
    rxvt-unicode-256color \
    scrot \
    spotify-client \
    ssmtp \
    tldr \
    tmux \
    tree \
    vim \
    xbacklight \
    xcape \
    xclip \
    xscreensaver \
    zsh

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

# Set up udev keyboard rule
cat << EOF | sudo tee /etc/udev/rules.d/99-usb-keyboard.rules > /dev/null
ACTION=="add", SUBSYSTEM=="input", RUN+="/bin/su $USER -c '/bin/cat $HOME/bin/keyboard | /usr/bin/at now'"
EOF
sudo udevadm control --reload
udevadm trigger

echo "\nThe following must be installed/configured manually:"
echo "    ssh keys"
command -v playerctl            || echo "    playerctl           https://github.com/acrisci/playerctl/releases"
command -v xbanish              || echo "    xbanish             https://github.com/jcs/xbanish/releases"
fc-list | grep -qi "powerline"  || echo "    powerline-fonts     https://github.com/powerline/fonts"

