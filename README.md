```
      888            d8          
 e88~\888  e88~-_  _d88__  d88~\ 
d888  888 d888   i  888   C888   
8888  888 8888   |  888    Y88b  
Y888  888 Y888   '  888     888D 
 "88_/888  "88_-~   "88_/ \_88P
 
dotfiles and patches, auto deployable
```

### Documentation
Using the `-n` option only prints the steps that would be taken.
```sh
usage: {*/}install [-n]
```
Environment
```
PRINT_ONLY  Only report the steps that would be taken.
            Disabled by default.
WITH_GUI    Wether or not gui components should be installed.
            Disabled by default. Possible values: 0 or 1.
DOAS_USER   (On OpenBSD)
```
Hierarchy
```
- pkg/       package and plugin lists
- term/      terminal-based application configuration files
- xorg/      x11, WM, gtk, etc. configuration files
- */install  single-module install routine
- install    install co-routines (all)
```  
Maintainer:  
`Francesco La Camera <fm@lacamera.org>`
### Installation
```sh
(root) {*/}install [-n]
```
