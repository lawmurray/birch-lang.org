# Next steps

This concludes the tutorial.

The [language](/documentation/language) documentation is a good next step to learn more about the Birch language. Perusing the [standard library](/documentation/library) documentation will also give you a better idea of the features available, such as supported probability distributions.

For further reading on the design philosophy behind Birch, see:

  * L.M. Murray and T.B. Schön (2018). [Automated learning with a probabilistic programming language: Birch](https://dx.doi.org/10.1016/j.arcontrol.2018.10.013). *Annual Reviews in Control* **46**:29--43. [[arxiv]](https://arxiv.org/abs/1810.01539)

For details of the delayed sampling heuristic that forms an important part of Birch, see:

   * L.M. Murray, D. Lundén, J. Kudlicka, D. Broman and T.B. Schön (2018). [Delayed Sampling and Automatic Rao&ndash;Blackwellization of Probabilistic Programs](https://arxiv.org/abs/1708.07787). *Proceedings of the 21st International Conference on Artificial Intelligence and Statistics (AISTATS)*.

For further examples, see:

  * [Birch.Example](https://github.com/lawmurray/Birch.Example) for simple examples, including those in this tutorial.

  * [VectorBorneDisease](https://github.com/lawmurray/VectorBorneDisease) for some simple epidemiological models assembled from multiple classes.

  * [MultiObjectTracking](https://github.com/lawmurray/MultiObjectTracking) for a multiple object tracking example. This is particularly interesting to motivate universal probabilistic programming, as the model does not have fixed dimension (the number of objects is unknown), and the inference method consists of multiple Kalman filters nested within a single particle filter. Further details are in the paper Murray & Schön (2018) above.
