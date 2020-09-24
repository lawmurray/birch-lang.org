# Hello, World!

We start by getting acquainted with the `birch` program that you have just installed, using it to create, build and run a simple Birch program. We will work from the terminal. If you are unfamiliar with Unix commands, that's okay, everything you need to type will be provided as we go.

We will start by creating a new package. From the terminal, create a new directory and change into it:

    mkdir HelloWorld
    cd HelloWorld

Initialize a new Birch package with the following command:

    birch init --package HelloWorld

This creates the standard files and subdirectories for a Birch package, including (list them with `ls`):

  * `src/` for source code,
  * `config/` for configuration files, typically setting various options for a model and/or inference method,
  * `input/` for input files,
  * `output/` for output files,
  * and a number of other meta files in the base directory such as `README.md` and `LICENSE`.

A new package contains just one source file, `src/hello.birch`, containing a program called `hello` that prints exactly what you think it does (view it with `cat src/hello.birch`).

Build the package with:

    birch build

then run the `hello` program with:

    birch hello

If you see `Hello, World!` on the terminal then everything is in order!

This is the typical workflow: whenever you make a change, run `birch build` to rebuild the package before running it again. The first time always takes a little longer than subsequent calls. Under the hood, the command is running a Birch-to-C++ source-to-source compiler, setting up a GNU Autotools build system (using [autoconf](https://www.gnu.org/software/autoconf/), [automake](https://www.gnu.org/software/automake/) and [libtool](https://www.gnu.org/software/libtool/)), and compiling the C++ sources to binaries. You will see the output of these steps on the terminal.

!!! tip
    When building, Birch will create a number of additional files in the current working directory. If you ever want to delete these files, use:

        birch clean

!!! tip
    Now is the best time to set up version control. For Git:

        git init
        git add * .gitignore
        git commit -m "Added initial files."

    Typically, files in `src/`, `config/` and `input/` are tracked, while those in `output/` are not, as they are derived from the others when running programs.
