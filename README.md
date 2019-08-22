## cwlucas41's dotfiles
### Branches
`master` is default configuration that is not specific to any machine. Other branches are specific machine configurations.

### Install instructions
Ubuntu 18.04:
```
# dependency
sudo apt install -y homesick

# dotfile setup
homesick clone https://github.com/cwlucas41/dotfiles.git dotfiles
homesick link dotfiles

# system configuration
homesick cd dotfiles
./ubuntu-install.sh
exit
```