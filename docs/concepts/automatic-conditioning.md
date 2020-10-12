# Automatic conditioning

Given a joint distribution $p(\mathrm{d}y,\mathrm{d}x)$, *conditioning* is the computation:
$$
p(\mathrm{d}x\mid y)=\frac{p(y\mid x)p(\mathrm{dx})}{p(y)}.
$$
That is, we *condition* on the value of $y$ to obtain the *conditional distribution* of $x$ given $y$. We may also refer to this as *Bayesian updating*, insofar as we interpret $p(\mathrm{d}x)$ as a prior distribution that we update to a posterior distribution $p(\mathrm{d}x\mid y)$.

Consider:
```birch
x ~ Gamma(2.0, 1.0);
y ~ Poisson(x);
```
Conditioning is triggered when `y` obtains a value. This can occur in several circumstances:

* If, in the above code, `y` already has a value, or if the second line is replaced with `#!birch y ~> Poisson(x);`, then the conditioning is triggered immediately.
* If, in the above code, `y` does not already have a value, but one is requested by replacing the second line with `#!birch y <~ Poisson(x);`, then the conditioning is triggered immediately.
* If the above code remains the same, but `y.value()` is later used to obtain a value for `y`, then the conditioning is triggered at that time.

In all of these cases `x` remains marginalized out, but the distribution associated with it is updated to the conditional distribution of `x` given `y`. If `x.value()` is later used to obtain a value for `x`, it will be drawn from that conditional distribution. In this way random variables are simulated consistently from the joint distribution.

Conditioning can occur multiple times:
```birch
x ~ Gamma(2.0, 1.0);
y <~ Poisson(x);
z <~ Poisson(x);
```
Here, the distribution associated with `x` is updated twice, to the conditional distribution given both `y` and `z`.
