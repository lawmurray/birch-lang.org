# Probabilistic inference

Before concluding we provide a brief sketch of probabilistic inference in Birch.

!!! note
    This section will be expanded in future.

Inference methods include those of the [ParticleFilter](https://birch-docs.indii.org/libraries/Standard/classes/ParticleFilter) class hierarchy, for sequentially filtering a model, and of the [ParticleSampler](https://birch-docs.indii.org/libraries/Standard/classes/ParticleSampler) class hierarchy, which build on these to draw samples from the posterior distribution.

As a model runs it emits an event every time a simulate (`<~`), observe (`~>`) or assume (`~`) operator executes. The inference method registers an appropriate event handler (from the [Handler](https://birch-docs.indii.org/libraries/Standard/classes/Handler) hierarchy) to handle these. The events provide insight into the model, and a means to influence its execution. The inference method may, for example, implement:

* *Importance sampling* by using a combination of simulation and observation to compute importance weights.

* *Particle filtering* or *Sequential Monte Carlo* by extending importance sampling with resampling between epochs.

* *Particle Gibbs*.
