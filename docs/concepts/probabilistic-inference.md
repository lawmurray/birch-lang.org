# Probabilistic inference

In this section we provide a brief sketch of probabilistic inference in Birch.

Inference methods include those of the [ParticleFilter](https://docs.birch.sh/libraries/Standard/classes/ParticleFilter) class hierarchy, for sequentially filtering a model, and of the [ParticleSampler](https://docs.birch.sh/libraries/Standard/classes/ParticleSampler) class hierarchy, which build on these to draw samples from the posterior distribution.

The chosen inference method will use an appropriate [Handler](https://docs.birch.sh/libraries/Standard/classes/Handler) to handle the events emitted from the running model. These events allow insight into the model, but also a means to influence its execution. Indeed, it is the inference method that provides the actual interpretation of the probabilistic operators `<~`, `~>` and `~`. It may interpret these operators to achieve algorithms such as:

* *Importance sampling* by using a combination of simulation and observation to compute importance weights.

* *Particle filtering* or *Sequential Monte Carlo* by extending importance sampling with resampling between epochs. Additionally, automatic marginalization and automatic conjugacy provide for Rao--Blackwellization and adaptation in the sense of the auxiliary particle filter. Automatic differentiation provides for gradient-based Markov kernels for use with resample-move strategies.

* *Particle Gibbs*, with or without marginalization of parameters.
