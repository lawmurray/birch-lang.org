We will start by creating a new project. The `birch` driver program is used to do this. Create a new, empty, directory named `Tutorial`. From within this directory, run

    birch init --name Tutorial

This creates the standard files and subdirectories for a Birch project. It is recommended that you maintain this standard structure for all of your projects to make their management and distribution easier.

!!! tip
    Now is a good time to set up version control with this initial set of files. For Git:

        git init
        git add *
        git commit -m "Added initial project files."

The standard structure for Birch projects consists of the subdirectories:

  * `bi/` for source code,
  * `build/` for build artifacts (managed by Birch),
  * `input/` for input files,
  * `output/` for output files.

and a number of other meta files in the base directory. The most important of these meta files is [`META.json`](/documentation/driver/meta_file.md), which contains meta information such as a name, version, and description of the project, and a manifest of files. As you add files to the project you should add them to this [`META.json`](/documentation/driver/meta_file.md) file. This is particularly importance for `*.bi` source files in the `bi/` subdirectory, so that they are included when building.

!!! tip
    Typically, files in the `bi/` and `input/` subdirectories are included in a source repository, whereas those in `build/` and `output/` are generated from other files, and so not included.  

To build the project, use:

    birch build

To install the project (which may be required to run, depending on the platform), use:

    birch install

When building, Birch will create a number of additional files in the current working directory. Most of these are created in a `build/` subdirectory, although some will appear in the root directory of the project. To delete all of these additional files, use:

    birch clean

To check for possible issues, e.g. files missing from [`META.json`](/documentation/driver/meta_file.md) or files listed there that do not exist, use:

    birch check

More information on the `init`, `check`, and `build` programs is available in the documentation of the [driver](/documentation/driver) program.
