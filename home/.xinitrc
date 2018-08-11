~/.bin/xnormal

# Fire up apps
trayer --edge top --align right --SetDockType true --SetPartialStrut true \
 --expand true --width 10 --transparent true --tint 0x000000 --height 18 --alpha 0 --monitor primary &

xscreensaver -no-splash &
nm-applet --sm-disable &
gtk-launch jetbrains-toolbox &
xbanish &

exec xmonad
