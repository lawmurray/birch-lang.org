# Markov Model

We will now look at implementing a simple SIR (susceptible-infectious-recovered) compartmental model of an epidemic, using a classic data set of an outbreak of influenza at a boarding school.

## Model

The model is described in three parts: a *parameter* model, an *initial* model, and a *transition* model. Time is indexed by $t$, in days. The state consists of variables $s_t$, $i_t$, and $r_t$, giving counts of the number of susceptible, infectious, and recovered individuals, respectively.

The parameter model is:

$$\begin{align}
\lambda &= 10 \\
\delta &\sim \mathrm{Beta}(2,2) \\
\gamma &\sim \mathrm{Beta}(2,2),
\end{align}$$

where $\lambda$ is a rate of interaction in the population, $\delta$ the probability of infection when a susceptible individual interacts with an infectious individual, and $\gamma$ the daily recovery probability.

The initial model for time $t = 0$ depends on the data set. For the data set introduced below, it is as follows:

$$\begin{align}
s_0 &= 760 \\
i_0 &= 3 \\
r_0 &= 0.
\end{align}$$

The transition model for time $t$ is:

$$\begin{align}
\tau_t \mid s_{t-1}, i_{t-1}, r_{t-1}, \lambda &\sim \mathrm{Binomial}\left(s_{t-1}, 1 - \exp\left(\frac{-\lambda i_{t-1} }{s_{t-1} + i_{t-1} + r_{t-1}}\right) \right) \\
\Delta i_t \mid \tau_t, \delta &\sim \mathrm{Binomial}(\tau_t, \delta) \\
\Delta r_t \mid i_{t-1}, \gamma &\sim \mathrm{Binomial}(i_{t-1}, \gamma),
\end{align}$$

where $\tau_t$ is the number of interactions between infectious and susceptible individuals, $\Delta i_t$ the number of newly infectious individuals, and $\Delta r_t$ the number of newly recovered individuals. Population counts are then updated:

$$\begin{align}
s_t &= s_{t-1} - \Delta i_t \\
i_t &= i_{t-1} + \Delta i_t - \Delta r_t \\
r_t &= r_{t-1} + \Delta r_t.
\end{align}$$

## Implementation

We again create a class that inherits from `Model`, but the standard library provides a more specialized class [MarkovModel](https://docs.birch.sh/libraries/Standard/classes/MarkovModel) that can handle some of the work for us here. `MarkovModel` inherits from `Model`. It overrides the `simulate()` member function to call three other member functions that it defines: `parameter()`, `initial()`, and `transition()`, for the three parts of a Markov model. Instead of creating a class that inherits from `Model` directly and overrides `simulate()`, we create a class that inherits from `MarkovModel` and overrides `parameter()`, `initial()` and `transition()`.

Furthermore, `MarkovModel` is a [generic](/language/classes/#generics) class, fully written `MarkovModel<Parameter,State>`. When used it is provided with two other classes as type arguments, one that describes the parameters of the model, and one that describes the state of the model. We create these two classes first.

Create a file `src/SIRParameter.birch` with the following:

    /**
     * SIR model parameters.
     */
    class SIRParameter {
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

      function read(buffer:Buffer) {
        buffer.get("λ", λ);
        buffer.get("δ", δ);
        buffer.get("γ", γ);
      }

      function write(buffer:Buffer) {
        buffer.set("λ", λ);
        buffer.set("δ", δ);
        buffer.set("γ", γ);
      }
    }

Create a file `src/SIRState.birch` with the following:

    /**
     * SIR model state.
     */
    class SIRState {
      /**
       * Number of susceptible-infectious interactions.
       */
      τ:Random<Integer>;

      /**
       * Newly infected population.
       */
      Δi:Random<Integer>;

      /**
       * Newly recovered population.
       */
      Δr:Random<Integer>;

      /**
       * Susceptible population.
       */
      s:Random<Integer>;

      /**
       * Infectious population.
       */
      i:Random<Integer>;

      /**
       * Recovered population.
       */
      r:Random<Integer>;

      function read(buffer:Buffer) {
        buffer.get("Δi", Δi);
        buffer.get("Δr", Δr);
        buffer.get("s", s);
        buffer.get("i", i);
        buffer.get("r", r);
      }

      function write(buffer:Buffer) {
        buffer.set("Δi", Δi);
        buffer.set("Δr", Δr);
        buffer.set("s", s);
        buffer.set("i", i);
        buffer.set("r", r);
      }
    }

Finally, we create the class `SIRModel`, where most of the work happens. This inherits from `MarkovModel<SIRParameter,SIRState>`, specifying the two classes that we have just created as describing the parameters and state of the model.

Create a file `src/SIRModel.bi` with the following

    /**
     * SIR model.
     */
    class SIRModel < MarkovModel<SIRParameter,SIRState> {
      function parameter(θ:SIRParameter) {
        θ.λ ~ Gamma(2.0, 5.0);
        θ.δ ~ Beta(2.0, 2.0);
        θ.γ ~ Beta(2.0, 2.0);
      }

      function initial(x:SIRState, θ:SIRParameter) {
        //
      }

      function transition(x':SIRState, x:SIRState, θ:SIRParameter) {
        x'.τ ~ Binomial(x.s, 1.0 - exp(-θ.λ*Real(x.i)/Real(x.s + x.i + x.r)));
        x'.Δi ~ Binomial(x'.τ, θ.δ);
        x'.Δr ~ Binomial(x.i, θ.γ);

        x'.s ~ Delta(x.s - x'.Δi);
        x'.i ~ Delta(x.i + x'.Δi - x'.Δr);
        x'.r ~ Delta(x.r + x'.Δr);
      }
    }

