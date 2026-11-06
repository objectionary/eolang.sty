#!/usr/bin/perl
# SPDX-FileCopyrightText: Copyright (c) 2021-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

use strict;
use warnings;
use lib('tests');
use test_tools;
use File::Copy qw(copy);
use File::Find qw(find);
use File::Spec;
use File::Temp qw(tempdir);
use Cwd qw(getcwd);
use Test::More;

my $root = getcwd();
for my $first (0, 1) {
  my $temp = tempdir(CLEANUP => 1);
  for my $file ('eolang.ins', 'eolang.dtx') {
    copy($file, File::Spec->catfile($temp, $file)) or die "Cannot copy $file: $!";
  }
  chdir($temp) or die "Cannot enter $temp: $!";
  system('pdflatex -halt-on-error -interaction=batchmode eolang.ins > unpack.out 2>&1') == 0
    or BAIL_OUT(readfile('unpack.out'));
  my %previous;
  my %variants;
  for my $option ($first, 1 - $first, 1 - $first, $first) {
    my $options = $option ? '[nocomments]' : '';
    savefile('article.tex', '\documentclass{article}' . "\n" .
      '\usepackage' . $options . '{eolang}' . "\n" . <<'TEX');
\begin{document}
\phiq{x -> y}
\begin{phiquation}
a -> b
\end{phiquation}
\begin{phiquation*}
c -> d
\end{phiquation*}
\begin{sodg}
v0
v1 xy:v0,1,1
v0->v1
\end{sodg}
\end{document}
TEX
    system('pdflatex -halt-on-error -shell-escape -interaction=batchmode article.tex > compile.out 2>&1') == 0
      or BAIL_OUT(readfile('compile.out') . readfile('article.log'));
    my %current;
    find(sub {
      $current{$File::Find::name} = readfile($_) if /-post\.tex\z/;
    }, '_eolang');
    my @fresh = grep { !exists $previous{$_} } keys %current;
    my $label = "starting with nocomments=$first, now nocomments=$option";
    if (!exists $variants{$option}) {
      is(scalar @fresh, 4, "$label: generate all four fragments");
      for my $path (sort @fresh) {
        if ($option) {
          unlike($current{$path}, qr/%/, "$label: $path has no comments");
        } else {
          like($current{$path}, qr/%/, "$label: $path retains comments");
        }
        like($current{$path}, qr/\\/, "$label: $path contains TeX");
      }
      $variants{$option} = 1;
    } else {
      is(scalar @fresh, 0, "$label: reuse existing cache");
      unlike(readfile('article.log'), qr/Start parsing|Parsed `phiq'/,
        "$label: do not run converters on cache hits");
    }
    for my $path (sort keys %previous) {
      is($current{$path}, $previous{$path}, "$label: preserve earlier fragment $path");
    }
    %previous = %current;
  }
  chdir($root) or die "Cannot return to $root: $!";
}
done_testing();
