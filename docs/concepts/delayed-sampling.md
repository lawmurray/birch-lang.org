# Delayed sampling

Automatic marginalization and conditioning are implemented using a heuristic called *delayed sampling*[^1]. This has a small limitation: it supports marginalization through *chains* of random variables, but not through *trees* of random variables. Trees are reduced to chains by simulation where necessary.

Consider:
```birch
x ~ Gamma(2.0, 1.0);
y ~ Poisson(x);
z ~ Poisson(x);
```
Graphically, this can be represented as:
```diagram
       .-.
      | x |
       +-+
      /   \
     v     v
  .-+       +-.
 | y |     | z |
  '-'       '-'
```

This is a tree (the most basic), so delayed sampling cannot maintain a marginal distribution for all three random variables (jointly). Instead---this is the heuristic---it reduces the tree to a chain by simulating `y`. This proceeds as follows:

1. `#!birch x ~ Gamma(1.0, 2.0);`
   `x` is trivially marginalized out.
```diagram
       .-.
      | x |
       '-'
```

2. `#!birch y ~ Poisson(x);`
   `x` is marginalized out, `y` is trivially marginalized out. There is a single chain of marginalized variables.
```diagram
       .-.
      | x |
       +-'
      /
     v
  .-+
 | y |
  '-'
```

3. `#!birch z ~ Poisson(x);`
   Adding `z` to the graph would create a tree of marginalized variables. To avoid this, the delayed sampling heuristic simulates a value for `y` (now depicted as a square rather than circle below). This will break the first branch of the tree that would otherwise be formed. Now `x` is still marginalized out, but conditioned on `y`.
```diagram
       .-.
      | x |
       +-'
      /
     v
 .---.
 | y |
 '---'
```

4. Finally, the new node is added; `x` remains marginalized out, `y` is simulated, `z` is trivially marginalized out. There is only a single chain of marginalized variables.
```diagram
       .-.
      | x |
       +-+
      /   \
     v     v
 .---.      +-.
 | y |     | z |
 '---'      '-'
```

Delayed sampling over Gaussian variables yields some common use-cases without explicit coding. Consider the following linear-Gaussian state-space model:
```birch
x[1] ~ Gaussian(0.0, 4.0);
y[1] ~ Gaussian(b*x[1], 1.0);
for t in 2..4 {
  x[t] ~ Gaussian(a*x[t - 1], 4.0);
  y[t] ~ Gaussian(b*x[t], 1.0);
}
```
For the purposes of demonstration, we assume both `x` and `y` are latent (typically, for such a model, the `x` are latent while the `y` are observed). We see the previous steps repeated on each iteration of the loop: 

1. At the start of the `t`th iteration, both `x[t-1]` and `y[t-1]` are marginalized out.
```diagram
      .----.       .----.       .----.
╌╌╌╌▶|x[t-3]+---->|x[t-2]+---->|x[t-1]|
      '-+--'       '-+--'       '-+--'
        |            |            |
        |            |            |
        v            v            v
     .--+---.     .--+---.      .-+--.
     |y[t-3]|     |y[t-2]|     |y[t-1]|
     '------'     '------'      '----'
```

2. `#!birch x[t] ~ Gaussian(a*x[t - 1], 4.0);`
   Adding `x[t]` to the graph would create a tree of marginalized variables, so `y[t-1]` is simulated to reduce the tree to a chain.
```diagram
      .----.       .----.       .----.
╌╌╌╌▶|x[t-3]+---->|x[t-2]+---->|x[t-1]|
      '-+--'       '-+--'       '-+--'
        |            |            |
        |            |            |
        v            v            v
     .--+---.     .--+---.     .--+---.
     |y[t-3]|     |y[t-2]|     |y[t-1]|
     '------'     '------'     '------'
```

3. Now the new node for the latent state is added; `x[t-1]` and `x[t]` remain marginalized out.
```diagram
      .----.       .----.       .----.       .----.
╌╌╌╌▶|x[t-3]+---->|x[t-2]+---->|x[t-1]+---->| x[t] |
      '-+--'       '-+--'       '-+--'       '----'
        |            |            |
        |            |            |
        v            v            v
     .--+---.     .--+---.     .--+---.
     |y[t-3]|     |y[t-2]|     |y[t-1]|
     '------'     '------'     '------'
```

4. Finally the new node for the observation is added; `x[t-1]`, `x[t]` and `y[t]` remain marginalized out, ready for the next iteration of the loop.
```diagram
      .----.       .----.       .----.       .----.
╌╌╌╌▶|x[t-3]+---->|x[t-2]+---->|x[t-1]+---->| x[t] |
      '-+--'       '-+--'       '-+--'       '-+--'
        |            |            |            |
        |            |            |            |
        v            v            v            v
     .--+---.     .--+---.     .--+---.      .-+--.
     |y[t-3]|     |y[t-2]|     |y[t-1]|     | y[t] |
     '------'     '------'     '------'      '----'
```

In fact, the operations automatically performed for this example are precisely those of the Kalman filter, without having to code them by hand.

[^1]: L.M. Murray, D. Lundén, J. Kudlicka, D. Broman and T.B. Schön (2018). [Delayed Sampling and Automatic Rao&ndash;Blackwellization of Probabilistic Programs](https://arxiv.org/abs/1708.07787). In *Proceedings of the 21st International Conference on Artificial Intelligence and Statistics (AISTATS) 2018*, Lanzarote, Spain.
