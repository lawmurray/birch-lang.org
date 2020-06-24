A program is a special function that is an entry point into Birch code from the command line. It cannot be called from other Birch code. Declare a program with:

    program example(x:Boolean, y:Integer <- 0, message:String,
        long_name:Real) {
      // do something
    }

where `x`, `y`, `message`, and `long_name` are program options, with `y` given a default value of zero. A program has no return value.

To call a program from the command line, use `birch`, followed by the program name, following by a list of program options:

    birch example --message "Hello!" --long-name 10.0 -x true -y 10

Program options may be given in any order but must be named. The name is usually prefixed with double-dash (`--`), but may be prefixed with single-dash (`-`) if the name is a single character.

Whenever an underscore (`_`) appears in the name of a program option, it should be replaced with a dash (`-`) on the command line. This occurs in the example above, where the `long_name` program option becomes `--long-name` on the command line.

Program options may be of any type for which an assignment from type `String` has been declared. This includes all basic types.

If a program is called with an unrecognized option, an error is produced.
