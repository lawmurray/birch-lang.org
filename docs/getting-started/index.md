# Installation

Birch works on a wide variety of operating systems running on x86, ARM and RISC-V hardware, including the new M1 Macs. It is open source software released under the [Apache License, Version 2.0](https://github.com/lawmurray/Birch/blob/master/LICENSE).

## :fontawesome-brands-linux: Linux

Packages are provided for major Linux distributions, including Debian, Ubuntu, Fedora, CentOS, openSUSE, SUSE Linux Enterprise, Mageia, and Arch. Click through to the [Open Build Service](https://software.opensuse.org//download.html?project=home%3Alawmurray%3Abirch&package=birch) and select your distribution for installation instructions; for Raspbian (i.e. Raspberry Pi), select Debian.

For Alpine Linux, which you may be particularly interested in for installing Birch in a lightweight container environment, you will need to install [from source](#from-source), but we do support `musl` for this purpose.

## :fontawesome-brands-freebsd: FreeBSD

You will need to install [from source](#from-source).

## :fontawesome-brands-apple: Mac

Install [Homebrew](https://brew.sh) if not already, then install Birch with:

```sh
brew tap lawmurray/birch
brew install birch
```

## :fontawesome-brands-windows: Windows

Native support is not yet provided, but you can install [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10) with a Linux distribution of your choice, then click through to the [Open Build Service](https://software.opensuse.org//download.html?project=home%3Alawmurray%3Abirch&package=birch) and select that distribution for installation instructions.

## :fontawesome-solid-file-archive: From source

If a package is not available for your operating system or you have special requirements, you can install Birch from source. See the [README.md](https://github.com/lawmurray/Birch) file for up-to-date instructions.

