#!/bin/sh
. "$HOME/.profile"
xrdb -merge "$HOME/.config/X11/Xresources"
xsetroot -solid "#1d2021"
setxkbmap de
xset b off


is_connected_output() {
	echo "$(xrandr --listactivemonitors | grep -c "$1")"
}


{
while true; do
	d="$(date +"%F %R %Z")"
	b="$(sysctl -n hw.sensors.acpibat0.watthour3 | cut -d" " -f1,2 | tr -d '[:space:]')"
	l="$(uptime | cut -d"," -f5 | tr -d '[:space:]')"
	xsetroot -name "$l $b $d"
	sleep 60
done
} &


if [ "$(is_connected_output DP2)" -eq 1 ]; then
	xset s off		# disable screensaver
	xset -dpms		# disable DPMS
	xset s noblank	# disable blanking 
	
	xrandr --dpi 82
	xrandr --output eDP1 --off
	xrandr --output DP2 --primary \
		--mode 2560x1080 \
		--rate 75 

	# xrandr --output XY --rate YZ doesn't apply the refresh rate.
	# This works for now.
	xrandr -r 75 
fi

exec dwm
