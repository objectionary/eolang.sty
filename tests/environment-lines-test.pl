#!/usr/bin/perl
# SPDX-FileCopyrightText: Copyright (c) 2021-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

use strict;
use warnings;
use lib('tests');
use test_tools;
use File::Path qw(make_path);
use File::Temp qw(tempdir);
use Test::More;

for my $kind ('sodg', 'phiquation', 'phiquation*') {
  for my $newline ("\n", "\r\n") {
    for my $ending ('', $newline) {
      my $home = tempdir(CLEANUP => 1);
      my $cache = "$home/_eolang/main";
      make_path($cache);
      (my $suffix = $kind) =~ s/\*$//;
      my $body = "  a -> @\n  b -> c\n";
      savefile("$cache/equation-$suffix.tex", $body);
      $body =~ s/\n/$newline/g;
      savefile("$home/main.tex", "Before${newline}\\begin{$kind}${newline}" .
        $body . "\\end{$kind}$ending");
      is(system($^X, './eolang.pl', "$home/main.tex", "$home/output.tex"), 0,
        "$kind converter accepts line endings");
      is(readfile("$home/output.tex"), "Before${newline}\\input{$cache/equation-$suffix-post.tex}% '$kind' replaced\n\n",
        "$kind replaces the complete environment");
    }
  }
}

done_testing();
