# dots
## Usage
```sh
# Using the -n option reports only the steps that would be taken.
./install [-n]
```
doing `./install`  is the equivalent of:
```
# ./pkg/install
$ ./term/install
$ ./xorg/install
```

## Examples
```sh
WITH_GUI=1 doas ./install -n
```

## Environment
```
PRINT_ONLY Only report the steps that would be taken.
           Disabled by default.
WITH_GUI   Wether or not gui components should be installed.
           Disabled by default. Possible values: 0 or 1.
DOAS_USER
```
