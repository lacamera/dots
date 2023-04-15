# Font setup
[Apple](https://developer.apple.com/fonts/) provides most of their fonts as `dmg` archives on their website. The `setup` script will fetch and install them,
including the custom patched `monaco.ttf` provided in this repository.

Your `fonts.conf(5)` should look something like [this](https://raw.githubusercontent.com/lacamera/env/master/xorg/fonts.conf) if you actually plan to use these fonts.

Make sure you have `7z` and `curl` installed, then run:
```sh
./setup
fc-cache -f
```
Run the script as `root` if you want to make them available for every user on your system.
