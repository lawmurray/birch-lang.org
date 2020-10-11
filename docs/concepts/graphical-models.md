# Graphical models

When we run the `simulate()` and `simulate(t)` member functions of a model, we can think of any particular run as generating a Bayesian network (directed graphical model).

Consider a simple linear regression model with the programmatic representation:
```birch
σ2 ~ InverseGamma(3.0, 0.4);
β ~ Gaussian(vector(0.0, P), diagonal(σ2, P));
y ~ Gaussian(X*β, σ2);
```
We can represent the model mathematically as a factorization of the joint distribution into conditional distributions:
$$
p(\mathrm{d}\sigma^2, \mathrm{d}\beta, \mathrm{d}y) = p(\mathrm{d}\sigma^2) p(\mathrm{d}\beta \mid \sigma^2) p(\mathrm{d}y \mid \beta, \sigma^2).
$$
This factorization is also represented graphically using a directed graphical model as:
```diagram
 .--.       .-.
| σ2 +---->| β +
 '+-'       '+'
  |          |
  |          v
  |         .-.
   '------>| y |
            '-'
```
Each statement in the programmatic representation defines a new factor in the mathematical representation, and a new node in the graphical representation.

In the programmatic representation, the dependencies of each random variable are clear from the arguments given in constructing its associated distribution. In the mathematical representation they appear to the right of the bar ($\mid$) in the corresponding conditional distribution. In the graphical representation they connect with incoming arrows to the corresponding node.

Many useful models can be represented in these three ways. Consider also a linear-Gaussian state-space model (hidden Markov model), represented programmatically as:
```birch
x[1] ~ Gaussian(0.0, 4.0);
y[1] ~ Gaussian(b*x[1], 1.0);
for t in 2..4 {
  x[t] ~ Gaussian(a*x[t - 1], 4.0);
  y[t] ~ Gaussian(b*x[t], 1.0);
}
```
mathematically as:
$$
p(\mathrm{d}x_{1:T}, \mathrm{d}y_{1:T}) = p(\mathrm{d}x_1)p(\mathrm{d}y_1\mid x_1) \prod_{t=2}^T p(\mathrm{d}x_t \mid x_{t-1})p(\mathrm{d}y_t \mid x_t),
$$
and graphically as:
```diagram
 .--.       .--.       .--.       .--.
|x[1]+---->|x[2]+---->|x[3]+---->|x[4]|
 '-+'       '-+'       '-+'       '-+'
   |          |          |          |
   |          |          |          |
   v          v          v          v
 .--.       .--.       .--.       .--.
|y[1]|     |y[2]|     |y[3]|     |y[4]|
 '--'       '--'       '--'       '--'
```
