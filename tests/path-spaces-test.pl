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

for my $custom (0, 1) {
  for my $space (' ', "\t") {
    my $home = tempdir(CLEANUP => 1);
    my $dir = "$home/docs${space}with${space}space";
    my $job = "main${space}file";
    my $root = $custom ? "$home/custom${space}cache" : "$dir/_eolang";
    my $cache = "$root/$job";
    make_path($dir, $cache);
    my $doc = "Before\n\\phiq{answer}\n";
    my $expected = "Before\n\\input{$cache/inline-phiq-post.tex}\n";
    savefile("$cache/inline-phiq.tex", 'answer');
    savefile("$cache/inline-phiq-post.tex", 'converted inline');
    for my $kind ('sodg', 'phiquation', 'phiquation*') {
      (my $suffix = $kind) =~ s/\*$//;
      my $id = $kind eq 'phiquation*' ? 'starred' : $kind;
      my $fragment = "$id fragment\n";
      savefile("$cache/$id-$suffix.tex", $fragment);
      savefile("$cache/$id-$suffix-post.tex", "converted $id");
      $doc .= "\\begin{$kind}\n$fragment\\end{$kind}\n";
      $expected .= "\\input{$cache/$id-$suffix-post.tex}% '$kind' replaced\n\n";
    }
    $doc .= "After\n";
    $expected .= "After\n";
    my $src = "$dir/$job.tex";
    my $target = "$dir/output${space}file.tex";
    savefile($src, $doc);
    my @options = $custom ? ("--tmpdir=$root") : ();
    my $label = ($custom ? 'custom' : 'default') . ' cache, ' .
      ($space eq ' ' ? 'spaces' : 'tabs');
    is(system($^X, './eolang.pl', @options, $src, $target), 0, "$label: converter succeeds");
    is(-f $target ? readfile($target) : '', $expected, "$label: all four fragment kinds replaced exactly");
  }
}
done_testing();
