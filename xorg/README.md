# xorg

Includes configuration files for any X11-based
programs.

## Installation
```sh
Usage: setup [-n]
Options:
  -n Only print the steps that would be taken
```

## Monitor configuration
### Hotplugging
If you are running Linux, you can use `udev` to run the script whenever you (dis-)connect a new display.
```sh
mkdir -p /etc/udev/rules.d
echo "ACTION==\"change\", SUBSYSTEM==\"drm\", RUN+=cmd" > /etc/udev/rules.d/95-monitor-hotplug.rule 
(root) udevadm control --reload-rules
```
