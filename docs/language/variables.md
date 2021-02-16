A variable `a` of type `A` is declared as follows:
```birch
a:A;
```

A variable may be given an initial value when declared:
```birch
a:A <- b;
```

When an initial value is used in this way, the `let` keyword may be used to infer the type of that variable, rather than specifying it explicitly:
```birch
let a <- b;
```

Variables may be named using Latin or Greek upper or lower case letters, underscore (`_`) and prime (`'`). The prime is often used for the names of temporary variables or of updates to existing variables, as in mathematics.

!!! tip
    The [probabilistic operators](/language/probability/) may also be used to assign initial values.

