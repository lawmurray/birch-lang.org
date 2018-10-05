A variable `a` of type `A` is declared as follows:

    a:A;

A variable may be given an initial value when declared:

    a:A <- b;

When an initial value is used in this way, the `auto` keyword may be used to infer the type of that variable, rather than specifying it explicitly:

    auto a <- b;
