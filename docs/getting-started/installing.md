# Installing

The development version of the [Birch compiler](https://github.com/lawmurray/Birch), the [Birch standard library](https://github.com/lawmurray/Birch.Standard) and the [Birch examples](https://github.com/lawmurray/Birch.Example) are available from GitHub. There are no stable releases available as yet.

To clone the repositories, use:

    git clone https://github.com/lawmurray/Birch.git
    git clone https://github.com/lawmurray/Birch.Standard.git
    git clone https://github.com/lawmurray/Birch.Example.git


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

!!! tip
    As usual when installing from source, you made need to use `sudo make install` for the last line to elevate to root permissions, if you are installing form a user account that does not have permissions for a system-wide install.


## Install the standard library

Run the following from within the `Birch.Standard` directory:

```sh
birch build
birch install
```

!!! tip
    Similarly again, you may need to use `sudo birch install` for the last line.

## Install the examples

This is optional. Run the following from within the `Birch.Example` directory:

```sh
birch build
birch install
```
