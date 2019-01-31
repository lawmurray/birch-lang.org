# How to use Birch with Travis CI for continuous integration

[Travis CI](https://www.travis-ci.com) is one of many continuous-integration services that work alongside code repository services to run tests whenever new commits are made to a code repository. Other continuous-integration services include [CircleCI](https://www.circleci.com) and [Bitrise](https://www.bitrise.io). Software for continuous integration includes [Jenkins](https://jenkins.io/).

Travis CI happens to be used by the Birch development team. Setting it up was not entirely trivial; this page explains how it was done in case others wish to use Travis CI for their Birch projects.

The main issue is that the Linux image used by Travis CI is based on Ubuntu 14.04, which is now several years old. The default `gcc` provided with this distribution does not support the C++14 language features required by Birch. Furthermore, the version of Eigen provided with this distribution requires updating for Birch.

After signing up for the Travis CI service, you will need to add a `.travis.yml` file to your code repository to configure the continuous-integration service. Follow the Travis CI documentation for details, but a suggested template for Birch projects is as follows:

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

Anecdotally, for [Birch.Example](http://www.github.com/lawmurray/Birch.Example) we are observing that tests take about 6-8 minutes for each macOS and Ubuntu Linux instances, reducing to about 3-5 minutes when the Birch compiler and Birch standard library do not need to be recompiled. The `--enable-unity` option is particularly important to speed up the build time on Ubuntu Linux instances, which otherwise take twice as long.
