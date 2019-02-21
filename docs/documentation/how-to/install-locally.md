# How to install without root access

When using Linux systems, the user account does not typically have root access, and cannot be used to install to standard system-wide directories such as `/usr/local`. If your user account has appropriate permissions, you may be able to simply use `sudo` when installing. If not, follow the instructions here, which will set you up to install in your home directory instead.

Assuming that you are using `bash`, add the following lines to your `.bashrc` or `.bash_profile` file:

    export PATH=$HOME/bin:$PATH
    export CPATH=$HOME/include:$CPATH
    export LIBRARY_PATH=$HOME/lib:$LIBRARY_PATH
    export LD_LIBRARY_PATH=$HOME/lib:$LD_LIBRARY_PATH
    export BIRCH_PREFIX=$HOME

Restart your terminal or type `su - $USER` to login again and restart your environment. You can now install Birch to your home directory:

    ./configure --prefix=$HOME
    make -j 8
    make install

The `--prefix=$HOME` is the key ingredient here. You now have a local installation of Birch in your `$HOME/bin` directory, rather than a system-wide directory. To check that this is the case, run `which birch` and confirm that the version installed in your home directory is reported.

The `BIRCH_PREFIX` environment variable set in your `.bashrc` or `.bash_profile` file above will ensure that Birch installs packages into your home directory by default too.

!!! tip
    This setup works for just about anything else you might like to install as well. It is not specific to Birch.
