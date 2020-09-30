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
  * `x ~ p` *assumes* that `x` is distributed according to `p`.

If `x` has a value, `x ~ p` typically acts like `x ~> p`, while if it does not have a value, `x ~ p` eventually acts something like `x <~ p`, possibly after analytical optimizations.

These statements emit events to an event handler, which is simply an object of type [Handler](https://docs.birch.sh/libraries/Standard/classes/Handler). By default, there is no event handler registered, so the events are ignored. To register an event handler `h`, use a `with` block:
```birch
with h {
  // do something probabilistic
}
```
The `factor` statement sends an arbitrary log-weight `w` to the event handler.

Event handlers are typically used as an interface between inference methods and models, creating the opportunity for inference methods to intervene in model execution.
