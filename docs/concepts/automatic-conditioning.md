# Automatic conditioning

Given a joint distribution $p(\mathrm{d}y,\mathrm{d}x)=p(\mathrm{d}y\mid x)p(\mathrm{d}x)$, *conditioning* is the computation of the *conditional distribution*:
$$
p(\mathrm{d}x\mid y)=\frac{p(y\mid x)p(\mathrm{dx})}{p(y)}.
$$
The computation is also known as *conditioning on $y$*. We may also refer to this as *Bayesian updating*, insofar as we interpret $p(\mathrm{d}x)$ as a prior distribution that we update to a posterior distribution $p(\mathrm{d}x\mid y)$.

Recall an example from the previous section:
```birch
x ~ Gamma(2.0, 1.0);
y ~ Poisson(x);
```
Here both `x` and `y` are marginalized out, but trivially so in the case of `y`, as it has not subsequently been used. Conditioning is triggered when `y` has a value, or must be assigned a value. This can occur in several circumstances:

* If, in the above code, `y` already has a value, or if the second line is replaced with `#!birch y ~> Poisson(x);`.
* If, in the above code, `y` does not already have a value, but one is immediately requested by replacing the second line with `#!birch y <~ Poisson(x);`.
* If the above code remains the same, but `y.value()` is later used to obtain a value for `y`.

In all of these cases `y` adopts a value, but `x` remains marginalized out. However, the distribution attached to `x` is updated to condition on that value of `y`. This way, if `x.value()` is later used to obtain a value for `x`, the distribution for that value is appropriate given the value for `y`.
