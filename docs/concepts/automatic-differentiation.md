# Automatic differentiation

In the following sections we look at various probabilistic computations, and how they are supported by the probabilistic representations introduced in preceding sections.

!!! tip
    Take home message of the next few sections: use a `Random` object whenever you want to do something clever with a random variable, such as marginalize it out, condition it on future observations, or compute a gradient with respect to it. Otherwise use a basic value.

We begin with differentiation.

Consider a scalar function $f:\mathbb{R}^D \rightarrow \mathbb{R}$. We are interested in evaluating its gradient $\nabla f(x)$ at a given point $x \in \mathbb{R}^D$.

Typically, a gradient is computed for the purpose of a gradient-based Markov kernel---such as a Langevin or Hamiltonian kernel---and $f$ is a log-likelihood function:
$$
f(x):=\log p(y\mid x)
$$
or a log-prior density function:
$$
f(x) := \log p(x).
$$
or a log-posterior density function:
$$
f(x) := \log p(x \mid y).
$$

The idea of *automatic differentiation* is to evaluate $\nabla f(x)$ given only a program that implements $f$. To do so, Birch implements reverse-mode automatic differentiation, with optimizations for common subexpressions, which happens to be important for computing derivatives through Bayesian updates. The use of this algorithm is described in the documentation of the [Expression](https://docs.birch.sh/libraries/Standard/classes/Expression) class. Our focus here, however, is not to explain how a gradient can be computed---that is typically done by inference methods---but rather how one writes a model to facilitate its use.

Automatic differentiation is applied to an `Expression<Real>` object, which represents the function $f$, and the gradient is computed with respect to all `Random` objects that occur in the expression, which represent the argument $x$. To enable, say, a gradient-based Markov kernel to be applied to a random variable, it is only necessary to represent that random variable using a `Random` object, and to associate it with a distribution using the assume (`~`) operator.

Once the `value()` member function is called on a `Random` object, it is considered constant for the purposes of automatic differentiation.
