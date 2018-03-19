We will now look at implementing a [Markov model](https://en.wikipedia.org/wiki/Markov_model), specifically a simple SIR (susceptible-infectious-recovered) compartmental model for an influenza epidemic, using a classic data set of an outbreak of Russian influenza in a boarding school.

## Model

The model is described in three parts: the *parameter* model, the *initial* model, and the *transition* model.

### Parameter model

The parameter model is:
$$\begin{align}
\lambda &= 10 \\
\delta &\sim \mathrm{Beta}(2,2) \\
\gamma &\sim \mathrm{Beta}(2,2),
\end{align}$$
where $\lambda$ is a rate of interaction in the population, $\delta$ the probability of infection when a susceptible individual interacts with an infectious individual, and $\gamma$ the recovery probability.

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
\tau_t &\sim \mathrm{Binomial}\left(s_{t-1}, 1 - \exp\left(-\lambda i_{t-1} / n\right) \right) \\
\Delta i_t &\sim \mathrm{Binomial}(\tau_t, \delta) \\
\Delta r_t &\sim \mathrm{Binomial}(i_{t-1}, \gamma),
\end{align}$$
where $\tau_t$ is the number of interactions between infectious and susceptible individuals at time $t$, $n$ the total population (conserved throughout), $\Delta i_t$ the number of newly infected individuals, and $\Delta r$ the number of newly recovered individuals. Population counts are then updated in three compartments:
$$\begin{align}
s_t &= s_{t-1} - \Delta i_t \\
i_t &= i_{t-1} + \Delta i_t - \Delta r_t \\
r_t &= r_{t-1} + \Delta r_t
\end{align}$$
where $s_t$ denotes the number of individuals in the susceptible compartment, $i_t$ in the infectious compartment, and $r_t$ in the recovered compartment. The sum of these is always $n$, the total population.

## Implementation

To specify this model in Birch, we again need to create a class that inherits from [Model](/documentation/library/classes/Model). This time, however, the standard library provides the more-specific class [MarkovModel](/documentation/library/classes/MarkovModel) that we can use. [MarkovModel](/documentation/library/classes/MarkovModel) inherits from [Model](/documentation/library/classes/Model) already, and handles some of the boilerplate of managing multiple states in a standard way. We just need to provide specific implementations of the parameter, initial and transition models.

As well as easing implementation, the other advantage of [MarkovModel](/documentation/library/classes/MarkovModel) is that it reveals something about the structure of the model, which may be useful to enable, or optimize, specific inference methods. It is expected that more classes for specific model structures, and more methods to exploit them, will be available in future.
    
!!! example "Exercise"
    Create a file `bi/SIRModel.bi`, add it to `META.json`, and enter the following:

        /**
         * SIR (susceptible-infectious-recovered) model.
         */
        class SIRModel = MarkovModel<SIRState,SIRParameter>;

[MarkovModel](/documentation/library/classes/MarkovModel) is a *generic* class. It takes the name of two other classes between the angle brackets---in this case `SIRState` and `SIRParameter` that it will use internally. We will create these classes below. Otherwise, this code is just establishing the name `SIRModel` as an alias for `MarkovModel<SIRState,SIRParameter>`: two names for the same thing.

We will start with the `SIRParameter` class. This is the parameter model. It must itself inherit from the `Model` class.

!!! example "Exercise"
    Create a file `bi/SIRParameter.bi`, add it to `META.json`, and enter the following:

        /**
         * SIR model parameters.
         */
        class SIRParameter < Model {
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
      
          fiber simulate() -> Real! {
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

Recall the typical structure of this class from the [Bayesian linear regression](/tutorial/bayesian-linear-regresssion) example: random variables and member variables, the `simulate` fiber, the `input` and `output` function.

The `SIRState` class must inherit from [State](/documentation/library/classes/State). The [State](/documentation/library/classes/State) class is very similar to the [Model](/documentation/library/classes/Model) class in fact, but it splits the `simulate` fiber into two separate fibers: one for the initial model, and one for the transition model.

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
  
          fiber simulate(θ:SIRParameter) -> Real! {
            //
          }
  
          fiber simulate(x:SIRState, θ:SIRParameter) -> Real! {
            τ ~ Binomial(x.s, 1.0 - exp(-θ.λ*x.i/(x.s + x.i + x.r)));
            Δi ~ Binomial(τ, θ.δ);
            Δr ~ Binomial(x.i, θ.γ);

            i ~ Delta(x.i + Δi - Δr);
            s ~ Delta(x.s - Δi);
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

There are two different `simulate` fibers in the above code:

    fiber simulate(θ:SIRParameter) -> Real!;
    fiber simulate(x:SIRState, θ:SIRParameter) -> Real!;

As suggested by their parameters:

  * the first is for the initial model, providing the parameters as `θ`,
  * the second is for the transition model, providing the previous state as `x` and the parameters as `θ`.

The initial model is empty by choice here. While we could implement the initial model described above, it is specific to the data set that we will use, and we would prefer not to hardcode it, in order that we might reuse the model for other data sets. Instead, we have elected to include the initial state in the input file that we will set up below.

## Data

We will use a data set of the outbreak of Russian influenze in a boy's boarding school in northern England[^1].

!!! example "Exercise"
    Download the data set [here](/tutorial/russian_influenza.json) and place it in your project's `input/` directory as `input/russian_influenza.json`. Also add the file to `META.json` under `manifest.data`.

Have a look at the contents of the file in a text editor. It contains an array of states. The first state sets values of all relevant state variable to initialize, and henceforth only the total infectious population, $i_t$, is observed.


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

The new command-line option  `--ncheckpoints` gives the number of *checkpoints* for which to run. In the case of a model that inherits from [Markov model](https://en.wikipedia.org/wiki/Markov_model), as here, this is the number of states. In general, it is the number of observations. The numbers output to the terminal are appear each time the inference method progresses to the next checkpoint.

Unlike the [previous example](/documentation/tutorial/linear-regression), there is not an exact analytical solution for this model. By default, a particle filter is used for inference. The new command-line option `--nparticles` gives the number of particles to use in the particle filter.

One of the difficulties with this model is that the infectious population, $i_t$, is observed directly, without additional observation noise. There is positive probability that amongst all particles, not a single one arrives at the exact value required for $i_t$. This is referred to as *degeneracy*, and accounts for the error message that you have (probably) just seen.

One fix is to increase the number of particles. Changing `--nparticles 100` in the above to `--nparticles 1000` seems sufficient.

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

Incidentally, it will be obvious from the output on the terminal where the problem is. The 13th observation has low incremental likelihood, and requires many more attempts before 100 particles are accepted.

[^1]: Anonymous (1978). Influenza in a boarding school. *British Medical Journal*. **1**:587.

[^2]: A. Jasra, A. Lee, C. Yau, & X. Zhang (2013). [The Alive Particle Filter](http://arxiv.org/abs/1304.0151).

