For `a:Boolean` and `b:Boolean`, conditionals can be written as follows:

    if a {
      // do something
    } else if b {
      // do something
    } else {
      // do something
    }

where zero or more `else if` blocks may appear, and zero or one `else` block.

Conditional loops are written as:

    while a {
      // do something
    }

or:

    do {
      // do something
    } while a;

For `a:Integer`, `b:Integer`, and `c:Integer`, a for-loop is written as:

    for a in b..c {
      // do something
    }

It is also possible to declare a new local variable, inline, as the loop index:

    for a:Integer in b..c {
      // do something
    }

or even:

    for auto a in b..c {
      // do something
    }
