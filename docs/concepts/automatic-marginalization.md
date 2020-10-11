# Automatic marginalization

Given a joint distribution $p(\mathrm{d}y,\mathrm{d}x)=p(\mathrm{d}y\mid x)p(\mathrm{d}x)$, *marginalization* is the computation of the *marginal distribution*:
$$
p(\mathrm{d}y)=\int_\mathbb{X} p(\mathrm{d}y\mid x)p(\mathrm{d}x).
$$
When $x$ is a discrete-valued random variable, we may instead write the integral as a summation:
$$
p(\mathrm{d}y)=\sum_{x\in\mathbb{X}}p(\mathrm{d}y\mid x)p(x).
$$
The computation is also known as *marginalizing out* $x$, or *marginalizing over* $x$, to obtain this marginal distribution. The terminology *variable elimination* (of $x$) is also used.

Standard conjugacy relationships (e.g. beta-Bernoulli, beta-binomial, gamma-Poisson, Gaussian chains), linear relationships, and sums and differences of discrete random variables are recognized relationships for which marginalization is supported.

A random variable is trivially marginalized out whenever it has a distribution attached to it with the `~` operator---trivial because, unless the variable is subsequently used it is simulated, and so marginalized out. This is not so interesting. Where it does get interesting is where the variable is subsequently used, and yet still does not need to be simulated. For this to occur, the subsequent use of the random variable must follow a recognized pattern. Consider:
```birch
x ~ Beta(2,0, 2.0);
y ~ Bernoulli(x);
```
Here, `x` can be marginalized out, as the [BetaBernoulli](https://docs.birch.sh/libraries/Standard/classes/BetaBernoulli) relationship is recognized. Similarly, we could use:
```birch
x ~ Gamma(2.0, 1.0);
y ~ Poisson(x);
```
because the [GammaPoisson](https://docs.birch.sh/libraries/Standard/classes/GammaPoisson) relationship is recognized, or:
```birch
x ~ Gaussian(0.0, 4.0);
y ~ Gaussian(x, 4.0);
z ~ Gaussian(y, 4.0);
```
because chains of Gaussians are recognized. In this last case, both `x` and `y` can be marginalized out, as Gaussians chains. Indeed, many different relationships among Gaussian random variables are supported, including linear transformations, multivariate and matrix forms.

In the next section, we look at what happens when a simulation is triggered for `y` (or `z`) in these examples.
