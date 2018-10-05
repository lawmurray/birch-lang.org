# Probabilistic Programming in Birch

![Birch tree](/images/trunk.jpg)

Birch is an imperative, object-oriented, universal probabilistic
programming language. It compiles to C++14 for Linux, macOS, and
Windows 10, and is free and open source.

Probabilistic models are specified in Birch by writing a program to
simulate the joint distribution. Inference methods are also written in
Birch. Sequential Monte Carlo (SMC) is currently supported, with
analytical optimizations&mdash;such as locally-optimal proposals and
Rao&ndash;Blackwellization&mdash;applied automatically.

See [Getting Started](/getting-started/installing.md) to try it yourself.


## Example

A simple linear-Gaussian state-space model written in Birch.

    β:Real <- 0.9;
    σ2:Real <- 1.0;
    T:Integer <- 10;
    x:Random<Real>[T];
    y:Random<Real>[T];

    x[1] ~ Gaussian(0.0, σ2);
    y[1] ~ Gaussian(x[1], σ2);  
    for (t:Integer in 2..T) {
      x[t] ~ Gaussian(β*x[t - 1], σ2);
      y[t] ~ Gaussian(x[t], σ2);
    }

## Talks

* [PROBPROG 2018](http://probprog.cc) in Boston. [Lawrence Murray](https://www.indii.org/research) on *Automated learning with a probabilistic programming language: Birch*.

* [AIStats 2018](https://www.aistats.org) in Lanzarote. [Lawrence Murray](https://www.indii.org/research) on *Delayed Sampling and Automatic Rao&ndash;Blackwellization of Probabilistic Programs*. [[slides]](/talks/delayed-sampling-slides.pdf) [[poster]](/talks/delayed-sampling-poster.pdf)

* [BayesComp 2018](https://www.maths.nottingham.ac.uk/personal/tk/bayescomp/) in Barcelona. [Lawrence Murray](https://www.indii.org/research) on *The Birch Probabilistic Programming Language* [[slides]](/talks/the-birch-probabilistic-programming-language-slides.pdf)

## Papers

* L.M. Murray and T.B. Schön (2018). [Automated learning with a probabilistic programming language: Birch](https://arxiv.org/abs/1810.01539). To appear in *Annual Reviews in Control*.

 * L.M. Murray, D. Lundén, J. Kudlicka, D. Broman and T.B. Schön (2018). [Delayed Sampling and Automatic Rao&ndash;Blackwellization of Probabilistic Programs](https://arxiv.org/abs/1708.07787). *Proceedings of the 21st International Conference on Artificial Intelligence and Statistics (AISTATS)*.

## Acknowledgements

The development of Birch is financially supported by the [Swedish Foundation for Strategic Research](https://strategiska.se/en/) (SSF) via the project [ASSEMBLE](http://www.it.uu.se/research/assemble).
