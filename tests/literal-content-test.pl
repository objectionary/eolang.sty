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

my $home = tempdir(CLEANUP => 1);
my $cache = "$home/_eolang/main";
make_path($cache);
savefile("$cache/inline-phiq.tex", 'answer');
savefile("$cache/block-phiquation.tex", "answer\n");
my $inline = '\\phiq{answer} and $answer$';
my $block = "\\begin{phiquation}\nanswer\n\\end{phiquation}\n";
my $literal = '';
for my $kind ('verbatim', 'verbatim*', 'Verbatim', 'BVerbatim', 'LVerbatim',
    'SaveVerbatim', 'lstlisting', 'minted') {
  my $argument = $kind eq 'minted' ? '{tex}' : $kind eq 'SaveVerbatim' ? '{example}' : '';
  $literal .= "\\begin{$kind}$argument\n$inline\n$block\\end{$kind}\n";
}
$literal .= '\\verb|' . $inline . '| and \\verb*+' . $inline . "+\n";
$literal .= "% $inline\n";
my $source = "$literal\n$inline\n$block";
savefile("$home/main.tex", $source);
is(system($^X, './eolang.pl', "$home/main.tex", "$home/output.tex"), 0,
  'converter succeeds with literal examples');
my $replacement = "\\input{$cache/inline-phiq-post.tex}";
is(readfile("$home/output.tex"), "$literal\n$replacement and $replacement\n" .
  "\\input{$cache/block-phiquation-post.tex}% 'phiquation' replaced\n\n",
  'literal examples remain intact while actual formulas are replaced');

savefile("$home/main.tex", "% \\begin{verbatim}\n$inline\n" .
  '\\%' . $inline . "\n" . '\\\\%' . $inline . "\n");
is(system($^X, './eolang.pl', "$home/main.tex", "$home/output.tex"), 0,
  'converter succeeds with comment delimiters');
is(readfile("$home/output.tex"), "% \\begin{verbatim}\n$replacement and $replacement\n" .
  '\\%' . "$replacement and $replacement\n" . '\\\\%' . "$inline\n",
  'commented environment markers and escaped percent signs are distinguished');

for my $slashes (2, 3) {
  my $prefix = '\\' x $slashes;
  my $before = $prefix . 'verb|' . $inline . "|\n" .
    $prefix . "begin{verbatim}\n$inline\n\\end{verbatim}\n";
  savefile("$home/main.tex", $before);
  is(system($^X, './eolang.pl', "$home/main.tex", "$home/output.tex"), 0,
    'converter accepts escaped backslashes');
  my $expected = $before;
  if ($slashes == 2) {
    $expected = $prefix . "verb|$replacement and $replacement|\n" .
      $prefix . "begin{verbatim}\n$replacement and $replacement\n\\end{verbatim}\n";
  }
  is(readfile("$home/output.tex"), $expected,
    'only an unescaped command starts literal content');
}

done_testing();
