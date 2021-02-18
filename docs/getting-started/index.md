# Installation

## :fontawesome-brands-linux: Linux

Packages are provided for major Linux distributions. Click through to the [Open Build Service](https://software.opensuse.org//download.html?project=home%3Alawmurray%3Abirch&package=birch) and select your distribution for installation instructions.

For Raspberry Pi OS, head straight to the [repository](https://download.opensuse.org/repositories/home:/lawmurray:/birch/).

## :fontawesome-brands-apple: Mac

Install [Homebrew](https://brew.sh) if not already, then install Birch with:

```sh
brew tap lawmurray/birch
brew install birch
```

## :fontawesome-brands-windows: Windows

Native support is not yet provided, but you can install [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) with a Linux distribution of your choice, then click through to the [Open Build Service](https://software.opensuse.org//download.html?project=home%3Alawmurray%3Abirch&package=birch) and select that distribution for installation instructions.

## :fontawesome-solid-file-archive: From source

If a package is not available for your operating system or you have special requirements, you can install from source. This requires:

  * GNU autoconf, automake, libtool, flex, and bison
  * [LibYAML](https://pyyaml.org/wiki/LibYAML)
  * [Boost](https://boost.org)
  * [Eigen](https://eigen.tuxfamily.org)

All Birch sources are in the same repository. The master branch is considered stable. Clone it:

    git clone https://github.com/lawmurray/Birch.git

Install the driver by running, from within the `driver/` directory:

```sh
./bootstrap
./configure
make
make install
```

!!! tip
    When running `make install` or `birch install` below, you may need to use `sudo` if installing system wide, i.e. `sudo make install` or `sudo birch install`.

Install LibBirch by running, from within the `libbirch/` directory:

```sh
./bootstrap
./configure
make
make install
```

Install the standard library by running, from within the `libraries/Standard/` directory:

```sh
birch build
birch install
```

This constitutes a minimal install. You may also like to install other packages in the `libraries/` directory. It is not usual to install the packages in the `examples/` directory, although you may like to build and run these for testing or learning purposes.
