# Installation

Birch is open source software released under the [Apache License, Version 2.0](https://github.com/lawmurray/Birch/blob/master/LICENSE). It works on a wide variety of operating systems running on x86 and ARM architectures, as well as Nvidia GPUs. Follow the instructions below for your system, or [install from source](#others-install-from-source).

!!! info
    Packages have recently been migrated from the [Open Build Service](https://software.opensuse.org//download.html?project=home%3Alawmurray%3Abirch&package=birch) to the self-hosted repositories below to provide CUDA support. Please report problems via [email](mailto:lawrence@indii.org) or [GitHub](https://github.com/lawmurray/Birch/issues).

## :fontawesome-brands-ubuntu: Ubuntu

Enter the following commands, according to your specific version, to add the repository, import the signing key, and install:

??? example "Ubuntu 22.10 Kinetic Kudu (amd64)"
    ```
    echo 'deb http://download.indii.org/deb kinetic main' | sudo tee /etc/apt/sources.list.d/birch.list
    curl -fsSL https://download.indii.org/deb/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/birch.gpg > /dev/null
    sudo apt update
    sudo apt install birch
    ```

??? example "Ubuntu 22.10 Jammy Jellyfish (amd64)"
    ```
    echo 'deb http://download.indii.org/deb jammy main' | sudo tee /etc/apt/sources.list.d/birch.list
    curl -fsSL https://download.indii.org/deb/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/birch.gpg > /dev/null
    sudo apt update
    sudo apt install birch
    ```

??? example "Ubuntu 20.04 Focal Fossa (amd64)"
    ```
    echo 'deb http://download.indii.org/deb focal main' | sudo tee /etc/apt/sources.list.d/birch.list
    curl -fsSL https://download.indii.org/deb/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/birch.gpg > /dev/null
    sudo apt update
    sudo apt install birch
    ```

To enable Nvidia GPU support, [install CUDA][cuda] separately and then the NumBirch CUDA backend:
```
sudo apt install numbirch-cuda-dev
```

## :simple-debian: Debian

Enter the following commands, according to your specific version, to add the repository, import the signing key, and install:

??? example "Debian 11 Bullseye (amd64)"
    ```
    echo 'deb http://download.indii.org/deb bullseye main' | sudo tee /etc/apt/sources.list.d/birch.list
    curl -fsSL https://download.indii.org/deb/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/birch.gpg > /dev/null
    sudo apt update
    sudo apt install birch
    ```

??? example "Debian 10 Buster (amd64)"
    ```
    echo 'deb http://download.indii.org/deb buster main' | sudo tee /etc/apt/sources.list.d/birch.list
    curl -fsSL https://download.indii.org/deb/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/birch.gpg > /dev/null
    sudo apt update
    sudo apt install birch
    ```

To enable Nvidia GPU support, [install CUDA][cuda] separately and then the NumBirch CUDA backend:
```
sudo apt install numbirch-cuda-dev
```

## :fontawesome-brands-fedora: Fedora

Enter the following commands, according to your specific version, to add the repository and install:

??? example "Fedora 37 (x86_64)"
    ```
    sudo dnf config-manager --add-repo https://download.indii.org/rpm/fedora/37/birch.repo
    sudo dnf update
    sudo dnf install birch
    ```

??? example "Fedora 36 (x86_64)"
    ```
    sudo dnf config-manager --add-repo https://download.indii.org/rpm/fedora/36/birch.repo
    sudo dnf update
    sudo dnf install birch
    ```

??? example "Fedora 35 (x86_64)"
    ```
    sudo dnf config-manager --add-repo https://download.indii.org/rpm/fedora/35/birch.repo
    sudo dnf update
    sudo dnf install birch
    ```

To enable Nvidia GPU support, [install CUDA][cuda] separately and then the NumBirch CUDA backend:
```
sudo dnf install numbirch-cuda-devel
```

## :simple-opensuse: openSUSE

Enter the following commands, according to your specific version, to add the repository and install:

??? example "openSUSE Tumbleweed (x86_64)"
    ```
    sudo zypper addrepo https://download.indii.org/rpm/opensuse/tumbleweed/birch.repo
    sudo zypper refresh
    sudo zypper install birch
    ```

??? example "openSUSE Leap 15.4 (x86_64)"
    ```
    sudo zypper addrepo https://download.indii.org/rpm/opensuse/leap/15.4/birch.repo
    sudo zypper refresh
    sudo zypper install birch
    ```

To enable Nvidia GPU support, [install CUDA][cuda] separately and then the NumBirch CUDA backend:
```
sudo zypper install numbirch-cuda-devel
```

## :fontawesome-brands-linux: Mageia

Enter the following commands, according to your specific version, to add the repository and install:

??? example "Mageia 8 (x86_64)"
    ```
    sudo dnf config-manager --add-repo https://download.indii.org/rpm/mageia/8/birch.repo
    sudo dnf update
    sudo dnf install birch
    ```

To enable Nvidia GPU support, [install CUDA][cuda] separately and then the NumBirch CUDA backend:
```
sudo dnf install numbirch-cuda-devel
```

## :fontawesome-brands-apple: Mac

Install [Homebrew](https://brew.sh) if not already, then install Birch with:
```sh
brew tap lawmurray/birch
brew install birch
```

## :fontawesome-brands-windows: Windows

Native support is not yet provided, but you can install [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install) with one of the Linux distributions above and follow the instructions for it.

## :fontawesome-solid-file-zipper: Others: Install from source

If a package is not available for your operating system or you have special requirements, you can install from source. See the [README.md](https://github.com/lawmurray/Birch) file for up-to-date instructions.

[cuda]: https://developer.nvidia.com/cuda-downloads
