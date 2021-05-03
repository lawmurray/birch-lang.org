# Markov Model

We will now implement a simple SIR (susceptible-infectious-recovered) compartmental model of an epidemic, using a classic data set of an outbreak of influenza at a boarding school.

## Model

The model is described in three parts: a *parameter* model, an *initial* model, and a *transition* model. Time is indexed by $t$, in days. The state consists of variables $s_t$, $i_t$, and $r_t$, giving counts of the number of susceptible, infectious, and recovered individuals, respectively.

The parameter model is:
$$
\begin{align}
\lambda &= 10 \\\\
\delta &\sim \mathrm{Beta}(2,2) \\\\
\gamma &\sim \mathrm{Beta}(2,2),
\end{align}
$$
where $\lambda$ is a rate of interaction in the population, $\delta$ the probability of infection when a susceptible individual interacts with an infectious individual, and $\gamma$ the daily recovery probability.

The initial model for time $t = 0$ depends on the data set. For the data set introduced below, it is as follows:
$$
\begin{align}
s_0 &= 760 \\\\
i_0 &= 3 \\\\
r_0 &= 0.
\end{align}
$$
The transition model for time $t$ is:
$$
\begin{align}
\tau_t \mid s_{t-1}, i_{t-1}, r_{t-1}, \lambda &\sim \mathrm{Binomial}\left(s_{t-1}, 1 - \exp\left(\frac{-\lambda i_{t-1} }{s_{t-1} + i_{t-1} + r_{t-1}}\right) \right) \\\\
\Delta i_t \mid \tau_t, \delta &\sim \mathrm{Binomial}(\tau_t, \delta) \\\\
\Delta r_t \mid i_{t-1}, \gamma &\sim \mathrm{Binomial}(i_{t-1}, \gamma),
\end{align}
$$
where $\tau_t$ is the number of interactions between infectious and susceptible individuals, $\Delta i_t$ the number of newly infectious individuals, and $\Delta r_t$ the number of newly recovered individuals. Population counts are then updated:
$$
\begin{align}
s_t &= s_{t-1} - \Delta i_t \\\\
i_t &= i_{t-1} + \Delta i_t - \Delta r_t \\\\
r_t &= r_{t-1} + \Delta r_t.
\end{align}
$$

## Implementation

We again create a class that inherits from `Model`, but this time use some additional features. In the [previous example](/getting-started/linear-regression) we overrode the member functions `simulate()`, `read(buffer:Buffer)` and `write(buffer:Buffer)`. In this example, we will also override the `simulate(t:Integer)`, `read(t:Integer, buffer:Buffer)` and `write(t:Integer, buffer:Buffer)` functions. These allow sequential execution of the model in steps, indexed by the integer `t`. Often `t` indexes time (as will be the case here), but it need not: in general it can index any dimension along which a model can be expressed sequentially. For example, `t` may simply index observations. Structuring the implementation this way allows Sequential Monte Carlo (SMC) to be used for inference, with resampling performed between steps.

!!! tip
    When overriding a member function, the types of the parameters must stay the same, but their names may change. This means that you can rename `t` to something else if you prefer, but it must have type `Integer`.

We will use the `simulate()` function to implement the parameter model, and the `simulate(t:Integer)` function to implement the initial and transition models.

Create a file `src/SIRMode.birch` with the following:

```birch
/**
 * SIR (susceptible-infectious-recovered) model.
 */
class SIRModel < Model {
  /**
   * Interaction rate.
   */
  λ:Random<Real>;

  /**
   * Infection probability.
   */
  δ:Random<Real>;

  /**
   * Recovery probability.
   */
  γ:Random<Real>;

  /**
   * Susceptible population at each time.
   */
  s:Tape<Random<Integer>>;

  /**
   * Infectious population at each time.
   */
  i:Tape<Random<Integer>>;

  /**
   * Recovered population at each time.
   */
  r:Tape<Random<Integer>>;

  override function simulate() {
    λ ~ Gamma(2.0, 5.0);
    δ ~ Beta(2.0, 2.0);
    γ ~ Beta(2.0, 2.0);
  }

  override function simulate(t:Integer) {
    if t == 1 {
      // the initial state is set in the input file
    } else {
      let n <- s[t - 1] + i[t - 1] + r[t - 1];  // total population
      let τ ~ Binomial(s[t - 1], 1.0 - exp(-λ*i[t - 1]/n));
      let Δi ~ Binomial(τ, δ);
      let Δr ~ Binomial(i[t - 1], γ);

      s[t] ~ Delta(s[t - 1] - Δi);
      i[t] ~ Delta(i[t - 1] + Δi - Δr);
      r[t] ~ Delta(r[t - 1] + Δr);
    }
  }

  override function read(buffer:Buffer) {
    λ <-? buffer.get<Real>("λ");
    δ <-? buffer.get<Real>("δ");
    γ <-? buffer.get<Real>("γ");
  }

  override function read(t:Integer, buffer:Buffer) {
    s[t] <-? buffer.get<Integer>("s");
    i[t] <-? buffer.get<Integer>("i");
    r[t] <-? buffer.get<Integer>("r");
  }

  override function write(buffer:Buffer) {
    buffer.set("λ", λ);
    buffer.set("δ", δ);
    buffer.set("γ", γ);
  }

  override function write(t:Integer, buffer:Buffer) {
    buffer.set("s", s[t]);
    buffer.set("i", i[t]);
    buffer.set("r", r[t]);
  }
}
```

