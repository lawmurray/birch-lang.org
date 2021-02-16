Probabilistic statements use one of three operators, or the keyword `factor`:
```birch
x <~ p;
x ~> p;
x ~ p;
factor w;
```

Let `x` be a value of basic type (e.g. `Real`) or optional type (e.g. `Real?`), or object of [Random](https://docs.birch.sh/libraries/Standard/classes/Random) type (e.g. `Random<Real>`), and `p` be an object of [Distribution](https://docs.birch.sh/libraries/Standard/classes/Distribution) type. Then:

  * `x <~ p` *simulates* a variate `x` from the distribution `p`,
  * `x ~> p` *observes* a variate `x` from the distribution `p`,
  * `x ~ p` *assumes* that `x` is distributed according to `p`,
  * `factor w` applies an arbitrary log-weight `w` to the current execution.

These statements emit events to an event handler, which is simply an object of type [Handler](https://docs.birch.sh/libraries/Standard/classes/Handler). Event handlers are typically used as an interface between inference methods and models, creating the opportunity for inference methods to intervene in model execution. By default, there is no event handler registered, so the events are ignored. To register an event handler `h:Handler`, use a `with` block:
```birch
with h {
  // do something probabilistic
}
```
The `~` and `<~` operators may be used to assign initial values to variables:

```birch
x:Real <~ Gaussian(0.0, 1.0);
y:Random<Real> ~ Gaussian(0.0, 1.0);
```

They may even be used with `let`:

```birch
let x <~ Gaussian(0.0, 1.0);
let y ~ Gaussian(0.0, 1.0);
```

Here, the type of `x` is inferred to be `Real`, and that of `y` to be `Random<Real>`.

