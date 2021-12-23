# Contributing

This repository contains the build scripts for all the libraries contained in the PSPDEV toolchain. If you feel any library is missing or could use an update, let us know or feel free to submit a pull request.

## How to add a library

A ``PSPBUILD`` file is actually a ``PKGBUILD`` like you might know them from Arch Linux. Because of this documentation for making ``PKGBUILD`` files on the Arch wiki is a great resource for how to make ``PSPBUILD`` files. Take a look [here](https://wiki.archlinux.org/title/Creating_packages) and [here](https://wiki.archlinux.org/title/PKGBUILD).

Start by creating a directory for the library and a ``PSPBUILD`` file. It is recommended to base it on another ``PSPBUILD`` in this repo which uses the same build system as the new library. Do make sure pkgname, pkgdesc, pkgver and license are changed, though.

Before making a pull request, make sure the library builds, installs and works. Building and installing can be done with:

```
psp-makepkg -i
```

Also make sure to read the criteria for contributions below.

## Criteria for contributions

For new contributions to be merged, the PSPBUILDs in them should meet the following criteria:

- For new packages:
  - The following fields should be set:
    - ``pkgdesc``
    - ``license``
  - ``arch`` should be set to ``('mips')``.
  - ``sha256sums`` should be used for integrity checks of downloaded files. Git sources and local patches are allowed to use ``SKIP``.
  - PSPBUILDs based on versioned archive files (yourlibrary-1.2.tar.gz for instance) are preferred over those based on git/svn repositories.
  - The license of the library should be installed in ``$pkgdir/psp/share/licenses/$pkgname/``.
  - PSPBUILDs which use a git repository as source should use a specific tag or commit.
  - ``pkgname`` should not contain capital letters or special characters other than ``-``.
- For existing packages:
  - Either the ``pkgver`` or ``rel`` has been changed.
- For all PSPBUILDs:
  - Libraries go in ``$pkgdir/psp/lib/``.
  - Include files go in ``$pkgdir/psp/include/``.
  - Pkgconfig files go in ``$pkgdir/psp/lib/pkgconfig``.
  - License files go in ``$pkgdir/psp/share/licenses/$pkgname/``.
  - Scripts which should be in the path of the user go in ``$pkgdir/bin/``.
  - Other scripts go in ``$pkgdir/psp/bin/`` or ``$pspdir/share/$pkgname/bin/``.
  - Documentation goes in ``$pkgdir/psp/share/doc/$pkgname/`` or ``$pkgdir/share/doc/$pkgname/``.
