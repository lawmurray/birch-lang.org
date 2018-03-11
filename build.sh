#!/bin/sh

mkdir -p git
git clone https://github.com/lawmurray/Birch.Standard.git git/Birch.Standard
git clone https://github.com/lawmurray/Birch.Example.git git/Birch.Example

cd git/Birch.Standard; birch docs; cd ../..
cd git/Birch.Example; birch docs; cd ../..

rm -rf docs/library docs/examples
cp -r git/Birch.Standard/docs docs/library
cp -r git/Birch.Example/docs docs/examples

cp mkdocs.in mkdocs.yml
./build.pl
