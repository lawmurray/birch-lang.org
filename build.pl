#!/usr/bin/perl

open(MKDOCS, ">>mkdocs.yml");

print MKDOCS "  - 'Library':\n";
open(INPUT, "git/Birch.Standard/mkdocs.yml");
do {
  $line = <INPUT>;
} while ($line !~ /^pages:/);
while ($line = <INPUT>) {
  $line =~ s/^(\s+)- ('.+?': *)?([\w_\/]+\.\w+)$/  ${1}- ${2}library\/${3}/;
  $line =~ s/^(\s+)- ('.+?': *)$/  ${1}- ${2}/;
  print MKDOCS $line;
}
close INPUT;

print MKDOCS "  - 'Examples':\n";
open(INPUT, "git/Birch.Example/mkdocs.yml");
do {
  $line = <INPUT>;
} while ($line !~ /^pages:/);
while ($line = <INPUT>) {
  $line =~ s/^(\s+)- ('.+?': *)?([\w_\/]+\.\w+)$/  ${1}- ${2}examples\/${3}/;
  $line =~ s/^(\s+)- ('.+?': *)$/  ${1}- ${2}/;
  print MKDOCS $line;
}
close INPUT;

close MKDOCS;
