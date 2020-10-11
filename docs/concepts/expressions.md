# Expressions

The `Random` class is one of many derived from the [Expression](https://docs.birch.sh/libraries/Standard/classes/Expression) class. `Expression` objects implement *lazy evaluation* of mathematical expressions, as opposed to the *eager evaluation* that is the case otherwise. Many mathematical functions and operators are overloaded for `Expression` objects; instead of evaluating immediately, they construct and return a further `Expression` object.

Assume that we have variables $a$, $x$, and $c$, declared in code as:

```birch
a:Real <- 2.0;
x:Real <- 5.0;
c:Real <- -1.0;
```

`Real` is a basic type. Mathematical operators and functions are overloaded for `Real` to evaluate immediately. For example, in:
```birch
let y <- exp(a*x + c);
```
`y` will have type `Real`, and will contain the result of evaluation $\exp(ax + c) = \exp(2.0 \times 5.0 - 1.0) \approx 8103.08$.

On the other hand, if one or more of $a$, $x$, or $c$ has class type `Expression<Real>` (including `Random<Real>`, as it derives from `Expression<Real>`):
```birch
a:Real <- 2.0;
x:Random<Real>;
c:Real <- -1.0;
```
then alternative overloads are called that construct a further `Expression` object representing the expression itself, rather than its evaluation. If we repeat the previous statement:
```birch
let y <- exp(a*x + c);
```
`y` will now have type `Expression<Real>`. The expression can be evaluated later by calling `y.value()`, although `x` will need to be assigned a value first. There are two ways to do this. We could assign or simulate a value for `x`:
```birch
x <- 5.0;
```
then call `y.value()`. In this case the evaluated value is the same as for the example above. Alternatively, we could use the assume operator to associate a distribution with `x`:
```birch
x ~ Gaussian(5.0, 4.0);
```
When `y.value()` is later called, a value will be simulated from that distribution and assigned to `x`, in order to evaluate `y`. The evaluated value will, of course, depend on that value.
