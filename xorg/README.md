# xorg

Includes configuration files for any X11-based
programs.

## Usage
```sh
Usage: setup [-n]
Options:
  -n Only print the steps that would be taken
```

```sh
mkdir -p /etc/udev/rules.d
echo "ACTION==\"change\", RUN+=$XDG_CONFIG_HOME/x11/monctl" > /etc/udev/rules.d/90-monitor.rule 
(root) udevadm control --reload-rules
```
