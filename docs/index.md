# Probabilistic Programming in Birch

![Birch trunk](/images/trunk.jpg)

Birch is an imperative, object-oriented, universal probabilistic
programming language. It compiles to C++14 with shared-memory parallelism
provided by [OpenMP](https://www.openmp.org/) and fast numerics by [Eigen](http://eigen.tuxfamily.org/). It is free and open source software for Linux, macOS and Windows.

Probabilistic models are specified in Birch by writing a program to
simulate the joint distribution. Inference methods are also written in
the language. Sequential Monte Carlo (SMC) is currently supported, with
analytical optimizations&mdash;such as locally-optimal proposals and
Rao&ndash;Blackwellization&mdash;applied automatically, and efficient memory management via a pooled and copy-on-write memory manager that leverages the path coalescence inherent in these algorithms.

Research and development of Birch is ongoing, but the above already makes it very useful. See [Getting Started](/getting-started/installing) to try it yourself.

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

* [PROBPROG 2018](http://probprog.cc) in Boston. [Lawrence Murray](https://www.indii.org/research) on *Automated learning with a probabilistic programming language: Birch*. [[slides]](/talks/automated-learning-slides.pdf)

* [AIStats 2018](https://www.aistats.org) in Lanzarote. [Lawrence Murray](https://www.indii.org/research) on *Delayed Sampling and Automatic Rao&ndash;Blackwellization of Probabilistic Programs*. [[slides]](/talks/delayed-sampling-slides.pdf) [[poster]](/talks/delayed-sampling-poster.pdf)

* [BayesComp 2018](https://www.maths.nottingham.ac.uk/personal/tk/bayescomp/) in Barcelona. [Lawrence Murray](https://www.indii.org/research) on *The Birch Probabilistic Programming Language*. [[slides]](/talks/the-birch-probabilistic-programming-language-slides.pdf)

## Papers

* L.M. Murray and T.B. Schön (2018). [Automated learning with a probabilistic programming language: Birch](https://dx.doi.org/10.1016/j.arcontrol.2018.10.013). *Annual Reviews in Control* **46**:29--43. [[arxiv]](https://arxiv.org/abs/1810.01539)

 * L.M. Murray, D. Lundén, J. Kudlicka, D. Broman and T.B. Schön (2018). [Delayed Sampling and Automatic Rao&ndash;Blackwellization of Probabilistic Programs](https://arxiv.org/abs/1708.07787). *Proceedings of the 21st International Conference on Artificial Intelligence and Statistics (AISTATS)*.
