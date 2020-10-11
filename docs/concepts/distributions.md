# Distributions

We first introduce some notation for probability distributions:

| Mathematical           | Description                                                  | Programmatic        |
| ---------------------- | ------------------------------------------------------------ | ------------------- |
| $p(\mathrm{d}x)$       | A distribution.                                              | `p:Distribution<X>` |
| $x\sim p(\mathrm{d}x)$ | Simulate a variate $x$ from the distribution $p(\mathrm{d}x)$. | `x <~ p`            |
| $\log p(x)$            | Evaluate the logarithm of the probability density (mass) function associated with the distribution $p(\mathrm{d}x)$ at the value $x$. | `x ~> p`            |

This notation may be unfamiliar, particularly as many texts rely on context, rather than notation, to distinguish between a probability distribution $p(\mathrm{d}x)$ and its associated probability density (mass) function $p(x)$, using the notation $p(x)$ for both. In what follows, the distinction in notation becomes useful. In a probabilistic program we can perform many computations associated with the one probability distribution: simulate from it, evaluate its probability density (mass) function, evaluate its cumulative distribution function, compute its mean or variance, upper or lower bound, median or some other quantile. So we make the distinction in notation to use $p(\mathrm{d}x)$ to denote the distribution itself, and $p(x)$ for the particular computation of its probability density (mass) function.

!!! tip
    You may recognize the notation $p(\mathrm{d}x)$ from measure theory. We will not adopt measure-theoretic terms otherwise, but find the notation useful.

In Birch code, a distribution is represented by an object of the [Distribution](https://docs.birch.sh/libraries/Standard/classes/Distribution) class. This is a generic class: we use it as `Distribution<X>`, where `X` is the domain of the distribution, e.g. `Distribution<Real>` (over $\mathbb{R}$), 
`Distribution<Integer>` (over $\mathbb{Z}$), `Real[_]` (over $\mathbb{R}^D$), etc. However, we do not usually use `Distribution<X>` directly. Instead we use one of its derived classes, such as [Gaussian](https://docs.birch.sh/libraries/Standard/classes/Gaussian), [Gamma](https://docs.birch.sh/libraries/Standard/classes/Gamma), [Beta](https://docs.birch.sh/libraries/Standard/classes/Beta), [Uniform](https://docs.birch.sh/libraries/Standard/classes/Uniform)). The idiom is to use a *factory function* for the particular distribution of interest in combination with a probabilistic operator. For example, we can simulate from a distribution with the *simulate* operator (`<~`):
```birch
x:Real;
x <~ Gaussian(0.0, 4.0);
```

The factory function `Gaussian()` creates an object of class `Gaussian`, which derives from class `Distribution<Real>`. The `<~` operator then simulates a variate from it, and assigns the value of that variate to the variable `x`. We can instead use code such as the following:
```birch
x:Real;
p:Distribution<Real> <- Gaussian(0.0, 4.0);
x <~ p;
```
which works, and is perfectly correct, just not idiomatic.

We can observe a variate with the *observe* operator (`~>`). For example, to observe a variate of value `1.5823` from a Gaussian distribution with mean `0.0` and variance `4.0`:
```birch
1.5823 ~> Gaussian(0.0, 4.0);
```
Or we could, of course, assign the value to a variable first and use that:
```birch
let x <- 1.5823;
x ~> Gaussian(0.0, 4.0);
```
