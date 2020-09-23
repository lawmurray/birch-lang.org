For `a:Boolean` and `b:Boolean`, conditionals can be written as follows:

    if a {
      // do something
    } else if b {
      // do something
    } else {
      // do something
    }

where zero or more `else if` blocks may appear, and zero or one `else` block.

!!! tip
    Parentheses around the conditions are optional, i.e. if you can write `if a { ... }` or `if (a) { ... }`. The same applies to the loop structures below.

Conditional loops are written as:

    while a {
      // do something
    }

or:

    do {
      // do something
    } while a;

For loops are written as:

    for a in b..c {
      // do something
    }

where `a` will be declared as a new variable of `Integer` type, and `b` and `c` evaluate to `Integer` type, with `b <= c`.

!!! attention
    It is **not** possible to iterate backward simply by setting `b > c`.
