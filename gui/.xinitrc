#!/bin/sh
. "$HOME/.config/profile"
xrdb -merge "$HOME/.config/X11/Xresources"
xsetroot -solid "#1d2021"
setxkbmap de
xset b off


is_connected_output() {
	echo "$(xrandr --listactivemonitors | grep -c "$1")"
}


{
while true; do
	date="$(date +"%F %R %Z")"
	wh3="$(sysctl -n hw.sensors.acpibat0.watthour3 | cut -d" " -f1 | tr -d '[:space:]')"
	load5="$(uptime | cut -d"," -f5 | tr -d '[:space:]')"
	xsetroot -name "[cpu 5m:$load5] [bat Wh:$wh3] [date $date]"
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
