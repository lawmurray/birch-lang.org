Lambda (anonymous) functions may appear in expressions as:
```birch
\(a:A, b:B) -> C {
  c:C;
  // do something
  return c;
}
```
The type of such a lambda is `\(A, B) -> C`. It is possible to declare a variable of this *function type*:
```birch
f:\(A, B) -> C;
```
to assign values to it:
```birch
f <- \(a:A, b:B) -> C {
      c:C;
      // do something
      return c;
    };
```
and to call it:
```birch
f(a, b);
```

Functions can accept lambdas as arguments. Such a function may be declared:
```birch
function g(f:\(A, B) -> C) -> D {
    d:D;
    // do something
    return d;
}
```
and be called with:
```birch
g(\(a:A, b:B) -> C {
      c:C;
      // do something
      return c;
    });
```
or, if the lambda was previously assigned to a variable `f:\(A, B) -> C` as above:
```birch
g(f);
```
