Tuples are tied using parentheses:

    (a, b, c)

For `a:A`, `b:B`, and `c:C`, the type of such a tuple is `(A, B, C)`. It is not possible to declare variables of tuple type, but tuples may be used to return multiple values from a function:

    function f(x:X, y:Y) -> (A, B, C) {
      a:A;
      b:B;
      c:C;
      return (a, b, c);
    }

To untie a tuple, use parentheses on the left:

    a:A;
    b:B;
    c:C;
    (a, b, c) <- f(x, y);
