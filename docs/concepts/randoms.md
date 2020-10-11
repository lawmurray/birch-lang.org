# Randoms

We again introduce some notation:

| Mathematical           | Description                                                  | Programmatic  |
| ---------------------- | ------------------------------------------------------------ | ------------- |
| $X\in \mathbb{X}$      | A random variable in the set (of type) $\mathbb{X}$.         | `x:Random<X>` |
| $X\sim p(\mathrm{d}x)$ | Assume that the random variable $X$ is distributed according to the distribution $p(\mathrm{d}x)$. | `x ~ p`       |

The notion of a random variable in Birch is somewhat informal, or at least does not follow the formal mathematical definition of it being a function. We simply think of it as a variable that can take on a randomly-generated value from a probability distribution. For this reason we often just call it a *random*—a slightly awkward use of the word as a noun, but no more so than [optional](https://www.birch.sh/language/optionals/), which is also established.

In Birch code, we can create a random by declaring a variable with the type `Random<X>`, where `X` is the type of variate it will accept, e.g. `Random<Real>` (on $\mathbb{R}$), `Random<Integer>` (on $\mathbb{Z}$), `Random<Real[_]>` (on $\mathbb{R}^D$), etc—much like `Distribution`.

We can declare a random and assign a value to it:

```birch
x:Random<Real>;
x <- 1.5823;
```

We could even simulate a value into it:

```birch
x <~ Gaussian(0.0, 4.0);
```

It is only possible to assign a value once, however. Once a random has a value, it cannot be changed. This is important for correctness.

We can get the value assigned to a random with `x.value()`, possibly while observing:

```birch
x.value() ~> Gaussian(0.0, 4.0);
```

While we can do these things, a `Random<Real>` offers no real benefit over a basic value `x:Real` for these use cases. Where it becomes most useful, however, is that it works with the `~` operator, whereas a basic value does not:

```birch
x:Random<Real>;
x ~ Gaussian(0.0, 4.0);
```

Like the simulate (`<~`) and observe (`~>`) operators, the assume (`~`) operator emits an event that is handled by an event handler. But the assume operator offers a lot more flexibility than these other operators. For example, the event handler may check whether the random already has a value, and if so treat it much like the observe operator, if not treat it much like the simulate operator. That can be useful for representing missing values. But it may do much more elaborate things too. It allows the representation of joint distributions:

```birch
x:Random<Real>;
y:Random<Boolean>;
x ~ Beta(2.0, 2.0);
y ~ Bernoulli(x);
```

This may allow `x` to be marginalized out, so as to simulate or observe `y` without first simulating having a value for `x`. If that occurs, the distribution over `x` can be updated by conditioning, to later simulate conditionally given the value for `y`.

We will illustrate these computations later.