Notice the three member functions in the above code:

    function parameter(θ:SIRParameter);
    function initial(x:SIRState, θ:SIRParameter);
    function transition(x':SIRState, x:SIRState, θ:SIRParameter);

As suggested by their names and parameters:

  * the first is for the parameter model, providing the parameters as the `θ` argument,
  * the second is for the initial model, providing the initial state as the `x` argument, and parameters as the `θ` argument,
  * the third is for the transition model, providing the current state as the `x'` argument, the previous state as the `x` argument, and the parameters as the `θ` argument.

Here, `x'` is just the name of a variable. The prime `'` is a valid character for variable names in Birch, useful where it is also useful in mathematics.

The initial model is empty by choice. While we could implement the initial model described above, it is specific to the data set that we will use. We would prefer not to hardcode it, in order that we might reuse this model for other data sets in future. We will provide the initial state in an input file, set up below.

The `Real(x.i)` and `Real(x.s + x.i + x.r)` cast the `Integer` expressions to `Real` expressions.

The transition model uses [Delta](https://docs.birch.sh/libraries/Standard/classes/Delta/) distributions rather than simple assignment statements. This is because we have declared the member variables `s`, `i` and `r` as randoms, of type `Random<Integer>`, not just values, of type `Integer`. Using randoms facilitates some analytical optimizations here.

## Data

We will use a classic data set of the outbreak of influenza at a boarding school in northern England[^1]. [Download the data set](/getting-started/influenza.json) to the `input/` directory.

Have a look at the contents of the file (`cat input/influenza.json`). It contains:

  * An object `θ` that fixes the value of $\lambda$ to 10.
  * An array `x` that fixes the initial value of all state variables, then only the value of $i_t$ for subsequent elements.

## Inference

Birch's inference engine is based on Sequential Monte Carlo (SMC) with several variants and configurable components, as well as automatic marginalization, automatic conjugacy, and automatic differentiation. For this model, the delayed sampling[^2] mechanism will find some analytical optimizations and apply them. These include marginalizing out the parameters $\delta$ and $\gamma$, as they form conjugate beta-binomial relationships with state variables, as well as enumerating sums and differences of discrete variables.

The previous linear regression example was simple enough that no configuration was required. Here we need to change a few options. A configuration file is used for this purpose.

Create a file `config/sir.json` and enter the following contents:

    {
      "model": {
        "class": "SIRModel"
      },
      "sampler": {
        "nsamples": 10
      },
      "filter": {
        "nparticles": 128
      },
      "input": "input/influenza.json",
      "output": "output/sir.json"
    }

This sets the number of posterior samples to draw (`sampler.nsamples`) and the number of particles used by SMC when drawing each (`filter.nparticles`). It also sets the model class (`model.class`), input file (`input`), and output file (`output`), which we provided on the command line instead in the linear regression example (it preferable to provide these in the configuration file instead).

!!! tip
    Any of these JSON files can be written in [YAML](https://yaml.org/) if you prefer.

Build the package:

    birch build

then sample from the posterior distribution with:

    birch sample --config config/sir.json

As before, you can inspect the results of the inference in `output/sir.json`, in a text editor, web browser, or on the command line (`less output/sir.json`). The output here is an importance sample: each sample is assigned a weight, the logarithm of which is given by the associated `lweight` element.

[^1]: Anonymous (1978). Influenza in a boarding school. *British Medical Journal*. **1**:587.

[^2]: L.M. Murray, D. Lundén, J. Kudlicka, D. Broman and T.B. Schön (2018). [Delayed Sampling and Automatic Rao&ndash;Blackwellization of Probabilistic Programs](https://arxiv.org/abs/1708.07787). In *Proceedings of the 21st International Conference on Artificial Intelligence and Statistics (AISTATS) 2018*, Lanzarote, Spain.
