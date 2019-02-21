    birch tune

Performance tune build options for the package.

The command requires the source code of all dependencies, including the standard library. It assumes that this can be found in the parent directory, e.g. at `../Birch.Standard` for the standard library.

The command rebuilds the package and its dependencies with various options, each time executing and timing the package's `./time.sh` script, which must be provided for this purpose. This will likely take some time. Once tuning is complete, it reports a suggested set of options to use when building the package.

!!! tip
    The default options are actually pretty good. They are chosen by running `tune` for a number of benchmark packages during development. Some packages may be outliers that benefit from package-specific tuning, but otherwise gains are likely to be small.
