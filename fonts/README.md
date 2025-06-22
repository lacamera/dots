# Font setup
[Apple](https://developer.apple.com/fonts/) provides most of their fonts as `dmg` archives on their website. The `setup` script will fetch and install them,
including the custom patched `monaco.ttf` provided in this repository.

Your `fonts.conf(5)` should look something like below if you actually plan to use these fonts:
```
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <alias>
    <family>monospace</family>
    <prefer>
      <family>SF Mono</family>
      ...
    </prefer>
 </alias>
 ...
</fontconfig>
```
You can find my current working config [here](https://github.com/lacamera/dot/blob/master/i3wm/fontconfig/fonts.conf).

## Installation
Make sure you have `7z` and `curl` installed, then run:
```sh
./setup
fc-cache -f
```
Run the script as `root` if you want to make them available for every user on your system.
