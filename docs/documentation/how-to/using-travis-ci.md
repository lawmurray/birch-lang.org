# Testing with Travis CI

[Travis CI](https://www.travis-ci.com) is a continuous integration service that works alongside [GitHub](https://www.github.com) to run tests whenever new commits are made to a repository. Other such services include [Circle CI](https://www.circleci.com) and [Bitrise](https://www.bitrise.io), as well as standalone software such as [Jenkins](https://jenkins.io/).

Travis CI is currently used for Birch development. This page explains how you can set up Travis CI for your own Birch projects, too.

After signing up for the Travis CI service, you will need to add a `.travis.yml` file to your code repository. A suggested template for Birch projects is as follows:

``` yml
language: cpp
matrix:
    # macOS environment
    - os: osx
      compiler: clang
      osx_image: xcode10.3
      addons:
        homebrew:
          update: true
          packages:
            - flex
            - bison
            - eigen
            - libyaml
            - libomp

    # Ubuntu 16.04 environment
    - os: linux
      dist: xenial
      compiler: gcc
      addons:
        apt:
          packages:
            - autoconf
            - libtool
            - flex
            - bison
            - libeigen3-dev
            - libyaml-dev
            - libboost-all-dev
before_install:
  # Checkout Birch, which may be cached, and (re)build
  - git clone "https://github.com/lawmurray/Birch.git" || cd .
  - cd Birch && git stash && git pull && git checkout master && ./autogen.sh && ./configure INSTALL="install -p" && make -j 2 && sudo make install && cd ..

  # Checkout Birch.Standard, which may be cached, and (re)build
  - git clone "https://github.com/lawmurray/Birch.Standard.git" || cd .
  - cd Birch.Standard && git stash && git pull && git checkout master && birch build && sudo birch install && cd ..

install:
  - birch build && sudo birch install
script:
  - ./run.sh
cache:
  directories:
    - Birch
    - Birch.Standard
```

This sets up both macOS and Ubuntu builds, and caches the Birch compiler and Birch standard library to recompile them only when necessary. Anecdotally, for [Birch.Standard](http://www.github.com/lawmurray/Birch.Standard), we observe that tests take 6-8 minutes for each instance, reducing to 3-4 minutes with an up-to-date cache.
