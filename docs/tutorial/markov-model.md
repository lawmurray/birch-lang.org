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
    Create a file `bi/SIRModel.bi`, add it to `META.json`.

[MarkovModel](/documentation/library/classes/MarkovModel) is a [*generic*](/documentation/language/classes/#generic-parameters) class. It requires two other classes, one to contain the parameters of the model, and one to contain the state variables of the model. We will create these classes first, to be called `SIRParameter` and `SIRState`, respectively. We will then specify the parameter, initial and transition models in a class `SIRModel`, to inherit from `MarkovModel<SIRParameter,SIRState>`.

We will start with the `SIRParameter` class.

!!! example "Exercise"
    Add the following code to the file `bi/SIRModel.bi`:

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

This just groups all the parameters into one class, and overrides the standard `read` and `write` member functions.

The `SIRState` class is similar.

!!! example "Exercise"
    Add the following code to the file `bi/SIRModel.bi`:

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

This just groups all the state variables into one class, and overrides the standard `read` and `write` member functions. Note that it represents a *single* state of the model. The `MarkovModel` class will handle state trajectories for us.

Finally, we create the class `SIRModel`, where most of the work happens. This inherits from `MarkovModel<SIRParameter,SIRState>`. It must implement member fibers `parameter`, `initial` and `transition` to specify the Markov model.

!!! example "Exercise"
    Add the following code to the file `bi/SIRModel.bi`:

        /**
         * SIR model.
         */
        class SIRModel < MarkovModel<SIRParameter,SIRState> {
          fiber parameter(θ:SIRParameter) -> Event {
            θ.λ ~ Gamma(2.0, 5.0);
            θ.δ ~ Beta(2.0, 2.0);
            θ.γ ~ Beta(2.0, 2.0);
          }

          fiber initial(x:SIRState, θ:SIRParameter) -> Event {
            //
          }

          fiber transition(x':SIRState, x:SIRState, θ:SIRParameter) -> Event {
            x'.τ ~ Binomial(x.s, 1.0 - exp(-θ.λ*x.i/(x.s + x.i + x.r)));
            x'.Δi ~ Binomial(x'.τ, θ.δ);
            x'.Δr ~ Binomial(x.i, θ.γ);

            x'.s ~ Delta(x.s - x'.Δi);
            x'.i ~ Delta(x.i + x'.Δi - x'.Δr);
            x'.r ~ Delta(x.r + x'.Δr);
          }
        }

Notice the three member fibers in the above code:

    fiber parameter(θ:SIRParameter) -> Event;
    fiber initial(x:SIRState, θ:SIRParameter) -> Event;
    fiber transition(x':SIRState, x:SIRState, θ:SIRParameter) -> Event;

As suggested by their names and parameters:

  * the first is for the parameter model, providing the parameters as the `θ` argument,
  * the second is for the initial model, providing the initial state as the `x` argument, and parameters as the `θ` argument,
  * the third is for the transition model, providing the current state as the `x'` argument, the previous state as the `x` argument, and the parameters as the `θ` argument.

!!! tip
    Here, `x'` is just the name of a variable. The prime `'` is a valid character for variable names in Birch, useful where it might also be used in mathematics.

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

We are nearly ready to perform inference. Unlike the [linear regression](/documentation/tutorial/linear-regression) example, there is no exact analytical solution for this model that can be computed in reasonable time. A particle filter will be used for inference instead. Nevertheless, the delayed sampling[^2] heuristic in Birch will find some local analytical optimizations and automatically apply them. These include marginalizing out the parameters $\delta$ and $\gamma$, and enumerating sums and differences of binomials.

The particle filter requires some configuration. This is provided in a configuration file.

!!! example "Exercise"
    Create a file `config/sir_model.json`, add it to `META.json`, and enter the following contents:

        {
          "sampler": {
            "nsamples": 10,
            "nparticles": 128
          }
        }

This simply sets the number of posterior samples to draw, and the number of particles to use when running the particle filter.

Now we can perform inference.

!!! example "Exercise"
    Sample from the posterior distribution with

        birch sample \
          --model SIRModel \
          --config config/sir_model.json \
          --input input/russian_influenza.json \
          --output output/sir_model.json

As before, you can inspect the results of the inference in `output/sir_model.json`, and perhaps plot them. Be aware that the output here is an *importance sample*. Each sample is assigned a weight, the logarithm of which is given by the associated `lweight` element in the output file.

[^1]: Anonymous (1978). Influenza in a boarding school. *British Medical Journal*. **1**:587.

[^2]: L.M. Murray, D. Lundén, J. Kudlicka, D. Broman and T.B. Schön (2018). [Delayed Sampling and Automatic Rao&ndash;Blackwellization of Probabilistic Programs](https://arxiv.org/abs/1708.07787). In *Proceedings of the 21st International Conference on Artificial Intelligence and Statistics (AISTATS) 2018*, Lanzarote, Spain.
