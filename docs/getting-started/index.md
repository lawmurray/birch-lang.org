# Installation

Birch is open source software released under the [Apache License, Version 2.0](https://github.com/lawmurray/Birch/blob/master/LICENSE). It works on a wide variety of operating systems running on x86 and ARM architectures, as well as Nvidia GPUs. Follow the instructions below for your system, or [install from source](#others-install-from-source).

## :fontawesome-brands-linux: Linux

Install from the [software repository](https://download.indii.org), following the instructions provided there.

!!! info
    To enable CUDA support, [install CUDA][cuda] separately and then the NumBirch CUDA backend, which comes as a package named `numbirch-cuda-dev` or `numbirch-cuda-devel` depending on your system.

## :fontawesome-brands-apple: Mac

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
