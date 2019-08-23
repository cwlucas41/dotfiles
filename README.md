## cwlucas41's dotfiles
### Branches
`master` is default configuration that is not specific to any machine. Other branches are specific machine configurations.

### Install instructions
Ubuntu 18.04:
1. Setup
    ```
    # dependency
    sudo apt install -y homesick

    # repository setup
    homesick clone https://github.com/cwlucas41/dotfiles.git dotfiles
    homesick cd dotfiles

    # Show available branches
    homesick exec dotfiles git branch
    ```
1. Checkout the correct branch for the machine
    ```
    homesick exec dotfiles git checkout <branch>
    ```
1. Complete the configuration
    ```
    homesick link dotfiles
    homesick exec dotfiles ./ubuntu-install.sh
    ```