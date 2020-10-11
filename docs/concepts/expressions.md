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
`y` will have type `Real`, and will contain the result of evaluation $\exp(ax + c) = \exp(2.0*5.0 - 1.0) \approx 24.4645$.

On the other hand, one or more of $a$, $x$, or $c$ may have class type `Expression<Real>` (including `Random<Real>`, as it derives from `Expression<Real>`):
```birch
a:Real <- 2.0;
x:Random<Real>;
c:Real <- -1.0;
```
When one or more arguments to a mathematical operator or function has class type `Expression`, an alternative overload is called that constructs a further `Expression` object representing the expression, rather than evaluating the operator or function immediately.

If we repeat the previous statement now:
```birch
let y <- exp(a*x + c);
```
`y` will now have type `Expression<Real>`. The mathematical expression can be later evaluated by calling `y.value()`, although `x` will need to be assigned a value first. There are two ways to do this. We could assign or simulate a value for `x`:
```birch
x <- 5.0;
```
then call `y.value()`. In this case the evaluated value is the same as for the example above. Alternatively, we could use the assume operator to associate a distribution with `x`:
```birch
x ~ Gaussian(5.0, 4.0);
```
When `y.value()` is later called, a value will be simulated from that distribution and assigned to `x`, in order to evaluate `y`.
