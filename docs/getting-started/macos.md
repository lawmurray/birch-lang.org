The recommended package manager is [Homebrew](http://brew.sh). To install dependencies, use:

```sh
brew install autoconf automake libtool flex bison boost eigen libomp
```

Once these dependencies are installed, follow the usual [instructions](/getting-started/installing.md) to install Birch itself.

!!! error
    Birch requires a newer version of Bison than that provided by macOS. The above command installs an appropriate version. If, however, you get a syntax error in `parser.ypp` when trying to install the Birch compiler, it is likely that the system version is still being used. In that case, try:
    
        brew link --force bison
