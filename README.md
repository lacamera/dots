```
      888            d8          
 e88~\888  e88~-_  _d88__  d88~\ 
d888  888 d888   i  888   C888   
8888  888 8888   |  888    Y88b  
Y888  888 Y888   '  888     888D 
 "88_/888  "88_-~   "88_/ \_88P
 
dotfiles and patches, auto deployable
```  
Maintained by `Francesco La Camera <fm@lacamera.org>`, entirely [ISC](LICENSE)
### Installation
```sh
(root) {*/}install [-n]
```
### Documentation
Using the `-n` option only prints the steps that would be taken.
```sh
usage: {*/}install [-n]
```
#### Environment
```
PRINT_ONLY  Only report the steps that would be taken.
WITH_GUI    Wether or not gui components should be installed (want 0 or 1). The default is 0.
DOAS_USER   (OpenBSD) (want valid username). Exported by doas(8).
```
#### Hierarchy
```
- pkg/       package and plugin lists
- term/      terminal-based application configuration files
- xorg/      x11, WM, gtk, etc. configuration files
- */install  single-module install routine
- install    install co-routines (all)
```  
