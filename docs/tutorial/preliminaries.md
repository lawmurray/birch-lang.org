In this first exercise, you will learn how to use the `birch` [driver](/documentation/driver) program to create a new project, and understand the typical workflow.


## Creating a project

We will start by creating a new project.

!!! example "Exercise"
    Create a new directory named `Tutorial`. From within this directory, run

        birch init --name Tutorial

This creates the standard files and subdirectories for a Birch project. It is recommended that you maintain this standard structure for all of your projects to make their management and distribution easier.

The standard structure for Birch projects consists of the subdirectories:

  * `bi/` for source code,
  * `build/` for build artifacts (managed by Birch),
  * `config/` for configuration files, typically setting various options for a chosen inference method,
  * `input/` for input files, and
  * `output/` for output files.

and a number of other meta files in the base directory. The most important of these meta files is [`META.json`](/documentation/driver/meta_file), which contains meta information such as a name, version, and description of the project, and a manifest of files. As you add files to the project you should add them to this [`META.json`](/documentation/driver/meta_file) file. This is particularly important for `*.bi` source files in the `bi/` subdirectory, so that they are included when building.

!!! tip
    Now is a good time to set up version control with this initial set of files. For Git:

        git init
        git add * .gitignore
        git commit -m "Added initial project files."

    Typically, files in the `bi/` and `input/` subdirectories are included in a source repository, whereas those in `build/` and `output/` are generated from other files, and so not included.  

To build the project, use:

    birch build

To install the project (which may be required to run, depending on the platform), use:

    birch install

When building, Birch will create a number of additional files in the current working directory. Most of these are created in the `build/` subdirectory, although some will appear in the root directory of the project. To delete all of these additional files, use:

    birch clean

To check for possible issues, e.g. files missing from [`META.json`](/documentation/driver/meta_file) or files listed there that do not exist, use:

    birch check

No output indicates no issues.

By convention, packages will also set up `birch run` to perform some interesting task to demonstrate the functionality of the package, although this may or may not be supported by a package.

More information on these commands is available in the documentation of the [driver](/documentation/driver) program.


## Creating a model

A model is specified in Birch by creating a class that inherits from [Model](/documentation/library/classes/Model).

!!! example "Exercise"
    Create a file called `bi/TestModel.bi` and enter the following code:

        /**
         * Test model.
         */
        class TestModel < Model {
          //
        }

Comments are written in Birch by either enclosing the comment text with `/*` and `*/`, or putting the comment text on the end of a line, preceded by `//`.

The special `/**` `*/` comment used above acts like an ordinary comment, but is extracted by the [docs](/documentation/driver/commands/docs) command to create reference documentation for your project. It is recommended that you use such a comment for all classes and functions that should be visible to a user of your package.

Recall that it is important to add all source files to the [`META.json`](/documentation/driver/meta_file) file in order to include them in the build.

!!! example "Exercise"
    Open the `META.json` file of your project and add `bi/TestModel.bi` to the list under `manifest.source`. It should then look something like this:

        {
          "name": "Tutorial",
          "version": "0.0.0",
          "description": "",
          "manifest": {
            "source": [
              "bi/TestModel.bi"
            ],
            "other": [
              "LICENSE",
              "META.json",
              "README.md"
            ]
          }
        }

We can now build the project and run it.

!!! example "Exercise"
    Build and install with:

        birch build
        birch install

If you receive an error message at this point, there may be a problem with your installation.

!!! example "Exercise"
    Sample from the (empty!) model with:

        birch sample --model TestModel

If this succeeds, you will see a filled progress bar. If this produces an error message, there may be a problem with your installation.

The [sample](/documentation/library/programs/sample) program that you have just run is part of the Birch standard library. It provides a common interface to the available inference methods.
