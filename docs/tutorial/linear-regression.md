Now that we have a trivial model running, we can do something more interesting. We will start with a simple example of [Bayesian linear regression](http://en.wikipedia.org/wiki/Bayesian_linear_regression), using a [bike sharing data set](https://archive.ics.uci.edu/ml/datasets/bike+sharing+dataset)[^1] that will be provided in a suitable format.

## Model

The model is given by:
$$\begin{align}
\sigma^2 &\sim \mathrm{Inv\text{-}Gamma}(3, 4/10) \\
\boldsymbol{\beta} &\sim \mathcal{N}(0, I\sigma^2) \\
y_n &\sim \mathcal{N}(\mathbf{x}_n^{\top}\boldsymbol{\beta}, \sigma^2)
\end{align}$$
where $\mathrm{Inv\text{-}Gamma}$ denotes the [inverse-Gamma distribution](https://en.wikipedia.org/wiki/Inverse-gamma_distribution), and $\mathcal{N}$ the [multivariate normal distribution](https://en.wikipedia.org/wiki/Multivariate_normal_distribution). The parameters of the model are the noise variance $\sigma^2$ and vector of coefficients $\boldsymbol{\beta}$. The data consists of observations $y_n$ and explanatory variables $\mathbf{x}_n$ for $n=1,\ldots,N$.


## Implementation

To specify this model in Birch, we again create a class that inherits from [Model](/documentation/library/classes/Model).

!!! example "Exercise"
    Create a file `bi/LinearRegressionModel.bi` and enter the following code:

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
    You can use Greek letters in Birch code! To enter them, you may need to install a separate keyboard in your operating system:

      * On macOS, go to *System Preferences > Keyboard > Input Sources*. You can switch between keyboard layouts with *Command + Space Bar*.

    Another option is to copy and paste from a character map.

!!! info "Contributions"
    What is the best approach for other operating systems?

Next, we need to establish the joint distribution of these random variables. The [Model](/documentation/library/classes/Model) class has a [*member fiber*](/documentation/language/classes/#member-fibers) called `simulate` that we override to specify the joint distribution of our model.

A [*fiber*](/documentation/language/fibers/) is a particular language construct in Birch. It is essentially a function for which execution can be paused and resumed. This is critical for many inference methods. For the purposes of this tutorial, we accept its use here as idiomatic.

!!! example "Exercise"
    Enter the following between the curly braces of the `LinearRegressionModel` class:

          fiber simulate() -> Real! {
            N:Integer <- rows(X);
            P:Integer <- columns(X);
            if (N > 0 && P > 0) {
              σ2 ~ InverseGamma(3.0, 0.4);
              β ~ Gaussian(vector(0.0, P), identity(P)*σ2);
              y ~ Gaussian(X*β, σ2);
            }
          }

Hopefully, this looks similar enough to the equations given above that its meaning is clear. The `if` statement is merely defensive programming: it skips the model for the degenerate situations of no explanatory variables, or no data points.

It is worth building at this point to check that there are no errors in the code you have entered so far:

    birch build

As before, we can run the model with

    birch sample --model LinearRegressionModel

although this will not yet do anything interesting; for that, we need data.

!!! error
    If you receive an error message such as, `LinearRegressionModel must be a subtype of Model with no initialization parameters`, then you have probably forgotten to add `LinearRegressionModel.bi` to `META.json`.

## Data

We will use a [data set](https://archive.ics.uci.edu/ml/datasets/bike+sharing+dataset) from the Capital Bikeshare system in Washington D.C. for the years 2011 to 2012. The aim is to use weather and holiday information to predict the total number of bike hires on any given day[^1].

The data set has been preprocessed to convert categorical variables into multiple indicator variables; e.g. the season, a four-category variable, becomes four indicator variables. These conversions make it reasonable to attempt a linear regression. Each data point represents one day. The observation is of the logarithm of the total number of bike hires on that day.

!!! example "Exercise"
    Download the data set [here](/tutorial/bike_share.json) and place it in your project's `input/` directory as `input/bike_share.json`. Also add the file to `META.json` under `manifest.data`.

The file is in [JSON](http://www.json.org) format, which is the current standard file format for input and output in Birch. You can view and edit these files by hand with a text editor, or for larger files, there are packages available for most programming languages that will allow you to write pre- and post-processing scripts for your data. Birch will support more formats in time.

!!! tip
    In MATLAB, you can use [JSONlab](https://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files) to read and write JSON files

!!! info "Contributions"
    What are appropriate packages for R, Julia, others?

For now, have a look at the contents of the file in a text editor. It contains two variables: a matrix `X` and a vector `y`. We need to get these into our model.

The [Model](/documentation/library/classes/Model) class has a member function called `input` that we can override for this purpose.

!!! example "Exercise"
    Enter the following between the curly braces of the `LinearRegressionModel` class:

          function input(reader:Reader) {
            X <- reader.getRealMatrix("X")!;
            y <- reader.getRealVector("y")!;
          }

This reads the matrix `X` and the vector `y` from the input file into the corresponding member variables. The [Reader](/documentation/library/classes/Reader) class provides the interface for easily consuming these. Its member functions return [*optionals*](/documentation/language/optionals/), as the requested variable may not exist in the file, or may not have the correct type. We are being somewhat lazy with the above code by using the `!` operator after each call, essentially assuming that the variables do exist.

Optionals are quite common in Birch code. They are useful for handling missing values. A more idiomatic usage is as follows:

    Z:Real[_,_]? <- reader.getRealMatrix("X");
    if (Z?) {
      X <- Z;
    }

The `?` after the type declares an optional variable, the `?` operator in the `if` statement condition checks if it has a value, the `!` operator in the `if` body retrieves that value, if it exists.


## Inference

We can run the model with

    birch sample --model LinearRegressionModel --input-file input/bike_share.json

This will in fact perform inference, but will not yet produce any output. We need to output results to a file. The [Model](/documentation/library/classes/Model) class has a member function called `output` that we can override for this purpose.

!!! example "Exercise"
    Enter the following between the curly braces of the `LinearRegressionModel` class:

          function output(writer:Writer) {
            writer.setRealVector("beta", β);
            writer.setReal("sigma2", σ2);
          }

We have not used Greek letters in the names of variables that appear in the file. We would like to, but this appears unsupported by some other software (such as MATLAB) when reading in the file.

We can now run the model.

!!! example "Exercise"
    Sample from the posterior distribution with the command:

        birch sample \
            --model LinearRegressionModel \
            --input-file input/bike_share.json \
            --output-file output/bike_share.json \
            --nsamples 5

The particular model that we have written has an analytical solution, and has been written in such a way that Birch will recognise this and compute it accordingly via its delayed sampling mechanism[^2]. For output, however, it will sample from this distribution.

The above command will output five samples from the posterior distribution to `output/bike_share.json`.

!!! tip
    Debugging mode is enabled by default, which dramatically slows down execution times. It is recommended that you keep debugging mode enabled when developing and testing code (perhaps on small problems), but disable it when running tested code.

    To disable it, you must rebuild both the standard library and your project with the `--disable-debug` option:

        birch clean
        birch build --disable-debug

    This will be streamlined in future.

You can open the `output/bike_share.json` file in a text editor to inspect the results.

Birch does not yet include a facility for plotting. It is expected, at least for now, that you will use an environment such as MATLAB, R, or Julia for this task.

!!! tip
    In MATLAB, using [JSONlab](https://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files), you can plot the results with something like this:

        % read in files
        input = loadjson('input/bike_share.json');
        output = loadjson('output/bike_share.json');

        % predict
        Z = [];
        for n = 1:length(output)
          Z = [ Z; output{n}.sample.beta*input.X' ];
        end
        q = quantile(Z, [0.025 0.5 0.975]);

        % plot
        plot(q(2,:), '-b', 'linewidth', 2);
        hold on;
        plot(q(1,:), '-b');
        plot(q(3,:), '-b');
        plot(input.y, 'or');
        hold off;

[^1]: H. Fanaee-T & J. Gama (2014). [Event labeling combining ensemble detectors and background knowledge](http://dx.doi.org/10.1007/s13748-013-0040-3). *Progress in Artificial Intelligence*. **2**:113-127.

[^2]: L.M. Murray, D. Lundén, J. Kudlicka, D. Broman and T.B. Schön (2018). [Delayed Sampling and Automatic Rao&ndash;Blackwellization of Probabilistic Programs](https://arxiv.org/abs/1708.07787). In *Proceedings of the 21st International Conference on Artificial Intelligence and Statistics (AISTATS) 2018*, Lanzarote, Spain.
