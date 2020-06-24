A function with two parameters `a:A` and `b:B`, and return type `C`, is declared as:

    function f(a:A, b:B) -> C {
      c:C;
      // do something
      return c;
    }

For a function without a return value, omit the `->`:

    function f(a:A, b:B) {
      // do something
    }

For a function without parameters, use empty parentheses:

    function f() {
      // do something
    }

Functions are called by giving arguments in parentheses:

    f(a, b)

When calling a function without parameters, use empty parentheses:

    f()

### Generic functions

A function declaration may include parameters for generic types that are to be specified when the function is called. These are declared using angle brackets in the function declaration:

    function f<T,U>(a:T, b:U) {
      // do something
    }

Such a function is a *generic function*. When a generic function is called, type arguments are specified for the type parameters, also using angle brackets:

    f<Real,Integer>(1.0, 2);

!!! info
    At this stage the type arguments must be explicitly specified and cannot be inferred. This may be possible in future.
