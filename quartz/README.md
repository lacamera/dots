# macOS Terminal Setup

[Homebrew](https://brew.sh/) is the missing package manager for macOS. The `setup.sh` script in this repository will install Homebrew and a suite of essential terminal utilities for you.

Make sure you have the Xcode Command Line Tools installed:  
```sh
xcode-select --install
```

Next, install Homebrew itself:  
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Initialize Homebrew in your shell:  
```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
```

```
brew install koekeishiya/formulae/skhd
skhd --start-service
```
