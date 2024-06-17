# Randoms

We again introduce some notation:

| Mathematical           | Description                                                  | Programmatic  |
| ---------------------- | ------------------------------------------------------------ | ------------- |
| $X\in \mathbb{X}$      | A random variable in the set (of type) $\mathbb{X}$.         | `x:Random<X>` |
| $X\sim p(\mathrm{d}x)$ | Assume that the random variable $X$ is distributed according to the distribution $p(\mathrm{d}x)$. | `x ~ p`       |

In Birch code, a random variable is represented by an object of the [Random](https://docs.birch-lang.org/libraries/Standard/classes/Random) class. Like `Distribution`, `Random` is a generic class: we use it as `Random<X>`, where `X` is the type of variate it accepts, e.g. `Random<Real>` (on $\mathbb{R}$), `Random<Integer>` (on $\mathbb{Z}$), `Random<Real[_]>` (on $\mathbb{R}^D$), etc.

We can declare a random variable:
```birch
x:Random<Real>;
```
and assign a value into it:
```birch
x <- 1.5823;
```
We can even simulate a value into it:
```birch
x <~ Gaussian(0.0, 4.0);
```

It is only possible to assign or simulate a value once into a random variable, however. Once it has a value, it cannot be reassigned. We can get the value assigned to a random with `x.value()`, possibly while observing:
```birch
x.value() ~> Gaussian(0.0, 4.0);
```

For these use cases, a `Random<Real>` object offers no real benefit over a basic `x:Real` value. Where it becomes more useful is in conjunction with the *assume* operator (`~`):
```birch
x ~ Gaussian(0.0, 4.0);
```
The assume operator can also be used to represent joint distributions between random variables:
```birch
x:Random<Real>;
y:Random<Boolean>;
x ~ Beta(2.0, 2.0);
y ~ Bernoulli(x);
```

`Random` objects, in combination with the assume operator (`~`), facilitate probabilistic computations such as automatic marginalization, conditioning and differentiation. We will return to such computations later.
