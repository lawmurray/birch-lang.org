# birch.sh website

Currently requires a custom `pygments` package with Birch lexer. Install the Birch lexer with:

    git clone https://github.com/pygments/pygments.git
    cp src/birch.py pygments/pygments/lexers/.
    cd pygments
    make mapfiles
    easy_install-3.8 --prefix $HOME/.local .

Then can use `mkdocs build`, `mkdocs serve`, `mkdocs gh-deploy`, etc, as normal.
