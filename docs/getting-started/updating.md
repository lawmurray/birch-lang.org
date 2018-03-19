# Updating

!!! tip
    [Using Eclipse](using-eclipse.md) can help streamline updates.

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

For `Birch.Standard` and `Birch.Example`, or indeed any Birch package, use:

    birch clean
    birch build
    birch install

!!! tip
    You may be able to omit `make clean` and `birch clean` to speed up the build. This depends on the nature of the updates. Include them to be safe, or omit them unless later steps produce errors.
