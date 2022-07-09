# dots

## Overview
### Terminal
* shell (`ksh(1)`, `sh(1)`)
* editors (`vi(1)`, `nvim(1)`)
* util (`git(1)`, `clangd`, `htop(1)`)

### Xorg X11
* Xenv (`Xresources`, `Xdefaults`, colors)
* fontconfig (`vi(1)`, `nvim(1)`)
* Xsession (`Xsession`, `Xinitrc`, `startx(1)`)
* wm (`i3(1)`, `alacritty(1)`, `feh(1)`)
* On \_\_OpenBSD\_\_: Xenodm

### Packages
The following will be installed:
* packages
  * OpenBSD [list](list)
* vendor packages (cross platform)
  * pip3 [list](list)
  * cabal [list](list)
  * neovim plugins [init.vim](init.vim)

## Usage
```sh
# Install everything:
./install

# Alternativley, you might just want to install a single module:
./term/install
./xorg/install # deps: `term/{env,profile,ksh.kshrc}`
./pkg/install
```
