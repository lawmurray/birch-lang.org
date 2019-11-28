# Integrated development with Eclipse

[Eclipse](http://www.eclipse.org) is a popular open-source integrated development environment (IDE) with support for Java, C/C++, PHP, and a host of other programming languages via an ecosystem of extensions.

You can use Eclipse with Birch, too. A plugin is available for syntax highlighting of Birch code. Birch projects can otherwise be treated as if they are C/C++ projects, with only a few minor changes to settings as detailed below. Error messages from the Birch compiler are understood by Eclipse, so that it is able to annotate problem lines of code and allow quick navigation to them. This can help streamline workflow.

![Screenshot of Eclipse on macOS with syntax highlighting for Birch source files and terminal for running Birch commands.](/images/eclipse-screenshot.png)


## Preliminaries

When installing Birch itself, use the following commands:

    ./configure INSTALL="install -p"
    make -j 8
    sudo make install

The reason for the `INSTALL` variable: when building a project through Eclipse, it will also rebuild project references, which includes Birch itself. This prevents installation of files that have not changed, which would otherwise have their timestamp updated, which in turn would trigger unnecessary rebuilding of package files. When Birch is building packages, it already does this, so you only need to do it for Birch itself.


## Installing Eclipse

You should install the Eclipse IDE for C/C++ Developers linked from [here](https://www.eclipse.org/downloads/eclipse-packages/).

If you already have Eclipse installed but without the C/C++ Development Tools (default installs are often for Java development only), you can add the C/C++ Development Tools to that Eclipse installation via the *Help > Install New Software...* menu item. Select *All Available Sites* from the select box at the top, and choose *Programming Languages > C++ Development Tools*, then follow the prompts.

!!! tip
    On Ubuntu, install Eclipse through the Ubuntu Software Centre, not through `apt-get`, as the version in the latter may be very outdated.


## Installing the Birch plugin

To install the plugin, use the *Help > Install New Software...* menu item from within Eclipse. Click the *Add...* button and enter the following update site URL:

<http://www.birch-lang.org/eclipse/updates>

Select the plugin from the list and follow the prompts from there. The plugin should be automatically associated with the `*.bi` file extension.


## Installing the TM Terminal plugin

While optional, another useful plugin is [TM Terminal](http://marketplace.eclipse.org/content/tm-terminal). This allows you to open a terminal from within Eclipse. You can then run `birch` within this terminal instead of an external terminal, staying within the one environment as you work.

To install TM Terminal, use the *Help > Install New Software...* menu item from within Eclipse. Click the *Add...* button and enter the following update site URL:

<http://download.eclipse.org/tm/terminal/updates/4.3>

Select to install the *TM Terminal* item and follow the prompts from there.

!!! tip
    On macOS, the version of TM Terminal available from the Eclipse Marketplace may have some font issues (this has been observed on High Sierra running Eclipse Oxygen). It is recommended that you install using the above site URL rather than using the Eclipse Marketplace, as it will install a later version that seems to fix this problem.

    Also on macOS, the terminal is not configured with the same environment as the Terminal app, so that trying to run `birch` may fail. To fix this, open the *Eclipse > Preferences* menu item, go to *Terminal > Local Terminal* on the left, and enter arguments of `--login`.

Once TM Terminal is installed, you can open a terminal window by using *Window > Show View > Other* and selecting *Terminal*. When the empty terminal window appears, click the *Open a Terminal* icon on the right side of the toolbar and choose *Local Terminal* to open a new tab with a terminal.


## Creating projects in Eclipse

Within Eclipse, you can treat Birch projects as if they are C/C++ Makefile Projects, with a few tweaks to the project properties as outlined below.

You will need the [Eclipse C/C++ Development Tooling (CDT)](https://www.eclipse.org/cdt/) for this, not just the Eclipse Java Development Tools (JDT). Often, a default Eclipse installation only installs the latter, so you may need to install the former.

Once a Birch project has been created from the command line with `birch init`:

  1. Import it into Eclipse using *File > New > Makefile Project with Existing Code*.
  2. Under *Project > Properties*, select *C/C++ Build* on the left.
  3. Go to the *Builder Settings* tab and enter `birch` as the build command.
  4. Go to the *Behavior* tab and enter `install` next to the *Build (Incremental build)* checkbox.

You can then use the *Project > Build* menu item, or keyboard shortcuts, to build your project.


## Streamlining the build process

It is worth importing the Birch compiler and standard library into your Eclipse workspace as well, to establish them as dependencies of your own project.

Use the *File > Import* menu item from within Eclipse, then:

  * If you already have the *Birch* and *Birch.Standard* repositories in your file system, select *General > Existing Projects into Workspace* in the first dialog and follow the prompts.
  * If you do not, use *Git > Projects from Git*, then *Clone URI* and enter <https://www.github.com/lawmurray/Birch.git>. Follow the prompts from there. Repeat a second time with <https://www.github.com/lawmurray/Birch.Standard.git>.

Once the projects are imported, go to the properties for your own project, select *Project References* on the left, and choose *Birch.Standard*.

Now, when you build your own project, Eclipse will automatically rebuild *Birch.Standard* and, in turn, *Birch*, if necessary.

Note that, unlike when creating your own projects, it is not necessary to modify the project properties for the Birch compiler and standard library. The repositories already include Eclipse project files with the relevant settings.


## Setting up without root access

First, set up your terminal for use without root access following the how-to guide [here](/documentation/how-to/install-locally).

Then, within Eclipse, go to *Preferences > C/C++ > Build > Environment*, add a variable `BIRCH_PREFIX` with value `${HOME}`. This will apply to all projects, which is probably what you want. Alternatively, if you wish to do this for particular projects only, use *Project Properties > C/C++ Build > Environment* for each of those projects instead.


## Miscellaneous notes

  * C++ amongst the Birch source code does not seem to gel with the Eclipse code analysis features. To turn these off, go to *Preferences > C/C++ > Code Analysis* and uncheck all the boxes.

  * If seeing a bunch of error annotations down the side of the editor, right click and turn off those that you don't want to see.

  * By default the keyboard shortcut `Ctrl-B` is mapped to *Build All*. You may wish to map it to *Build Project* instead and rely on project references to rebuild what is necessary. You can change this in *Preferences > General > Keys*.
