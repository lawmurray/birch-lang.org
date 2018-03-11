Birch can run through the Bash shell on Windows 10.

If you have not done so already, activate the developer mode:

1. Go to _Settings_.
2. Go to _Update and security_.
3. Go to _For developer_.
4. Activate the developer mode.
5. Wait for the package configuration.

Then configure the Bash shell:

1. Go to _Control panel_.
2. Go to _Programs and features_.
3. Go to _Turn Windows features on or off_.
4. Check _Windows subsystem for Linux_.
5. Press OK.
6. Restart Windows.
7. Afer the restart open the _Command prompt_ (search for `cmd`).
8. Run the command:
    ```sh
    lxrun /install /y
    ```

9. Open the program _Bash on Ubuntu on Windows_ (search for `Bash`). This is a fully-functional Linux Bash shell with access to the Ubuntu repository. You can also access the file system using the usual Bash commands, noting that the folder `C:\` is called `mnt/c/` here.

10. Update Linux packages:
    ```sh
    apt-get upgrade
    apt-get update
    ```

With the Bash shell now working, follow the instructions for [Ubuntu Linux](/getting-started/ubuntu.md) to install dependencies.
