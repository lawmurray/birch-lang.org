A plugin is available for syntax highlighting of Birch code within the [Eclipse](http://www.eclipse.org) IDE. Eclipse can also parse the error messages produced by the Birch compiler, enabling quick navigation to problem lines of code. This can help improve workflow.

!!! info "Contributions"
    The development of a project wizard plugin to also automate the creation of Birch projects, using the `birch init` command, would be particularly welcome.


## Installing the plugin

To install the plugin, use the *Help > Install New Software...* menu item from within Eclipse. Click the *Add...* button and enter the following update site URL:

<http://www.birch-lang.org/eclipse/updates>

Follow the prompts from there. The plugin should be automatically associated with the `*.bi` file extension.


## Creating projects in Eclipse

Once a Birch project has been created from the command line with `birch init`:

  1. Import it into Eclipse using *File > New > Makefile Project with Existing Code*.
  2. Under *Project > Properties*, select *C/C++ Build* on the left.
  3. Go to the *Builder Settings* tab and enter `birch` as the build command.
  4. Go to the *Behavior* tab and enter `build` (or `install`, if preferred) next to the *Build (Incremental build)* checkbox.

You can then use the *Project > Build* menu item, or keyboard shortcuts, to build your project.


## Streamlining the build process

It is worth importing the Birch compiler and standard library into your Eclipse workspace also, to establish them as dependencies of your own project.

Use the *File > Import* menu item from within Eclipse, then:

  * If you already have the *Birch* and *Birch.Standard* repositories in your file system, select *General > Existing Projects into Workspace* in the first dialog and follow the prompts.
  * If you do not, use *Git > Projects from Git*, then *Clone URI* and enter <https://www.github.com/lawmurray/Birch.git>. Follow the prompts from there. Repeat a second time with <https://www.github.com/lawmurray/Birch.Standard.git>.

Once the projects are imported, go to the properties for your own project, select *Project References* on the left, and choose *Birch.Standard*.

Now, when you build your own project, Eclipse will automatically rebuild *Birch.Standard* and, in turn, *Birch*, if necessary.
