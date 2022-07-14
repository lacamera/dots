# dots
## Usage

```sh
# Install everything:
# Using the -n option reports the steps that would be taken, 
# without actually doing anything. This applies to any module.
doas ./install

# You may also only install one component at a time:
./term/install 
# Please note that the xorg/ component requires some variables that
# term/ provides.
./xorg/install

# The pkg/ module needs su priviliges to install the packages.
# If you don't run this script with doas prefix it like so: `DOAS_USER=$USER ./pkg/install`.
doas ./pkg/install
```
