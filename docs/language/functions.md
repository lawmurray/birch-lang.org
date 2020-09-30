A function with two parameters `a:A` and `b:B`, and return type `C`, is declared as:
```birch
function f(a:A, b:B) -> C {
  c:C;
  // do something
  return c;
}
```

For a function without a return value, omit the `->`:
```birch
function f(a:A, b:B) {
  // do something
}
```
For a function without parameters, use empty parentheses:
```birch
function f() {
  // do something
}
```
Functions are called by giving arguments in parentheses:
```birch
f(a, b)
```
When calling a function without parameters, use empty parentheses:
```birch
f()
```

### Generic functions

A function declaration may include type parameters that are provided arguments when the function is called. These are declared using angle brackets in the function declaration:
```birch
function f<T,U>(a:T, b:U) {
  // do something
}
```
Such a function is a *generic function*. When a generic function is called, type arguments can be provided:
```birch
f<Real,Integer>(1.0, 2);
```
Here, `T` becomes `Real` and `U` becomes `Integer`. In many cases it is unnecessary to explicitly provide these type arguments, however, as the compiler can deduce them itself. In this particular example, using `f(1.0, 2)` is sufficient. Sometimes the compiler cannot deduce them itself, and they must be specified explicitly.
