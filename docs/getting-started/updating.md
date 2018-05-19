# Updating

!!! tip
    [Using Eclipse](/documentation/how-to/using-eclipse.md) can help streamline updates.

The development version of Birch is frequently updated with new features and bug fixes. This is especially so at the moment, as development has not yet matured to a stable release.

To check for updates at any time, use

    git pull

from within each of the `Birch`, `Birch.Standard` and `Birch.Example` directories that you created when [installing](/getting-started/installing). If new updates are retrieved, you will need to recompile.

For `Birch`, use:

    make clean
    ./autogen.sh
    ./configure
    make
    make install

!!! tip
    You may need to use `sudo make install` for the last line to elevate to root permissions, if you are installing from a user account that does not have permissions for a system-wide install.

!!! tip
    To speed up the build, you can use `make -j 8` on the second-last line, replacing `8` with a number of threads to run in parallel.

For `Birch.Standard` and `Birch.Example`, or indeed any Birch package, use:

    birch clean
    birch build
    birch install

!!! tip
    Similarly again, you may need to use `sudo birch install` for the last line.

!!! tip
    You may be able to omit `make clean` and `birch clean` to speed up the build. This depends on the nature of the updates. Include them to be safe, or omit them unless later steps produce errors.
