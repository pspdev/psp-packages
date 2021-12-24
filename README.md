# PSP Packages

This repo contains build files for all the libraries shipped with PSPDEV. They are automatically build and hosted as a pacman repository using Github actions. They can be downloaded with the ``psp-pacman`` command.

## Installing libraries from the repository

Installing libraries from this repository can be done with ``psp-pacman`` like so:

```
psp-pacman -Sy library
```

Replace library with the library which should be installed.

An overview of libaries available can be viewed with:

```
psp-pacman -Ss
```

Installing all available libraries can be done with:

```
psp-pacman -Sy
psp-pacman -S $(psp-pacman -Slq)
```

Updating libraries can be done with:

```
psp-pacman -Syu
```

## Building individual libraries

Building a single package from a clone of this repository can be useful if you wish to modify it in some way. It can be done by opening a terminal in the directory of the chosen library and running the following:

```
psp-makepkg -i
```

This will build and install the package.

## Contributing

Contributions to this repository are welcome. If you wish to update or add a library look at the [contributing page](CONTRIBUTING.md).

## Special thanks

A special thanks goes out to both the contributors of PSPDEV and the VITASDK. Most of the scripts in this repository are based on scripts written by them.
