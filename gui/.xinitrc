#!/bin/sh
setxkbmap de
xsetroot -solid black
xset b off
[[ -f "~/.config/X11/Xresources" ]] && xrdb -merge ~/.config/X11/Xresources
exec dwm

# thinkdock
xrandr --output DP2 --mode "2560x1080" --rate 75 --primary --right-of eDP1

while true; do
  d="$(date +"%F %R %Z")"
  b="$(sysctl -n hw.sensors.acpibat0.watthour3 | cut -d" " -f1,2 | tr -d '[:space:]')"
  bs="$([[ "$(apm | grep 'A/C' | cut -d' ' -f4 )" == "connected" ]] && echo 'A/C' || echo 'BAT')"
  l="$(uptime | cut -d"," -f5 | tr -d '[:space:]')" # 5min load avg
  xsetroot -name "$l $b $bs  $d" 
  sleep 60;
done
