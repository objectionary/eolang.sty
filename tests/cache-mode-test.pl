#!/usr/bin/perl
# SPDX-FileCopyrightText: Copyright (c) 2021-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

use strict;
use warnings;
use lib('tests');
use test_tools;
use File::Copy qw(copy);
use File::Spec;
use File::Temp qw(tempdir);
use Cwd qw(getcwd);
use Test::More;

my $root = getcwd();
for my $first ('phiquation', 'phiquation*') {
  my $temp = tempdir(CLEANUP => 1);
  for my $file ('eolang.ins', 'eolang.dtx') {
    copy($file, File::Spec->catfile($temp, $file)) or die "Cannot copy $file: $!";
  }
  chdir($temp) or die "Cannot enter $temp: $!";
  system('pdflatex -halt-on-error -interaction=batchmode eolang.ins > unpack.out 2>&1') == 0
    or BAIL_OUT(readfile('unpack.out'));
  my $second = $first eq 'phiquation' ? 'phiquation*' : 'phiquation';
  for my $entry (['first', $first], ['second', $second]) {
    my ($file, $mode) = @$entry;
    savefile("$file.tex", "\\begin{$mode}\nx -> y\n\\end{$mode}\n");
  }
  savefile('article.tex', <<'TEX');
\documentclass{article}
\usepackage{eolang}
\begin{document}
\input{first.tex}
\input{second.tex}
\typeout{MODE-COUNT=\arabic{equation}}
\end{document}
TEX
  for my $run (1, 2) {
    system('pdflatex -halt-on-error -shell-escape -interaction=batchmode article.tex > compile.out 2>&1') == 0
      or BAIL_OUT(readfile('compile.out') . readfile('article.log'));
    my $log = readfile('article.log');
    my ($count) = $log =~ /MODE-COUNT=(\d+)/;
    is($count, 1, "starting with $first, run $run: number only the unstarred equation");
    my @files = glob('_eolang/article/*-phiquation-post.tex');
    is(scalar @files, 2, "starting with $first, run $run: keep separate mode fragments");
    if ($run == 2) {
      unlike($log, qr/Start parsing 'phi'/, "starting with $first: reuse both cached modes");
    }
  }
  chdir($root) or die "Cannot return to $root: $!";
}
done_testing();
