#!/usr/bin/perl
# SPDX-FileCopyrightText: Copyright (c) 2021-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

package eolang;

use strict;
use warnings;
use lib('tests');
use test_tools;
use File::Temp qw/ tempdir /;

# Checks whether replace happens for \phiq.
sub replaces_phiq {
  my ($doc, $phiq) = @_;
  my $home = tempdir(CLEANUP => 1);
  my $src = $home . '/main.tex';
  my $target = $home . '/new.tex';
  savefile($src, $doc);
  `mkdir -p $home/_eolang/main`;
  savefile($home . '/_eolang/main/A1B2C3-phiq.tex', $phiq);
  my $stdout = `perl ./eolang.pl '$src' '$target' 2>&1`;
  debug($stdout);
  my $after = readfile($target);
  if (index($after, '\\input') eq -1) {
    error("Didn't inject \\phiq:\n");
    error("---\n");
    error($after);
    error("\n---\n");
    exit(1);
  }
  info("OK!");
}

# Checks whether replace happens for \begin{phiquation}.
sub replaces_verbatim {
  my ($kind, $doc, $verbatim) = @_;
  my $home = tempdir(CLEANUP => 1);
  my $src = $home . '/main.tex';
  my $target = $home . '/new.tex';
  savefile($src, $doc);
  `mkdir -p $home/_eolang/main`;
  savefile($home . '/_eolang/main/A1B2C3-' . $kind . '.tex', $verbatim);
  my $stdout = `perl ./eolang.pl '$src' '$target' 2>&1`;
  debug($stdout);
  my $after = readfile($target);
  if (index($after, '\\input') eq -1) {
    error("Didn't replace \\begin{$kind}:\n");
    error("---\n");
    error($after);
    error("\n---\n");
    exit(1);
  }
  info("OK!");
}

replaces_phiq('Hello, $@$!', '@');
replaces_phiq('Hello, $y_2$!', 'y_2');
replaces_phiq('Hello, $P\'$!', 'P\'');
replaces_phiq('Hello, $@$ and $^$!', '^');
replaces_phiq('Hello, $abc -> @  $!', '  abc -> @ ');
replaces_phiq('Hello, $[[]]$!', '[[]] ');
replaces_phiq('Hello, $\\a -> b$!', '\\a -> b');
replaces_phiq('Hello, $[\\ccc]$', '[\\ccc]');
replaces_phiq('Hello, $-> []$!', ' -> [] ');
replaces_phiq('Hello, \\phiq  {  [[ \alpha-> ]] }!', '  [[ \alpha -> ]] ');
replaces_phiq('Hello, \\phiq{  abc -> $}!', '  abc -> $ ');
replaces_phiq('Hello, \\phiq{ abc -> @, \\alpha -> []}!', 'abc -> @, \\alpha -> []');

replaces_verbatim('phiquation', "Hello, \n\\begin{phiquation}\n  a -> \@\n\\end{phiquation}\n", "  a -> \@\n");
replaces_verbatim('sodg', "Hello, \n\\begin{sodg}\nv1\nv2\n  v3\n\\end{sodg}\n", "v1\nv2\n  v3\n");

print "SUCCESS\n";

1;
