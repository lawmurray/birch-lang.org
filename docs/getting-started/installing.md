# Installing

Birch is currently only available in a development version. Because it is updated frequently, it is recommended that you clone its repositories using Git rather than downloading them as archives. This way you can easily pull down new updates.


## Clone the repositories

To clone the repositories, use:

    git clone https://github.com/lawmurray/Birch.git
    git clone https://github.com/lawmurray/Birch.Standard.git
    git clone https://github.com/lawmurray/Birch.Example.git

To check for updates at any subsequent time, use

    git pull

from within each of these directories. If new updates are applied, you will need to repeat the installation procedure below.

!!! tip
    [Using Eclipse](using-eclipse.md) can help streamline the process for new updates.


## Install dependencies

Birch requires:

  * GNU autoconf, automake and libtool,
  * the Flex lexer,
  * the Bison parser generator,
  * the Boost libraries, and
  * the Eigen 3 linear algebra library.

These are all widely available through package managers. See the guides for [Ubuntu Linux](/getting-started/ubuntu.md), [macOS](/getting-started/macos.md) and [Windows 10](/getting-started/windows.md).

## Install the compiler

Run the following commands from within the `Birch` directory:

```sh
./autogen.sh
./configure
make
make install
```

## Install the standard library

Run the following from within the `Birch.Standard` directory:

```sh
birch build
birch install
```

## Install the examples

This is optional. Run the following from within the `Birch.Example` directory:

```sh
birch build
birch install
```
