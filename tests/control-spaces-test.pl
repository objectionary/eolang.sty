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

for my $space (' ', '   ', "\t", " \t ", "\n  ", "\r\n  ") {
  my $home = tempdir(CLEANUP => 1);
  my $cache = "$home/_eolang/main";
  make_path($cache);
  my $expression = '\\sin' . $space . 'x';
  savefile("$home/main.tex", '\\phiq{' . $expression . '} and $' . $expression . '$');
  savefile("$cache/inline-phiq.tex", '\\sin x');
  is(system($^X, './eolang.pl', "$home/main.tex", "$home/output.tex"), 0,
    'converter accepts whitespace after a control word');
  my $replacement = "\\input{$cache/inline-phiq-post.tex}";
  is(readfile("$home/output.tex"), "$replacement and $replacement",
    'both inline forms match the normalized fragment');
}

done_testing();
