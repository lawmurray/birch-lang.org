# Expressions

<!--consider example of logpdf of Gaussian with uniformly distributed variance -->

The `Random` class is one of many that derives from the `Expression` class. `Expression` objects implement *lazy evaluation* of mathematical expressions, as opposed to the *eager evaluation* that is the case otherwise. Many mathematical functions and operators are overloaded for `Expression` objects; instead of evaluating immediately, they construct further `Expression`.

Assume that we have variables $a$, $x$, and $c$, declared in code as:

```birch
a:Real;
x:Real;
c:Real;
```

`Real` is a basic type. Mathematical operators and functions are overloaded for `Real` to evaluate immediately. For example, in:

```birch
let y <- exp(a*x + c);
```

`y` will have type `Real`, and will contain the value $\exp(ax + c)$.

On the other hand, one or more of $a$, $x$, or $c$ may have class type `Expression<Real>` (`Random<Real>` derives from `Expression<Real>`):

```birch
a:Real;
x:Random<Real>;
c:Real;
```

When one or more arguments to a mathematical operator or function has class type `Expression`, an alternative overload is called that constructs a further `Expression` object representing the expression, rather than evaluating the operator or function immediately. In the above example, `y` would now have type `Expression<Real>`. The mathematical expression can later be evaluated by calling `y.value()`.

The purpose of `Expression` objects is that they allow an expression to be interrogated to enable automatic marginalization, conditioning and differentiation, as explained below.