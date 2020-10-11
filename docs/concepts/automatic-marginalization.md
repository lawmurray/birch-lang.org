# Automatic marginalization

Given a joint distribution $p(\mathrm{d}y,\mathrm{d}x)$, *marginalization* is the computation:
$$
p(\mathrm{d}y)=\int_\mathbb{X} p(\mathrm{d}y,\mathrm{d}x).
$$
That is, we *marginalize out* $x$ (as indicated by the $\mathbb{X}$) to obtain the *marginal distribution* over $y$. When $x$ is a discrete-valued random variable, we may instead write the integral as a sum:
$$
p(\mathrm{d}y)=\sum_{x\in\mathbb{X}}p(\mathrm{d}y, \mathrm{d}x).
$$

A random variable is trivially marginalized out whenever it does not yet have a value, but has a distribution associated with it via the assume (`~`) operator. This is trivial because, unless that random variable is subsequently used, it will never be simulated, and so is marginalized out. More interesting are situations where a random variable is used, but it still remains marginalized out. Consider:
```birch
x ~ Beta(2,0, 2.0);
y <~ Bernoulli(x);
```
Here, `x` can be marginalized out and `y` simulated from its marginal distribution, as the [BetaBernoulli](https://docs.birch.sh/libraries/Standard/classes/BetaBernoulli) form of the joint distribution between `x` and `y` is recognized. Similarly, we could use:
```birch
x ~ Gamma(2.0, 1.0);
y <~ Poisson(x);
```
because the [GammaPoisson](https://docs.birch.sh/libraries/Standard/classes/GammaPoisson) form is recognized, or:
```birch
x ~ Gaussian(0.0, 4.0);
y ~ Gaussian(x, 4.0);
z <~ Gaussian(y, 4.0);
```
because chains of Gaussians are recognized. In this latter case, both `x` and `y` can be marginalized out.

Standard conjugate forms, linear transformations, and sums and differences of discrete random variables are recognized forms for which marginalization is supported.
