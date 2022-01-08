#!/bin/sh
setxkbmap de
xsetroot -solid '#1d2021'
xset b off
xrdb -merge "$HOME/.config/X11/Xresources"

status_bar() {
  d="$(date +"%F %R %Z")"
  b="$(sysctl -n hw.sensors.acpibat0.watthour3 | cut -d" " -f1,2 | tr -d '[:space:]')"
  l="$(uptime | cut -d"," -f5 | tr -d '[:space:]')"
  xsetroot -name "$l $b $d" 
}

{
while true; do
	status_bar
	sleep 60
done
} &

# This will eventually get replaced by a more sophisticated approach
# but works fine for now.
if [ "$(xrandr --listactivemonitors | grep -c "DP2")" -eq 1 ]; then
	xset s off		# disable screensaver
	xset -dpms		# disable DPMS
	xset s noblank	# don't blank the video device
	xrandr --output eDP1 --off
	xrandr --output DP2 --primary --mode 2560x1080 --rate 75

	# Passing '--rate XY|-r XY' to an xrandr command that operates on a
	# specified '--output XYZ' doesn't seem to have any effect whatsoever.
	# This is a workaround.
	xrandr -r 75
fi

exec dwm
