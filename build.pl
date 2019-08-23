#!/usr/bin/perl

`mkdir -p git`;
if (!-e 'git/Birch.Standard') {
  `git clone https://github.com/lawmurray/Birch.Standard.git git/Birch.Standard`;
}
`cd git/Birch.Standard; git pull; birch docs; doxygen; cd ../..`;

`rm -rf docs/documentation/library`;
`cp -r git/Birch.Standard/docs docs/documentation/library`;
`rm -rf docs/documentation/libbirch`;
`cp -r git/Birch.Standard/docs/libbirch/html docs/documentation/libbirch`;

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
