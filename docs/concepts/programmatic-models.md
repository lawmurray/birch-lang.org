# Programmatic models

We now consider some new models that are more difficult to represent graphically.

Consider a spike-and-slab model, such as might be used to predict rainfall: with some probability it does not rain at all, otherwise it does rain, and the number of millimetres might be gamma-distributed:
```birch
b <~ Bernoulli(0.9);
if b {
  x <- 0.0;
} else {
  x ~ Gamma(2.0, 100.0);
}
```
The random variable `b` affects the control flow of the program by affecting whether the true or false branch of the `if` statement is taken. The control flow is stochastic: each time the program is run a random choice is made as to which branch to take.

Consider enumerating the components of a Gaussian mixture model with a random number of components:
```birch
K <~ Geometric(0.25);
for k in 1..K {
  σ2[k] ~ InverseGamma(2.0, 5.0);
  μ[k] ~ Gaussian(0.0, 0.1*σ2);
}
```
The random variable `K` affects the control flow of the program by setting the number of iterations in the `for` loop. Each time the program runs the loop will iterate a random number of times.

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
Here, the `while` loop executes a random number of times.

All of these programs exhibit *stochastic branching*. They are difficult to draw as graphical models because on each run they may generate a different set of random variables and dependencies between them---a different set of nodes and edges between them---a different graphical model. For this reason, we say that **a programmatic model defines a distribution over graphical models**.
