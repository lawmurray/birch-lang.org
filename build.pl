#!/usr/bin/perl

`rm -rf git`;
`git clone --depth 1 https://github.com/lawmurray/Birch.git git/Birch`;
`git clone --depth 1 https://github.com/lawmurray/Birch.Standard.git git/Birch.Standard`;

`cd git/Birch; doxygen; cd ../..`;
`cd git/Birch.Standard; birch docs; doxygen; cd ../..`;

`rm -rf docs/documentation/library`;
`cp -r git/Birch.Standard/docs docs/documentation/library`;

`rm -rf docs/development/libbirch`;
`cp -r git/Birch.Standard/docs/libbirch/html docs/development/libbirch`;

`rm -rf docs/development/birch`;
`cp -r git/Birch/docs/html docs/development/birch`;

`cp mkdocs.start mkdocs.yml`;
open(MKDOCS, ">>mkdocs.yml");
print MKDOCS "    - 'Library':\n";
open(INPUT, "git/Birch.Standard/mkdocs.yml");
do {
  $line = <INPUT>;
} while ($line && $line !~ /^nav:/);
while ($line = <INPUT>) {
  $line =~ s/^(\s+)- ('.+?': *)?([\w_\/]+\.\w+)$/    ${1}- ${2}documentation\/library\/${3}/;
  $line =~ s/^(\s+)- ('.+?': *)$/    ${1}- ${2}/;
  print MKDOCS $line;
}
close INPUT;
close MKDOCS;

`cat mkdocs.end >> mkdocs.yml`;
