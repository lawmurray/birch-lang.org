We will now look at implementing a [Markov model](https://en.wikipedia.org/wiki/Markov_model), specifically a simple SIR (susceptible-infectious-recovered) compartmental model for an influenza epidemic, using a classic data set of an outbreak of Russian influenza at a boarding school.

## Model

The model is described in three parts: a *parameter* model, an *initial* model, and a *transition* model. Time is indexed by $t$, in days. The state consists of variables $s_t$, $i_t$, and $r_t$, giving counts of the number of susceptible, infectious, and recovered individuals, respectively.

### Parameter model

The parameter model is:
$$\begin{align}
\lambda &= 10 \\
\delta &\sim \mathrm{Beta}(2,2) \\
\gamma &\sim \mathrm{Beta}(2,2),
\end{align}$$
where $\lambda$ is a rate of interaction in the population, $\delta$ the probability of infection when a susceptible individual interacts with an infectious individual, and $\gamma$ the daily recovery probability.

### Initial model

The initial model for time $t = 0$ depends on the data set. For the data set introduced below, it is as follows:
$$\begin{align}
s_0 &= 760 \\
i_0 &= 3 \\
r_0 &= 0.
\end{align}$$

### Transition model

The transition model for time $t$ is:
$$\begin{align}
\tau_t &\sim \mathrm{Binomial}\left(s_{t-1}, 1 - \exp\left(\frac{-\lambda i_{t-1} }{s_{t-1} + i_{t-1} + r_{t-1}}\right) \right) \\
\Delta i_t &\sim \mathrm{Binomial}(\tau_t, \delta) \\
\Delta r_t &\sim \mathrm{Binomial}(i_{t-1}, \gamma),
\end{align}$$
where $\tau_t$ is the number of interactions between infectious and susceptible individuals, $\Delta i_t$ the number of newly infected individuals, and $\Delta r_t$ the number of newly recovered individuals. Population counts are then updated:
$$\begin{align}
s_t &= s_{t-1} - \Delta i_t \\
i_t &= i_{t-1} + \Delta i_t - \Delta r_t \\
r_t &= r_{t-1} + \Delta r_t.
\end{align}$$

## Implementation

To specify this model in Birch, we again need to create a class that inherits from [Model](/documentation/library/classes/Model). This time, however, the standard library provides the more-specific class [MarkovModel](/documentation/library/classes/MarkovModel) that will do some of the work for us. [MarkovModel](/documentation/library/classes/MarkovModel) itself inherits from [Model](/documentation/library/classes/Model), we just need to provide it with specific implementations of the parameter, initial and transition models.

As well as easing implementation, the other advantage of [MarkovModel](/documentation/library/classes/MarkovModel) is that it reveals something about the structure of the model, which may be useful to enable, or optimize, specific inference methods. It is expected that more classes for specific model structures, and more methods to make use of them, will be available in future.

!!! example "Exercise"
    Create a file `bi/SIRModel.bi`, add it to `META.json`, and enter the following:

        /**
         * SIR (susceptible-infectious-recovered) model.
         */
        class SIRModel = MarkovModel<SIRState,SIRParameter>;

[MarkovModel](/documentation/library/classes/MarkovModel) is a *generic* class. It takes the name of two other classes between the angle brackets&mdash;in this case `SIRState` and `SIRParameter`&mdash;which it uses internally. We will create these classes below. Otherwise, this code is just establishing the name `SIRModel` as an alias for `MarkovModel<SIRState,SIRParameter>`: two names for the same type.

We will start with the `SIRParameter` class. This is the parameter model. It must inherit from [Parameter](/documentation/library/classes/Parameter). The [Parameter](/documentation/library/classes/Parameter) class is very similar to the [Model](/documentation/library/classes/Model) class, but it provides a `parameter` member fiber that must be overriden to define the parameter model.


!!! example "Exercise"
    Create a file `bi/SIRParameter.bi`, add it to `META.json`, and enter the following:

        /**
         * SIR model parameters.
         */
        class SIRParameter < Parameter {
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

          fiber parameter() -> Real {
            λ <- 10.0;
            δ ~ Beta(2.0, 2.0);
            γ ~ Beta(2.0, 2.0);
          }

          function input(reader:Reader) {
            λ <- reader.getReal("λ");
            δ <- reader.getReal("δ");
            γ <- reader.getReal("γ");
          }

          function output(writer:Writer) {
            writer.setReal("λ", λ);
            writer.setReal("δ", δ);
            writer.setReal("γ", γ);
          }
        }

Recall the typical structure of this class from the [Bayesian linear regression](/tutorial/bayesian-linear-regresssion) example: random variables as member variables, the `simulate` member fiber, the `input` and `output` member functions.

The `SIRState` class must inherit from [State](/documentation/library/classes/State). The [State](/documentation/library/classes/State) class is very similar to the [Model](/documentation/library/classes/Model) class, but it provides two separate member fibers `initial` and `transition` that must be overridden to define the initial and transition models, respectively.

!!! example "Exercise"
    Create a file `bi/SIRState.bi`, add it to `META.json`, and enter the following:

        /**
         * SIR model state.
         */
        class SIRState < State {
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

          fiber initial(θ:SIRParameter) -> Real {
            //
          }

          fiber transition(x:SIRState, θ:SIRParameter) -> Real {
            τ ~ Binomial(x.s, 1.0 - exp(-θ.λ*x.i/(x.s + x.i + x.r)));
            Δi ~ Binomial(τ, θ.δ);
            Δr ~ Binomial(x.i, θ.γ);

            s ~ Delta(x.s - Δi);
            i ~ Delta(x.i + Δi - Δr);
            r ~ Delta(x.r + Δr);
          }

          function input(reader:Reader) {
            Δi <- reader.getInteger("Δi");
            Δr <- reader.getInteger("Δr");
            s <- reader.getInteger("s");
            i <- reader.getInteger("i");
            r <- reader.getInteger("r");
          }

          function output(writer:Writer) {
            writer.setInteger("Δi", Δi);
            writer.setInteger("Δr", Δr);
            writer.setInteger("s", s);
            writer.setInteger("i", i);
            writer.setInteger("r", r);
          }
        }

Notice the two member fibers in the above code:

    fiber initial(θ:SIRParameter) -> Real;
    fiber transition(x:SIRState, θ:SIRParameter) -> Real;

As suggested by their names and parameters:

  * the first is for the initial model, providing the parameters as the `θ` argument,
  * the second is for the transition model, providing both the previous state as the `x` argument and the parameters as the `θ` argument.

The initial model is empty by choice. While we could implement the initial model described above, it is specific to the data set that we will use. We would prefer not to hardcode it, in order that we might reuse this model for other data sets. Instead, we have elected to include the initial state in the input file that we will set up below.

The transition model uses [Delta](/documentation/library/classes/Delta/) distributions rather than simple assignment statements. This is because we have declared the variables `s`, `i` and `r` to be of type `Random<Integer>`, not just `Integer`. Using the [Delta](/documentation/library/classes/Delta/) distributions ensures proper handling of the two possible situations for each variable: that it already has a value&mdash;in which case we observe that value&mdash;or that its value is missing&mdash;in which case we simulate it. Indeed, the code, as written, handles all cases, according to what is provided in the input file.

!!! example "Exercise"
    Build the project with

        birch build

## Data

We will use a data set of the outbreak of Russian influenza at a boy's boarding school in northern England[^1].

!!! example "Exercise"
    Download the data set [here](/tutorial/russian_influenza.json) and place it in your project's `input/` directory as `input/russian_influenza.json`.

    Add the file to `META.json` under `manifest.data`.

Have a look at the contents of the file in a text editor. It contains an array of states. The first state sets the values of all state variables, while for subsequent states it sets only $i_t$, the number of infectious individuals.


## Inference

We can now run the model.

!!! example "Exercise"
    Sample from the posterior distribution with

        birch sample \
          --model SIRModel \
          --input-file input/russian_influenza.json \
          --output-file output/russian_influenza.json \
          --ncheckpoints 14 \
          --nparticles 100 \
          --nsamples 10

!!! error
    With high probability, you will get an error message `particle filter degenerated` at this point. This is expected.

The new command-line option  `--ncheckpoints` gives the number of *checkpoints* for which to run. In the case of a model that inherits from [MarkovModel](/documentation/library/classes/MarkovModel), as here, this is interpreted as the number of states. In general, it is interpreted as the number of observations. The numbers that appear in the terminal are simply ticking off these checkpoints as the sampler proceeds.

Unlike the [previous example](/documentation/tutorial/linear-regression), there is no exact analytical solution for this model that can be computed in reasonable time. A particle filter is used for inference instead. The new command-line option `--nparticles` gives the number of particles to use in the particle filter.

One of the difficulties with this model is that the infectious population, $i_t$, is observed directly, without additional observation noise. There is positive probability that amongst all particles at time $t - 1$, not a single one arrives at the exact value required for $i_t$ at time $t$. This is referred to as *degeneracy*, and accounts for the error message that you have (probably) just seen.

One fix is to increase the number of particles. Changing `--nparticles 100` in the above to `--nparticles 1000` is adequate.

Another fix is to change the method. There are not so many methods available in Birch right now, but there is the alive particle filter[^2], which is useful in situations such as this. The alive particle filter will continue sampling at each time step until it has `--nparticles` number of particles with non-zero weights. To use it, add `--method AliveParticleFilter` to the command.

!!! example "Exercise"
    Sample from the posterior distribution using the alive particle filter, with the following command:

        birch sample \
          --model SIRModel \
          --input-file input/russian_influenza.json \
          --output-file output/russian_influenza.json \
          --ncheckpoints 14 \
          --nparticles 100 \
          --nsamples 10 \
          --method AliveParticleFilter

You will probably notice the particle filter stays at checkpoint 13 for longer than the others. This reveals the issue: the observation at checkpoint 13 has low incremental likelihood, and the alive particle filter makes many more proposals before accepting the 100 particles required.

More inference methods will be added in future, and will be selectable with the `--method` option.

As before, you can inspect the results of the inference in `output/russian_influenza.json`, and perhaps plot them in a package such as MATLAB, R, or Julia. Be aware that the output here is an *importance sample*. Each sample is assigned a weight, the logarithm of which is given by the associated *weight* element in the output file.

[^1]: Anonymous (1978). Influenza in a boarding school. *British Medical Journal*. **1**:587.

[^2]: A. Jasra, A. Lee, C. Yau, & X. Zhang (2013). [The Alive Particle Filter](http://arxiv.org/abs/1304.0151).
