# How to use Birch with the Eclipse IDE

A plugin is available for syntax highlighting of Birch code within [Eclipse](http://www.eclipse.org). Eclipse can also parse the error messages produced by the Birch compiler, enabling quick navigation to problem lines of code. This can help improve workflow.

![Screenshot of Eclipse on macOS with syntax highlighting for Birch source files and terminal for running Birch commands.](/images/eclipse-screenshot.png)


## Installing the Birch plugin

To install the plugin, use the *Help > Install New Software...* menu item from within Eclipse. Click the *Add...* button and enter the following update site URL:

<http://www.birch-lang.org/eclipse/updates>

Select the plugin from the list and follow the prompts from there. The plugin should be automatically associated with the `*.bi` file extension.

!!! bug
    If the plugin does not appear in the list, uncheck the *Group items by category* checkbox. (We're working on it.)


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

!!! info "Getting involved"
    The development of a project wizard plugin to automate the creation of Birch projects, using the `birch init` command, would be a welcome addition.

Within Eclipse, you can treat Birch projects as if they are C/C++ Makefile Projects, with a few tweaks to the project properties as outlined below.

You will need the [Eclipse C/C++ Development Tooling (CDT)](https://www.eclipse.org/cdt/) for this, not just the Eclipse Java Development Tools (JDT). Often, a default Eclipse installation only installs the latter, so you may need to install the former.

Once a Birch project has been created from the command line with `birch init`:

  1. Import it into Eclipse using *File > New > Makefile Project with Existing Code*.
  2. Under *Project > Properties*, select *C/C++ Build* on the left.
  3. Go to the *Builder Settings* tab and enter `birch` as the build command.
  4. Go to the *Behavior* tab and enter `build` (or `install`, if preferred) next to the *Build (Incremental build)* checkbox.

You can then use the *Project > Build* menu item, or keyboard shortcuts, to build your project.


## Streamlining the build process

It is worth importing the Birch compiler and standard library into your Eclipse workspace as well, to establish them as dependencies of your own project.

Use the *File > Import* menu item from within Eclipse, then:

  * If you already have the *Birch* and *Birch.Standard* repositories in your file system, select *General > Existing Projects into Workspace* in the first dialog and follow the prompts.
  * If you do not, use *Git > Projects from Git*, then *Clone URI* and enter <https://www.github.com/lawmurray/Birch.git>. Follow the prompts from there. Repeat a second time with <https://www.github.com/lawmurray/Birch.Standard.git>.

Once the projects are imported, go to the properties for your own project, select *Project References* on the left, and choose *Birch.Standard*.

Now, when you build your own project, Eclipse will automatically rebuild *Birch.Standard* and, in turn, *Birch*, if necessary.

Note that, unlike when creating your own projects, it is not necessary to modify the project properties for the Birch compiler and standard library. The repositories already include Eclipse project files with the relevant settings.
