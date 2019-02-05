# Spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

# i3
/usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2019.02.01_all.deb keyring.deb SHA256:176af52de1a976f103f9809920d80d02411ac5e763f695327de9fa6aff23f416
sudo dpkg -i ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
rm keyring.deb

# packages that can be auto installed
sudo apt update
sudo apt install \
	arandr \
	blueman \
	clipit \
	feh \
	git \
	google-chrome-stable \
	homesick \
	htop \
	i3 \
	jq \
	moreutils \
	pavucontrol \
	pidgin \
	pidgin-libnotify \
	powerline \
	rsync \
	rxvt-unicode-256color \
	scrot \
	spotify-client \
	tmux \
	xcape \
	xscreensaver \
	zsh

# packages that must be manual (for now)
echo "
The following must be installed manually:
	playerctl
"
