# Automatic marginalization

Given a joint distribution $p(\mathrm{d}x,\mathrm{d}y) = p(\mathrm{d}x) p(\mathrm{d}y\mid x)$, *marginalization* is the computation:
$$
p(\mathrm{d}y)=\int_\mathbb{X} p(\mathrm{d}x) p(\mathrm{d}y\mid x).
$$
That is, we *marginalize out* $x$ (as indicated by the $\mathbb{X}$) to obtain the *marginal distribution* over $y$.

When $x$ is a discrete-valued random variable, we may instead write the integral as a sum:
$$
p(\mathrm{d}y)=\sum_{x\in\mathbb{X}} p(x) p(\mathrm{d}y\mid x).
$$

!!! tip
    Automatic marginalization is supported for standard conjugate forms, linear transformations, and sums and differences of discrete random variables.

A random variable is trivially marginalized out whenever it does not yet have a value, but has a distribution associated with it via the assume (`~`) operator. This is trivial because, unless that random variable is subsequently used, it will never be simulated, and so is marginalized out. More interesting are situations where a random variable is used, but it still remains marginalized out. Consider:
```birch
x ~ Beta(2,0, 2.0);
y <~ Bernoulli(x);
```
Here, `x` can be marginalized out and `y` simulated from its marginal distribution, as the [beta-Bernoulli](https://birch-docs.indii.org/libraries/Standard/classes/BetaBernoulliDistribution) form of the joint distribution between `x` and `y` is recognized. Specifically, the code defines $p(\mathrm{d}x,\mathrm{d}y) = p(\mathrm{d}x) p(\mathrm{d}y\mid x)$, and from this, automatic marginalization computes $p(\mathrm{d}y)$, a beta-Bernoulli distribution, which was not explicitly defined.

Similarly, we could use:
```birch
x ~ Gamma(2.0, 1.0);
y <~ Poisson(x);
```
because the [gamma-Poisson](https://birch-docs.indii.org/libraries/Standard/classes/GammaPoissonDistribution) form is recognized, or:
```birch
x ~ Gaussian(0.0, 4.0);
y ~ Gaussian(x, 4.0);
z <~ Gaussian(y, 4.0);
```
because chains of Gaussians are recognized. In this latter case, both `x` and `y` can be marginalized out.
