# Automatic differentiation

Another common operation is to compute the gradient of a function $f:\mathbb{R}^D \rightarrow \mathbb{R}$  at a given point $x \in \mathbb{R}^D$:
$$
d=\frac{\mathrm{d}f}{\mathrm{d}x}\left(x\right).
$$
In the context of probabilistic computations, we are usually interested in the situation where $f$ is a log-likelihood:
$$
f(x):=\log p(y\mid x)
$$
or log-prior:
$$
f(x) := \log p(x).
$$
We do not necessarily need the entire derivative function $\frac{\mathrm{d}f}{\mathrm{d}x}$, but rather just its value at the particular point $x$.

The idea of *automatic differentiation* is that the programmer only implements $f:\mathbb{X} \rightarrow \mathbb{R}$, but from this implementation it is  possible to evaluate both $f(x)$ and $f^\prime(x)$. We are only trying to evaluate these functions here; we never actually construct the function $f^\prime:\mathbb{X} \rightarrow \mathbb{R}$ (that is referred to as *symbolic differentiation*).
