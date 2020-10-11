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
`Distribution<Integer>` (over $\mathbb{Z}$), `Real[_]` (over $\mathbb{R}^D$), etc. However, we do not usually do this directly. The idiom is to use a *factory function* of the particular distribution that we would like to use (e.g. [Gaussian](https://docs.birch.sh/libraries/Standard/classes/Gaussian), [Gamma](https://docs.birch.sh/libraries/Standard/classes/Gamma), [Beta](https://docs.birch.sh/libraries/Standard/classes/Beta), [Uniform](https://docs.birch.sh/libraries/Standard/classes/Uniform)) in combination with the `<~`, `~>` or `~` operator. For example, to simulate a variate from a Gaussian distribution with mean `0.0` and variance `4.0`:

```birch
x:Real;
x <~ Gaussian(0.0, 4.0);
```

The factory function `Gaussian()` creates an object of class `Gaussian`, which derives from class `Distribution<Real>`. The `<~` then simulates a variate from it, and assigns the value of that variate to the variable `x`. We could instead use code such as the following:

```birch
p:Distribution<Real> <- Gaussian(0.0, 4.0);
x:Real;
x <~ p;
```

That works, and is perfectly correct, just not idiomatic.

Similarly, we can observe a variate with the `~>` operator. For example, to observe a variate of value `1.5823` from a Gaussian distribution with mean `0.0` and variance `4.0`:

```birch
1.5823 ~> Gaussian(0.0, 4.0);
```

or we could, of course, assign the value to a variable first and use that:

```birch
let x <- 1.5823;
x ~> Gaussian(0.0, 4.0);
```

Probabilistic operators such as `<~` and `~>` emit events that are handled by an event handler (an object of type [Handler](https://docs.birch.sh/libraries/Standard/classes/Handler)). When writing a model, this is typically not your concern. Event handlers are typically written in the context of writing an inference method, and allow that inference method to update its state as the events occur, or even control the model as it is running. For example, an importance sampling method may internally update a weight when the `~>` operator is used. Or, a Markov chain Monte Carlo method may have the need to replay a past execution, and so plug in a previous value, rather than simulating a new one, when the `<~` operator is used. These are not your concern when writing a model, just remember: `<~` to simulate, `~>` to observe. We will introduce the other operator, `~`, next.