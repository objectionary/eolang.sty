#!/usr/bin/perl
# SPDX-FileCopyrightText: Copyright (c) 2021-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

use strict;
use warnings;
use lib('tests');
use test_tools;
use File::Temp qw(tempdir);
use Test::More;

my $home = tempdir(CLEANUP => 1);
my $src = "$home/source.tex";
my $target = "$home/output.tex";
my $extra = "$home/extra.tex";
savefile($src, 'source');
savefile($extra, 'extra');
for my $options ([], ['--verbose', "--tmpdir=$home/cache"]) {
  savefile($target, 'sentinel');
  isnt(system($^X, './eolang.pl', @$options, $src, $target, $extra), 0,
    'extra positional arguments fail');
  is(readfile($target), 'sentinel', 'existing output remains intact');
  is(readfile($extra), 'extra', 'extra path remains intact');
  unlink($target) or die($!);
  isnt(system($^X, './eolang.pl', @$options, $src, $target, $extra), 0,
    'extra arguments fail with a new output');
  ok(!-e $target, 'no output is created');
  is(system($^X, './eolang.pl', @$options, $src, $target), 0,
    'exactly two paths succeed');
  is(readfile($target), 'source', 'valid invocation writes the output');
}
done_testing();
