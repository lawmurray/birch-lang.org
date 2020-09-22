# Hello World

In this first exercise, you will learn how to use the `birch` program to create, build and run a package, understanding the development workflow.

We will start by creating a new package. Create a new directory and change into it:

    mkdir HelloWorld
    cd HelloWorld

Initialize a new Birch package with the following command:

    birch init --package HelloWorld

This creates the standard files and subdirectories for a Birch package, including (list them with `ls`):

  * `src/` for source code,
  * `config/` for configuration files, typically setting various options for a model and/or inference method,
  * `input/` for input files,
  * `output/` for output files,
  * and a number of other meta files in the base directory.

A new package contains just one file, `src/hello.birch`, containing a program called `hello` that prints exactly what you think it does (view it with `cat src/hello.birch`).

Build the package with:

    birch build

then run the program with:

    birch hello

If you see `Hello, World!` on the terminal then everything is in order!

!!! tip
    When building, Birch will create a number of additional files in the current working directory. To delete all of these additional files, use:

        birch clean

!!! tip
    Now is the best time to set up version control. For Git:

        git init
        git add * .gitignore
        git commit -m "Added initial files."

    Typically, files in `src/`, `config/` and `input/` are tracked, while those in `output/` are not, as they are derived from the others when running programs.
