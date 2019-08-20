# How to use Travis CI

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


## Pre 2019

!!! info
    This section is kept for reference.

Setting up Travis CI for Birch projects is much easier now that Ubuntu 16.04 Xenial is supported, as well as a Homebrew addon for macOS. Previously, it was necessary to use Ubuntu 14.04 Trusty. The default `gcc` provided with Trusty does not support C++14 language features required by Birch. Furthermore, no sufficiently recent version of Eigen is available through `apt`. This complicates the configuration somewhat:

``` yml
language: cpp
matrix:
  include:
    # macOS environment
    - os: osx
      compiler: clang
      osx_image: xcode9.3

    # Ubuntu 14.04 environment
    - os: linux
      dist: trusty
      compiler: gcc
      addons:
        apt:
          sources:
            - ubuntu-toolchain-r-test
          packages:
            - gcc-7
            - g++-7
            - autoconf
            - libtool
            - flex
            - bison
            - libboost-all-dev
before_install:
  # OS-specific things
  - if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
      export CC=gcc-7;
      export CXX=g++-7;
      export CXXFLAGS="-DBOOST_NO_CXX11_SCOPED_ENUMS";
      wget http://bitbucket.org/eigen/eigen/get/3.3.4.tar.gz && tar xzf 3.3.4.tar.gz && sudo cp -Rp eigen-eigen-5a0156e40feb /usr/local/include/eigen3;
    elif [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
      export HOMEBREW_NO_AUTO_UPDATE=1;
      brew install flex bison eigen libomp;
      brew link --force flex bison;
    fi

  # Checkout Birch, which may be cached, and (re)build
  - git clone "https://github.com/lawmurray/Birch.git" || cd .
  - cd Birch && git pull && git checkout master && cd ..
  - cd Birch && ./autogen.sh && ./configure && make -j 2 && sudo make install && cd ..

  # Checkout Birch.Standard, which may be cached, and (re)build
  - git clone "https://github.com/lawmurray/Birch.Standard.git" || cd .
  - cd Birch.Standard && git pull && git checkout master && cd ..
  - cd Birch.Standard && birch build --enable-unity && sudo birch install --enable-unity && cd ..

install:
  - birch build --enable-unity && sudo birch install --enable-unity
script:
  - birch run
cache:
  directories:
    - Birch
    - Birch.Standard
```

This configuration file:

  * sets up both macOS and Ubuntu Linux build environments,
  * updates `gcc` and `Eigen` in the Ubuntu Linux build environment, and
  * includes caching of the Birch compiler and Birch standard library so that they are only recompiled when necessary.
