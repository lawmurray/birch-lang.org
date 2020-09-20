Now that we have a trivial model running, we can do something more interesting. We will start with a simple example of [Bayesian linear regression](http://en.wikipedia.org/wiki/Bayesian_linear_regression), using a [bike sharing data set](https://archive.ics.uci.edu/ml/datasets/bike+sharing+dataset)[^1] that will be provided in a suitable format.

## Model

The model is given by:

$$\begin{align}
\sigma^2 &\sim \mathcal{IG}(3, 4/10) \\
\boldsymbol{\beta} &\sim \mathcal{N}(0, I\sigma^2) \\
y_n &\sim \mathcal{N}(\mathbf{x}_n^{\top}\boldsymbol{\beta}, \sigma^2)
\end{align}$$

where $\mathcal{IG}$ denotes the [inverse-gamma distribution](https://en.wikipedia.org/wiki/Inverse-gamma_distribution), and $\mathcal{N}$ the [multivariate normal distribution](https://en.wikipedia.org/wiki/Multivariate_normal_distribution). The parameters of the model are the noise variance $\sigma^2$ and vector of coefficients $\boldsymbol{\beta}$. The data consists of observations $y_n$ and explanatory variables $\mathbf{x}_n$ for $n=1,\ldots,N$.


## Implementation

To specify this model in Birch, we again create a class that inherits from [Model](/documentation/library/classes/Model).

!!! example "Exercise"
    Create a file `birch/LinearRegressionModel.birch` and enter the following code:

        class LinearRegressionModel < Model {

        }

    Don't forget to add the file to `META.json` so that it is included in the build.

Next, we declare the random variables of the model. These are usually declared as member variables of the class.

!!! example "Exercise"
    Enter the following between the curly braces in the previous code:

          /**
           * Explanatory variables.
           */
          X:Real[_,_];

          /**
           * Regression coefficients.
           */
          β:Random<Real[_]>;

          /**
           * Observation variance.
           */
          σ2:Random<Real>;

          /**
           * Observations.
           */
          y:Random<Real[_]>;

We have again used the `/**` `*/` comment style to document each of these member variables, so that we can use the [docs](/documentation/driver/commands/docs) command in future.

Variables in Birch are typed, and declared with the syntax `name:Type`. Lines always end in semicolons. We see here a few different types:

  * `Real` is a double-precision floating point number.
  * `Real[_]` is a vector of `Real`.
  * `Real[_,_]` is a matrix of `Real`.
  * `Random<Type>` declares a *random* (variable) of given `Type`. The use of such randoms is optional, but it enables the use of the *delayed sampling* mechanism of Birch for full or partial analytical solutions to inference problems[^2]. It is particularly useful for this example.

!!! tip
    You can use Greek letters in Birch code. To enter them, you may need to install a separate keyboard in your operating system, or copy and paste from a character map.

Next, we need to establish the joint distribution of these random variables. The [Model](/documentation/library/classes/Model) class has a [*member function*](/documentation/language/classes/#member-fibers) called `simulate` that we override to specify the joint distribution of our model.

!!! example "Exercise"
    Enter the following between the curly braces of the `LinearRegressionModel` class:

        function simulate() {
          auto N <- rows(X);
          auto P <- columns(X);
          if N > 0 && P > 0 {
            σ2 ~ InverseGamma(3.0, 0.4);
            β ~ Gaussian(vector(0.0, P), identity(P)*σ2);
            y ~ Gaussian(X*β, σ2);
          }
        }

Hopefully, this looks similar enough to the equations given above that its meaning is clear. The `if` statement is merely defensive programming: it skips the model for the degenerate situations of no explanatory variables, or no data points.

!!! example "Exercise"
    It is worth building at this point to check that there are no errors in the code you have entered so far:

        birch build

    As before, we can run the model with

        birch sample --model LinearRegressionModel

    although this will not yet do anything interesting; for that, we need data.

## Data

We will use a [data set](https://archive.ics.uci.edu/ml/datasets/bike+sharing+dataset) from the Capital Bikeshare system in Washington D.C. for the years 2011 to 2012. The aim is to use weather and holiday information to predict the total number of bike hires on any given day[^1].

The data set has been preprocessed to convert categorical variables into multiple indicator variables; e.g. the season, a four-category variable, becomes four indicator variables. These conversions make it reasonable to attempt a linear regression. Each data point represents one day. The observation is of the logarithm of the total number of bike hires on that day.

!!! example "Exercise"
    Download the data set [here](/tutorial/bike_share.json) and place it in your project's `input/` directory as `input/bike_share.json`.

    Add the file to `META.json` under `manifest.data`.

The file is in [JSON](http://www.json.org) format. Birch supports both JSON and YAML file formats. You can view and edit these files by hand with a text editor, or for larger files, write programs to generate them.

For now, have a look at the contents of the file in a text editor or web browser. It contains two variables: a matrix `X` and a vector `y`. We need to read these into our model.

The [Model](/documentation/library/classes/Model) class has a member function called `read` that we can override for this purpose. Similarly, it has a member function called `write` that we can override for output.

!!! example "Exercise"
    Enter the following between the curly braces of the `LinearRegressionModel` class:

        function read(buffer:Buffer) {
          X <-? buffer.getRealMatrix("X");
          y <-? buffer.getRealVector("y");
        }

        function write(buffer:Buffer) {
          buffer.set("β", β);
          buffer.set("σ2", σ2);
        }

    Rebuild:

        birch build

This `read` member function reads from the input file into the variables `X` and `y`. The strings `"X"` and `"y"` name elements in the input file. While the names correspond in this case, they need not in general. Similarly, the `write` function writes to the output file.

The [Buffer](/documentation/library/classes/Buffer) class provides the interface for easily reading and writing these. Its `get()` style member functions return [*optionals*](/documentation/language/optionals/), as the requested variable may not exist in the file, or may not have the correct type. The `<-?` assignment operates only if the optional on the right actually has a value.

## Inference

!!! example "Exercise"
    Sample from the posterior distribution with the command:

        birch sample \
            --model LinearRegressionModel \
            --input input/bike_share.json \
            --output output/linear_regression.json

The particular model that we have written has an analytical solution, and has been written in such a way that Birch will recognise this and compute it accordingly via its delayed sampling heuristic[^2]. The above command will output to `output/linear_regression.json`. You can open this file in a text editor to inspect the result. It contains a single posterior sample.

!!! tip
    *Debug* mode is used by default. This mode enables all error checking and disables most optimizations to assist debugging. It is recommended that you use debug mode when developing and testing code. When you are happy that your code is working correctly, you can use *release* mode instead, which will run much faster. This is enabled by adding the option `--enable-release` when calling `birch`, both when building and running:

        birch build --enable-release
        birch sample --enable-release ...

[^1]: H. Fanaee-T & J. Gama (2014). [Event labeling combining ensemble detectors and background knowledge](http://dx.doi.org/10.1007/s13748-013-0040-3). *Progress in Artificial Intelligence*. **2**:113-127.

[^2]: L.M. Murray, D. Lundén, J. Kudlicka, D. Broman and T.B. Schön (2018). [Delayed Sampling and Automatic Rao&ndash;Blackwellization of Probabilistic Programs](https://arxiv.org/abs/1708.07787). In *Proceedings of the 21st International Conference on Artificial Intelligence and Statistics (AISTATS) 2018*, Lanzarote, Spain.
