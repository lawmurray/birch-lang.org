# Bayesian Linear Regression

Now that we have a trivial package running, we can do something more interesting. We will start with a simple example of [Bayesian linear regression](http://en.wikipedia.org/wiki/Bayesian_linear_regression), using a [bike sharing data set](https://archive.ics.uci.edu/ml/datasets/bike+sharing+dataset)[^1] that will be provided in a suitable format.

## Model

The model is given by:
$$
\begin{align}
\sigma^2 &\sim \mathrm{InverseGamma}(3, 4/10) \\\\
\boldsymbol{\beta} \mid \sigma^2 &\sim \mathrm{Gaussian}(0, I\sigma^2) \\\\
\mathbf{y} \mid \boldsymbol{\beta}, \sigma^2 &\sim \mathrm{Gaussian}(\mathbf{X}\boldsymbol{\beta}, I\sigma^2)
\end{align}
$$
The parameters of the model are the noise variance $\sigma^2$ and vector of coefficients $\boldsymbol{\beta}$. The data consists of labels (alternatively: outcomes, dependent variables) in the vector $\mathbf{y}$ and features (alternatively: predictors, covariates, explanatory variables, independent variables) in the matrix $\mathbf{X}$, where each row corresponds to an observation and each column to a feature.


## Implementation

To specify a model in Birch, we create a [class](/language/classes) that inherits from [Model](https://docs.birch.sh/libraries/Standard/classes/Model). Use your preferred text editor to create a file `src/LinearRegressionModel.birch` and enter the following contents:

```birch
/**
 * Bayesian linear regression model with conjugate normal-inverse-gamma
 * prior.
 */
class LinearRegressionModel < Model {
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

  override function simulate() {
    let N <- rows(X);
    let P <- columns(X);
    if N > 0 && P > 0 {
      σ2 ~ InverseGamma(3.0, 0.4);
      β ~ MultivariateGaussian(vector(0.0, P), identity(P)*σ2);
      y ~ MultivariateGaussian(X*β, identity(N)*σ2);
    }
  }
}
```

The features $X$ (the $\mathbf{x}_n$, as a matrix), observations $y$ ($y_n$, as a vector) and parameters $\beta$ and $\sigma^2$ have been declared as *member variables* of the class. [Variables](/language/variables) in Birch are typed. We see here a few different types:

  * `Real` is a double-precision floating point number.
  * `Real[_]` is a vector of `Real`.
  * `Real[_,_]` is a matrix of `Real`.
  * `Random<Type>` declares a [Random](https://docs.birch.sh/libraries/Standard/classes/Random) object of given `Type`. These enable the important features of *automatic marginalization*, *automatic conditioning*, and *automatic differentiation* (see [Key Concepts](/concepts)).

!!! tip
    You can use Greek letters in Birch code. To enter them, you may need to install a separate keyboard in your operating system, or copy and paste from a character map.

The `simulate()` member function implements the model:

  * The `if` statement is merely defensive programming: it skips the model for the degenerate situation of no explanatory variables, or no data points.
  * The `~` operator associates a [Distribution](https://docs.birch.sh/libraries/Standard/classes/Distribution) with a `Random`.
  * The `let` keyword declares a variable, where the type of the variable is inferred from its initial value. An equivalent way to declare `N`, for example, would be `N:Integer <- rows(X)`.

The basic model is now implemented. It is worth building and running at this stage as a check. Build, as usual, with:

    birch build

and run with:

    birch sample --model LinearRegressionModel

Running will not do anything interesting at this stage&mdash;for that we need some data!

## Data

We will use a [data set](https://archive.ics.uci.edu/ml/datasets/bike+sharing+dataset) from the Capital Bikeshare system in Washington D.C. for the years 2011 to 2012. The aim is to use weather and holiday information to predict the total number of bike hires on any given day[^1].

The data set has been preprocessed to one-hot encode categorical features, e.g. the season, a four-category variable, becomes four indicator variables. These conversions make it reasonable to attempt a linear regression. Each data point represents one day. The observation is of the logarithm of the total number of bike hires on that day.

[Download the data set](/getting-started/bike_share.json) to the `input/` directory. The file is in [JSON](http://www.json.org) format. Birch supports both JSON and YAML file formats. You can view and edit these files by hand with a text editor, or for larger files, write programs to generate and manipulate them.

!!! tip
    If you're wanting to stay on the command line, check out [jq](https://stedolan.github.io/jq/) for working with JSON files.

For now, have a look at the contents of the file (`less input/bike_share.json` and hit `q` when you've seen enough). It contains two variables: a matrix `X` and a vector `y`. We need to read these into the model.

Recall that, in defining the `LinearRegressionModel` class, we overrode the `simulate()` member function of the `Model` class. The `Model` class also has two other member functions: `read(buffer:Buffer)` and `write(buffer:Buffer)`. We override these to read and write data.

Add the following two member functions after the `simulate()` member function in the `LinearRegressionModel` class:

```birch
    override function read(buffer:Buffer) {
      X <-? buffer.get<Real[_,_]>("X");
      y <-? buffer.get<Real[_]>("y");
    }

    override function write(buffer:Buffer) {
      buffer.set("β", β);
      buffer.set("σ2", σ2);
    }
```

The [Buffer](https://docs.birch.sh/libraries/Standard/classes/Buffer) class provides the interface for easily reading and writing files. Its basic interface provides `get` functions for reading, and `set` functions for writing, usually with key-value pairs.

The `write(buffer:Buffer)` member function is the simpler of the two. It writes the parameters to the output file using `set` function calls. The first argument of each call is the key to write, and the second the value.

The `read(buffer:Buffer)` member function reads from the input file using `get` function calls. The single argument of each is the key to read. We also need to specify the type of the value to read. This is given as a *type argument* in angle brackets immediately after the function name, e.g.  `get<Real[_,_]>`. Functions that take type arguments like this are known as [generic functions](/language/functions/).

The `get` member function returns an [optional](/language/optionals/). An optional is just a variable that may or may not have a value. Here, if the requested element exists in the file, it has a value, otherwise it does not. The `<-?` is a special assignment operator that assigns a value to the variable on the left only if the optional on the right actually has a value. That is, if the key is found in the file the value is read and assigned to the variable on the left, otherwise nothing happens.

## Inference

Now rebuild:

    birch build

and run:

    birch sample \
        --model LinearRegressionModel \
        --input input/bike_share.json \
        --output output/linear_regression.json

This run command specifies the model class to use, the input file from which to read, and the output file to which to write.

View the output with:

    cat output/linear_regression.json

You will see a single sample drawn from the posterior distribution.

!!! tip
    We have already noted that this particular example has an analytical solution. We can, in fact, output this solution if preferred. To do so, update the `write()` member function as follows, then re-build and re-run:

    ```birch
        override function write(buffer:Buffer) {
          if β.hasDistribution() {
            buffer.set("β", β.getDistribution());
          } else {
            buffer.set("β", β);
            buffer.set("σ2", σ2);
          }
        }
    ```

!!! tip
    *Debug* mode is used by default. This mode enables all error checking and disables all optimizations to assist with debugging. Debug mode is recommended when developing and testing code. When you are happy that your code is working correctly, you can use *release* mode instead, which takes longer to build but runs much faster (several times so). Release mode is enabled by adding the option `--enable-release` when calling `birch`:

        birch build --enable-release
        birch sample --enable-release ...

[^1]: H. Fanaee-T & J. Gama (2014). [Event labeling combining ensemble detectors and background knowledge](http://dx.doi.org/10.1007/s13748-013-0040-3). *Progress in Artificial Intelligence*. **2**:113-127.

