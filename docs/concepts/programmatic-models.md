# Programmatic models

Much like a graphical model is a probabilistic model expressed in a graphical language, a programmatic model is a probabilistic model expressed in a programming language. A key feature of programmatic models is that random variables can influence control flow of the program. This is referred to as *stochastic branching*.

Consider a spike-and-slab model, as might be used to predict rainfall: with some probability it does not rain at all, otherwise it does rain, and the number of millimetres ($r$) might be gamma-distributed, dependent on the temperature ($t$):
```birch
t <~ Gaussian(25.0, 4.0);
c <~ Bernoulli(0.9);
if !c {
  r <- 0.0;
} else {
  r <~ Gamma(2.0, 5.0 + t/25.0);
}
```
The random variable `c` affects the control flow of the program. Each time the program is run a random choice is made as to which branch of the `if` statement is taken. If the true branch is taken, `r` does not depend on `t`, otherwise `r` does depend on `t`. We can represent the model mathematically as:

$$
p(\mathrm{d}t, \mathrm{d}c, \mathrm{d}r) = p(\mathrm{d}t) p(\mathrm{d}c) p(\mathrm{d}r \mid t, c),
$$

and graphically as:
```diagram
 .-.       .-.
| t |     | c |
 '-+       +-'
    \     /
     v   v
      +-+
     | r |
      '-'
```
But there is some information lost in these representations: they do not indicate that the variable `c` affects control flow, and in doing so actually mediates whether or not an edge occurs between `t` and `r`. Instead, this relationship will need to be encoded in the conditional distribution $p(\mathrm{d}r \mid t, c)$.

An `if` statement may have significant deviation between branches. Consider a model selection task:
```birch
c <~ Bernoulli(0.5);
if c {
  // run model A
} else {
  // run model B
}
```
The two models could involve very different sets of random variables and dependencies between them, i.e. different graphical models.

Loops can also exhibit stochastic branching. Consider enumerating the components of a Gaussian mixture model with a random number of components:
```birch
K <~ Geometric(0.25);
for k in 1..K {
  σ2[k] ~ InverseGamma(2.0, 5.0);
  μ[k] ~ Gaussian(0.0, 0.1*σ2);
}
```
The random variable `K` affects the control flow of the program. Each time the program is run, the `for` loop iterates a random number of times.

Finally, consider a population model of an animal species, simulated with the Gillespie algorithm, where a random number of birth or death events occur in any given time interval:
```birch
T <- 10.0;  // end time
x <- 100;  // starting population
t <~ Exponential(1.0);  // time of first event
while t < T {
  b <~ Bernoulli(0.5);
  if b {
    x <- x + 1;  // birth event
  } else {
    x <- x - 1;  // death event
  }
  Δ <~ Exponential(1.0);  // time to next event
  t <- t + Δ;  // time of next event
}
```
Here, the `while` loop executes a random number of times, until the `t < T` condition fails.

!!! tip
    All of these programs exhibit stochastic branching. On each run they may generate a different set of random variables and dependencies between them, i.e. a different set of nodes and edges between them, i.e. a different graphical model. For this reason, we say that **a programmatic model defines a distribution over graphical models**.
