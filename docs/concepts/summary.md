# Summary

We have introduced the building blocks of probabilistic modeling in Birch, with fundamental representations and computations including:

* [Distribution](https://docs.birch.sh/libraries/Standard/classes/Distribution), [Random](https://docs.birch.sh/libraries/Standard/classes/Random), [Expression](https://docs.birch.sh/libraries/Standard/classes/Expression) and [Model](https://docs.birch.sh/libraries/Standard/classes/Model) objects,

* the simulate (`<~`), observe (`~>`) and assume (`~`) probabilistic operators,

* the fundamental computations of *automatic differentiation*, *automatic marginalization*, and *automatic conditioning*, as well as the *delayed sampling* heuristic used to implement the latter two,

* the concept of *stochastic branching*, where random variables affect the control flow of a program, and

* the concept of a *programmatic model*, as defining a distribution over graphical models.
