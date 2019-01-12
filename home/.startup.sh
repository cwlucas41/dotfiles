# system configuration
setxkbmap -option && setxkbmap -option altwin:swap_alt_win,ctrl:nocaps,shift:both_capslock &
xcape -e 'Control_L=Escape' &
xsetroot -solid '#000' &
stty -ixon

# startup programs
nm-applet --sm-disable &
blueman-applet &
xscreensaver -no-splash &
xbanish &
jetbrains-toolbox --minimize &
clipit &
~/.lightsonplus/lightson+
