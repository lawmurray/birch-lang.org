# Probabilistic Programming in Birch

![Birch tree](/images/trunk.jpg)

Birch is an imperative, object-oriented, universal probabilistic programming language. It is open source, and compiles to C++14 for use on Linux, macOS or Windows.

> **Example:** a linear-Gaussian state-space model written in Birch.
>
>     β:Real <- 0.9;
>     σ2:Real <- 1.0;
>     T:Integer <- 10;
>     x:Random<Real>[T];
>     y:Random<Real>[T];
>
>     x[1] ~ Gaussian(0.0, σ2);
>     y[1] ~ Gaussian(x[1], σ2);  
>     for (t:Integer in 2..T) {
>       x[t] ~ Gaussian(β*x[t - 1], σ2);
>       y[t] ~ Gaussian(x[t], σ2);
>     }

Probabilistic models are specified in Birch by writing programs that simulate from the joint distribution. Inference methods are also written in the Birch language. Sequential Monte Carlo (SMC) is currently supported, with analytical optimizations such as variable elimination and Rao--Blackwellization.

## Getting Started

See [Getting Started](/getting-started/installing.md) to get up and running on Linux, macOS or Windows.

## Upcoming talks

* [BayesComp 2018](https://www.maths.nottingham.ac.uk/personal/tk/bayescomp/) in Barcelona. [Lawrence Murray](https://www.indii.org/research) on *The Birch Probabilistic Programming Language*.
* [AIStats 2018](https://www.aistats.org) in Lanzarote. [Lawrence Murray](https://www.indii.org/research) on *Delayed Sampling and Automatic Rao--Blackwellization of Probabilistic Programs*.

## Papers

 * L.M. Murray, D. Lundén, J. Kudlicka, D. Broman and T.B. Schön (2017). [Delayed Sampling and Automatic Rao--Blackwellization of Probabilistic Programs](https://arxiv.org/abs/1708.07787).

## Acknowledgements

The development of Birch is financially supported by the [Swedish Foundation for Strategic Research](https://strategiska.se/en/) (SSF) via the project [ASSEMBLE](http://www.it.uu.se/research/assemble).
