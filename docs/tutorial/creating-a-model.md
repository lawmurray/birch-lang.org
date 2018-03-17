A model is specified in Birch by creating a class that inherits from [Model](/documentation/library/classes/Model). To do this, create a file called `bi/TestModel.bi` and enter the following code:

    /**
     * Test model.
     */
    class TestModel < Model {

    }

!!! info
    Comments are written in Birch by either enclosing the comment text with `/*` and `*/`, or putting the comment text on the end of a line, preceded by `//`.

    The special `/**` `*/` comment used in the above code acts like an ordinary comment, but can be extracted by the [docs](/documentation/driver/commands/docs) command to create reference documentation for your project. It is recommended that you use such a comment for all classes and functions that should be visible to a user of your package.

Open the `META.json` file of your project and add `bi/TestModel.bi` to the list under `manifest.source`. It should then look something like this:

    {
      "name": "Tutorial",
      "version": "0.0.0",
      "description": "",
      "manifest": {
        "source": [
          "bi/TestModel.bi"
        ],
        "other": [
          "LICENSE",
          "META.json",
          "README.md"
        ]
      }
    }

The model is empty, but nonetheless we can now build our project and run it. Build the project with:

    birch build

Now sample from the (empty!) model with:

    birch sample --model TestModel

If this succeeds, nothing will happen, as the model is empty. If this produces an error message, there may be a problem with your Birch installation that you will need to troubleshoot.

The [sample](/documentation/library/programs/sample) program that you have just run is part of the Birch standard library. It provides a common interface to the available inference methods.

!!! error
    If you receive an error message such as, `LinearRegressionModel must be a subtype of Model with no initialization parameters`, then you have probably forgotten to add `LinearRegressionModel.bi` to `META.json`.
