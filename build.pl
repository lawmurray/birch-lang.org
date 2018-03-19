#!/usr/bin/perl

`mkdir -p git`;
if (!-e 'git/Birch.Standard') {
  `git clone https://github.com/lawmurray/Birch.Standard.git git/Birch.Standard`;
}
if (!-e 'git/Birch.Example') {
   `git clone https://github.com/lawmurray/Birch.Example.git git/Birch.Example`;
}

`cd git/Birch.Standard; git pull; birch docs; cd ../..`;
`cd git/Birch.Example; git pull; birch docs; cd ../..`;

`rm -rf docs/documentation/library docs/documentation/examples`;
`cp -r git/Birch.Standard/docs docs/documentation/library`;
`cp -r git/Birch.Example/docs docs/documentation/examples`;
`mv git/Birch.Standard/docs/index.md docs/documentation/library.md`;
`mv git/Birch.Example/docs/index.md docs/documentation/examples.md`;

`cp mkdocs.in mkdocs.yml`;

open(MKDOCS, ">>mkdocs.yml");

print MKDOCS "    - 'Library':\n";
open(INPUT, "git/Birch.Standard/mkdocs.yml");
do {
  $line = <INPUT>;
} while ($line !~ /^pages:/);
while ($line = <INPUT>) {
  $line =~ s/^(\s+)- ('.+?': *)?([\w_\/]+\.\w+)$/    ${1}- ${2}documentation\/library\/${3}/;
  $line =~ s/^(\s+)- ('.+?': *)$/    ${1}- ${2}/;
  $line =~ s/library\/index\.md/library.md/;
  print MKDOCS $line;
}
close INPUT;

print MKDOCS "    - 'Examples':\n";
open(INPUT, "git/Birch.Example/mkdocs.yml");
do {
  $line = <INPUT>;
} while ($line !~ /^pages:/);
while ($line = <INPUT>) {
  $line =~ s/^(\s+)- ('.+?': *)?([\w_\/]+\.\w+)$/    ${1}- ${2}documentation\/examples\/${3}/;
  $line =~ s/^(\s+)- ('.+?': *)$/    ${1}- ${2}/;
  $line =~ s/examples\/index\.md/examples.md/;
  print MKDOCS $line;
}
close INPUT;

close MKDOCS;
