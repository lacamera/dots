# i3wm Setup (Debian-based)

```sh
sudo apt update
sudo apt install curl wget git gh gpg i3 rofi

1. Wezterm:
```sh
curl -fsSL https://apt.fury.io/wez/gpg.key \
  | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' \
  | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install wezterm
```

2. Google Chrome:
```sh
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub \
  | sudo tee /etc/apt/trusted.gpg.d/google.asc
echo 'deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/google.asc] \
https://dl.google.com/linux/chrome/deb/ stable main' \
  | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install google-chrome-stable
```

Enable natural scrolling:
```sh
sudo ln -s /usr/share/X11/xorg.conf.d/40-libinput.conf \
            /etc/X11/xorg.conf.d/40-libinput.conf
# Then edit /etc/X11/xorg.conf.d/40-libinput.conf:
#   Under the “InputClass” sections for pointer/touchpad, add:
#     Option "NaturalScrolling" "true"
```

Enable AMD “TearFree”:

```sh
sudo tee /etc/X11/xorg.conf.d/10-amdgpu.conf > /dev/null <<EOF
Section "OutputClass"
    Identifier "AMDgpu"
    MatchDriver "amdgpu"
    Driver "amdgpu"
    Option "HotplugDriver" "amdgpu"
    Option "TearFree" "true"
EndSection
EOF
```

Configure your display layout:

```sh
xrandr
xrandr --output DP-1-2 --auto --primary
```
