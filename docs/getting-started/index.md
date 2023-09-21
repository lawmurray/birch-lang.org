# Installation

Birch is open source software released under the [Apache License, Version 2.0](https://github.com/lawmurray/Birch/blob/master/LICENSE). It works on a wide variety of operating systems running on x86 and ARM architectures, as well as Nvidia GPUs. Follow the instructions below for your system, or [install from source](#others-install-from-source).

!!! info
    To enable CUDA support, [install CUDA][cuda] separately and then the NumBirch CUDA backend, which comes as a package named `numbirch-cuda-dev` or `numbirch-cuda-devel` depending on your system.

## :fontawesome-brands-ubuntu: Ubuntu

??? info "Ubuntu 23.04 Lunar Lobster (amd64)"
    ```
    echo 'deb http://download.indii.org/deb lunar main' | sudo tee /etc/apt/sources.list.d/indii.org.list
    curl -fsSL https://download.indii.org/deb/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/indii.org.gpg > /dev/null
    sudo apt update
    sudo apt install birch
    ```

??? info "Ubuntu 22.04 Jammy Jellyfish (amd64)"
    ```
    echo 'deb http://download.indii.org/deb jammy main' | sudo tee /etc/apt/sources.list.d/indii.org.list
    curl -fsSL https://download.indii.org/deb/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/indii.org.gpg > /dev/null
    sudo apt update
    sudo apt install birch
    ```

??? info "Ubuntu 20.04 Focal Fossa (amd64)"
    ```
    echo 'deb http://download.indii.org/deb focal main' | sudo tee /etc/apt/sources.list.d/indii.org.list
    curl -fsSL https://download.indii.org/deb/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/indii.org.gpg > /dev/null
    sudo apt update
    sudo apt install birch
    ```

## :simple-debian: Debian

??? info "Debian 12 Bookworm (amd64)"
    ```
    echo 'deb http://download.indii.org/deb bookworm main' | sudo tee /etc/apt/sources.list.d/indii.org.list
    curl -fsSL https://download.indii.org/deb/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/indii.org.gpg > /dev/null
    sudo apt update
    sudo apt install birch
    ```

??? info "Debian 11 Bullseye (amd64)"
    ```
    echo 'deb http://download.indii.org/deb bullseye main' | sudo tee /etc/apt/sources.list.d/indii.org.list
    curl -fsSL https://download.indii.org/deb/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/indii.org.gpg > /dev/null
    sudo apt update
    sudo apt install birch
    ```

## :fontawesome-brands-fedora: Fedora

??? info "Fedora 38 (x86_64)"
    ```
    sudo dnf config-manager --add-repo https://download.indii.org/rpm/fedora/38/indii.org.repo
    sudo dnf update
    sudo dnf install birch
    ```

??? info "Fedora 37 (x86_64)"
    ```
    sudo dnf config-manager --add-repo https://download.indii.org/rpm/fedora/37/indii.org.repo
    sudo dnf update
    sudo dnf install birch
    ```

??? info "Fedora 36 (x86_64)"
    ```
    sudo dnf config-manager --add-repo https://download.indii.org/rpm/fedora/36/indii.org.repo
    sudo dnf update
    sudo dnf install birch
    ```

??? info "Fedora 35 (x86_64)"
    ```
    sudo dnf config-manager --add-repo https://download.indii.org/rpm/fedora/35/indii.org.repo
    sudo dnf update
    sudo dnf install birch
    ```

## :simple-opensuse: openSUSE

??? info "openSUSE Tumbleweed (x86_64)"
    ```
    sudo zypper addrepo https://download.indii.org/rpm/opensuse/tumbleweed/indii.org.repo
    sudo zypper refresh
    sudo zypper install birch
    ```

## :fontawesome-brands-linux: Mageia

??? info "Mageia 8 (x86_64)"
    ```
    sudo dnf config-manager --add-repo https://download.indii.org/rpm/mageia/8/indii.org.repo
    sudo dnf update
    sudo dnf install birch
    ```

## :fontawesome-brands-apple: Mac

??? info "Homebrew"
    Install [Homebrew](https://brew.sh) if not already, then install Birch with:
    ```sh
    brew tap lawmurray/all
    brew install birch
    ```

## :fontawesome-brands-windows: Windows

Native support is not yet provided, but you can install [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install) with one of the Linux distributions above and follow the instructions for it.

## :fontawesome-solid-file-zipper: Others: Install from source

If a package is not available for your operating system or you have special requirements, you can install from source. See the [README.md](https://github.com/lawmurray/Birch) file for up-to-date instructions.

[cuda]: https://developer.nvidia.com/cuda-downloads
