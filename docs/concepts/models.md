# Models

As already introduced in the [Getting Started](/getting-started/linear-regression) section, models are implemented by writing a class derived from `Model` and overriding the member function `simulate()`. Optionally, it is also possible to override the member functions `size()` and `simulate(t:Integer)` so that the model unfolds incrementally, over a number of epochs.

| Mathematical | Description | Programmatic |
| ------------ | ----------- | ------------ |
| $p(\mathrm{d}x_{0:T})$ | The model. | `m:Model` |
| $T$ | Number of epochs. | `m.size()`|
| $X_0$ | Random variables in the initial epoch. | Usually member variables of `m`, or local variables of `m.simulate()` |
| $X_t$ | Random variables in the $t$th epoch. | Usually member variables of `m` or local variables of `m.simulate(t)` |
| $x_0 \sim p(\mathrm{d}x_0)$ | Simulate the initial model. | `m.simulate()` |
| $x_t \sim p(\mathrm{d}x_t\mid x_{0:t-1})$ | Simulate the $t$th epoch. | `m.simulate(t)` |

Some classes derive from `Model` to provide further structure to each epoch, such as [MarkovModel](https://docs.birch.sh/libraries/Standard/classes/MarkovModel) and [HiddenMarkovModel](https://docs.birch.sh/libraries/Standard/classes/HiddenMarkovModel).

When implementing the `simulate()` and `simulate(t)` member functions, we make use of all the building blocks previously described to enumerate the random variables of the model and their relationships. This includes `Distribution`, `Random` and `Expression` objects, as well as the `<~`, `~>` and `~` operators.

Examples are provides over the following sections.