This code introduces a few new features:

* The state histories `s`, `i` and `r` are stored in a container called [Tape](https://docs.birch.sh/libraries/Standard/classes/Tape/). This is a recursive data structure that works much like a list. It is commonly used for storing state histories as it works nicely with Birch's dynamic memory management, allowing objects to be shared between multiple instances of a model so as to significantly reduce memory use[^3].
* The variables `n`, `τ`, `Δi` and `Δr` are declared as local variables in the `simulate(t:Integer)` function rather than as member variables of the `SIRModel` class. This choice is made because we do not intend to read them from a file, or write them to a file, so only need to keep them temporarily.

The transition model associates `s`, `i` and `r` with [Delta](https://docs.birch.sh/libraries/Standard/classes/Delta/) distributions rather than simply assigning to them. The `Delta` distribution is just a degenerate distribution on a single integer value. We might instead want to write:

```birch
s[t] <- s[t - 1] - Δi;
i[t] <- i[t - 1] + Δi - Δr;
r[t] <- r[t - 1] + Δr;
```

However, the use of the `Delta` distribution allows Birch to enumerate sums and differences of discrete-valued random variables and perform automatic marginalization and conditioning. In particular, we will observe `i[t]` here, and Birch will be able to enumerate the conditional distribution of `Δi` and `Δr` given `i[t]` and `i[t - 1]`. This is a nice analytical optimization for this particular model.

## Data

We will use a classic data set of the outbreak of influenza at a boarding school in northern England[^1]. [Download the data set](/getting-started/influenza.json) to the `input/` directory.

Have a look at the contents of the file (`cat input/influenza.json`). At the root level it contains an array. The first element of that array provides an entry with key `λ` and value `10`. This first element is read by the `read(buffer:Buffer)` member function of our model. The remaining elements provide an entry `i` with various values. These elements are read by the `read(t:Integer, buffer:Buffer)` member function prior to the the `t`th time step being executed by `simulate(t:Integer)`. In particular the second entry, corresponding to `t == 1`, sets the initial value of all state variables.

!!! tip
    If we wanted, we could also specify values for `s` and/or `r` in the input file for other times. We have set up `read(t:Integer, buffer:Buffer)` to support this. Recall that the `<-?` operator will only assign a value to the left if the key is found in the file. So if we provide these values, the model acts as though they are observed, if we do not provide them, the model acts as though they are latent.

## Inference

Birch's inference engine is based on SMC with several variants and configurable components, as well as automatic marginalization, automatic conjugacy, and automatic differentiation. For this model, the delayed sampling[^2] mechanism will find some analytical optimizations and apply them. These include marginalizing out the parameters $\delta$ and $\gamma$, as they form conjugate beta-binomial relationships with state variables, as well as enumerating sums and differences of discrete variables.

The previous linear regression example was simple enough that no configuration was required. Here we need to change a few options. A configuration file is used for this purpose.

Create a file `config/sir.json` and enter the following contents:

```json
{
  "model": {
    "class": "SIRModel"
  },
  "sampler": {
    "class": "ParticleSampler",
    "nsamples": 10
  },
  "filter": {
    "class": "ParticleFilter",
    "nparticles": 128
  },
  "input": "input/influenza.json",
  "output": "output/sir.json"
}
```

This sets the number of posterior samples to draw (`sampler.nsamples`) and the number of particles used by SMC when drawing each (`filter.nparticles`). It also sets the model class (`model.class`), input file (`input`), and output file (`output`), which we provided on the command line instead in the linear regression example (it is preferable to provide these in the configuration file instead, for reproducibility).

!!! tip
    Any of these JSON files can be written in [YAML](https://yaml.org/) if you prefer.

Build the package:

    birch build

then sample from the posterior distribution with:

    birch sample --config config/sir.json

As before, you can inspect the results of the inference in `output/sir.json`, in a text editor, web browser, or on the command line (`less output/sir.json`). The output here is an importance sample: each sample is assigned a weight, the logarithm of which is given by the associated `lweight` element.

!!! tip
    A future tutorial will outline how to configure the inference method, but as a starting point, you can set various options in the `sampler` and/or `filter` sections of the `config/sir.json` file.

[^1]: Anonymous (1978). Influenza in a boarding school. *British Medical Journal*. **1**:587.

[^2]: L.M. Murray, D. Lundén, J. Kudlicka, D. Broman and T.B. Schön (2018). [Delayed Sampling and Automatic Rao&ndash;Blackwellization of Probabilistic Programs](https://arxiv.org/abs/1708.07787). In *Proceedings of the 21st International Conference on Artificial Intelligence and Statistics (AISTATS) 2018*, Lanzarote, Spain.

[^3]: L.M. Murray (2020). [Lazy object copy as a platform for population-based probabilistic programming](https://arxiv.org/abs/2001.05293).
