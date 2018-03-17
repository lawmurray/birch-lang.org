Now that we have a trivial model running, we can do something more substantial. We will start with a simple example of [Bayesian linear regression](http://en.wikipedia.org/wiki/Bayesian_linear_regression), using a [bike sharing data set](https://archive.ics.uci.edu/ml/datasets/bike+sharing+dataset) that will be provided in a suitable format.

### Model

The model is given by:
$$\begin{align}
\sigma^2 &\sim \mathcal{\Gamma}^{-1}(3, 4/10) \\
\boldsymbol{\beta} &\sim \mathcal{N}(0, I\sigma^2) \\
y_n &\sim \mathcal{N}(\mathbf{x}_n^{\top}\boldsymbol{\beta}, \sigma^2)
\end{align}$$
where $\mathcal{\Gamma}^{-1}$ denotes the [inverse-Gamma distribution](https://en.wikipedia.org/wiki/Inverse-gamma_distribution), $\mathcal{N}$ the [multivariate normal distribution](https://en.wikipedia.org/wiki/Multivariate_normal_distribution), and there are $N$ number of observations indexed $n=1,\ldots,N$.

To specify this model in Birch, we again create a class that inherits from [Model](/documentation/library/classes/Model). Create a file `bi/LinearRegressionModel.bi` and enter the following code:

    class LinearRegressionModel < Model {

    }

Don't forget to add the file to `META.json` so that it is included in the build.

Next, we declare the random variables of the model. These are usually declared as member variables of the class. Enter the following between the curly braces in the previous code:

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

Variables in Birch are typed, and declared with the syntax `name:Type`. We see here a few different types:

  * `Real` is a double-precision floating point number.
  * `Real[_]` is a vector of `Real`.
  * `Real[_,_]` is a matrix of `Real`.
  * `Random<Type>` declares a random variable of given `Type`. Its use is optional, but it enables the use of the *delayed sampling* mechanism of Birch for partial (or full) analytical solutions to problems. It is particularly useful for this example.

!!! note
    We again use the `/**` `*/` comment style to document each of these member variables, so that we can use the [docs](/documentation/driver/commands/docs) command in future.

!!! tip
    You can use Greek letters in Birch code! To type them, you may need to install a separate keyboard in your operating system:
      * On macOS, go to *System Preferences > Keyboard > Input Sources*. You can switch between keyboard layouts with *Command + Space Bar*.

    Another option is to copy and paste them from a character map.

!!! help "Contributions"
    What is the best approach for other operating systems?

Next, we need to establish the joint distribution of these random variables. The [Model](/documentation/library/classes/Model) class has a *member fiber* called `simulate` that we override to specify the joint distribution of our model.

!!! info
    A *fiber* is a particular language construct in Birch. It is essentially a function whose execution can be paused and resumed. This is critical for many inference methods. More details are given later, but for now, we just accept its use as idiomatic.

Enter the following between the curly braces of the `LinearRegressionModel` class:

    fiber simulate() -> Real! {
      N:Integer <- rows(X);
      P:Integer <- columns(X);
      if (N > 0 && P > 0) {
        σ2 ~ InverseGamma(3.0, 0.4);
        β ~ Gaussian(vector(0.0, P), identity(P)*σ2);
        y ~ Gaussian(X*β, σ2);
      }
    ]

Hopefully, this looks similar enough to the equations given above that its meaning is clear. The `if` statement is merely defensive programming: it skips the model for the degenerate situations of no explanatory variables, or no observations.

It is worth building at this point to check that there are no errors in the code you have entered so far:

    birch build

As before, we can run the model with

    birch sample --model LinearRegressionModel

although this will not yet do anything interesting; for that, we need data.

### Input

We will use a [data set](https://archive.ics.uci.edu/ml/datasets/bike+sharing+dataset) from the Capital Bikeshare system in Washington D.C. for the years 2011 to 2012. The aim is to use weather and holiday information to predict the number of bike hires on any given day.

The data set has been preprocessed for the purposes of this tutorial. Download it [here](/tutorial/bike_share.json) and place it in your project's `input/` directory as `input/bike_share.json`. Also add the file to `META.json` under `manifest.data`.

!!! info
    The data set has been preprocessed to convert categorical variables into multiple indicator variables. For example, the season, a four-category variable, becomes four indicator variables. These conversions make it reasonable to attempt a linear regression.

The file is in [JSON](http://www.json.org) format, which is the current standard file format for input and output in Birch. You can view and edit these files by hand with a text editor, or for larger files, there are packages available for most programming languages that will allow you to write pre- and post-processing scripts for your data. More formats will be available for use with Birch in time.

!!! tip
    In MATLAB, you can use [JSONlab](https://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files) to read and write JSON files

!!! help "Contributions"
    Can you recommend a package for Julia, or R, or otherwise?

For now, have a look at the contents of the file in a text editor. It contains two variables: a matrix `X` and a vector `y`. We need to get these into our model.

The [Model](/documentation/library/classes/Model) class has a member function called `input` that we can override for this purpose. Enter the following between the curly braces of the `LinearRegressionModel` class:

    function input(reader:Reader) {
      X <- reader.getRealMatrix("X")!;
      y <- reader.getRealVector("y")!;
    }

This reads the matrix `X` and the vector `y` from the input file into the corresponding member variables. The [Reader](/documentation/library/classes/Reader) class provides the interface for easily reading these in. Its member functions return *optionals*, as the requested variable may not exist in the file. We are being lazy with the above code by using the `!` operator after each call, essentially assuming that the variables exist.

!!! info
    While an aside at this stage, optionals are quite common in Birch code, as they allow us to deal with missing values easily. A more idiomatic usage would be as follows:

        Z:Real[_,_]? <- reader.getRealMatrix("X");
        if (Z?) {
          X <- Z;
        }

    The `?` after the type declares an optional variable, the `?` operator in the `if` statement condition checks if it has a value, the `!` operator in the `if` body retrieves that value, if it exists.

We can run the model with

    birch sample --model LinearRegressionModel --input-file input/bike_share.json

This will in fact perform inference, but will not yet produce any output.


### Output

Finally, we need to output results to a file. The [Model](/documentation/library/classes/Model) class has a member function called `output` that we can override for this purpose. Enter the following between the curly braces of the `LinearRegressionModel` class:

    function output(writer:Writer) {
      writer.setRealVector("beta", β);
      writer.setReal("sigma2", σ2);
    }

!!! note
    We have not used Greek letters in the names of variables in the output file. While possible in Birch, we have noticed some issues with then reading the files elsewhere, such as in MATLAB.

We can now run the model with

    birch sample --model LinearRegressionModel --input-file input/bike_share.json  --output-file output/bike_share.json --nsamples 5

!!! info
    Debugging mode is enabled by default, which dramatically slows down execution times. It is recommended that you keep debugging mode enabled when developing and testing code (perhaps on small problems), but disable it when running tested code.

    To disable it, you must rebuild both the standard library and your project with the `--disable-debug` option:

        birch clean
        birch build --disable-debug

    This will be streamlined in future.

This will output five samples from the posterior distribution into `output/bike_share.json`.

The particular model that we have written has an analytical solution, and has been written in such a way that Birch will recognise this and compute it accordingly. This is unusual, however, and Birch is more designed for outputting samples.


### Results

You can open the `output/bike_share.json` file in a text editor to inspect the results.

Birch does not yet include a facility for plotting. It is expected, at least for now, that you will use an environment such as Julia, MATLAB or R for this task.

In MATLAB, for example, you can plot the results with something like this:

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
