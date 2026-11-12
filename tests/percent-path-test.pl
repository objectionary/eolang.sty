#!/usr/bin/perl
# SPDX-FileCopyrightText: Copyright (c) 2021-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

use strict;
use warnings;
use lib('tests');
use test_tools;
use Cwd qw(getcwd);
use File::Path qw(make_path);
use File::Temp qw(tempdir);
use File::Spec;
use Test::More;

my $cwd = getcwd();
my $script = File::Spec->rel2abs('eolang.pl');
for my $custom (0, 1) {
  my $home = tempdir(CLEANUP => 1);
  my $source = "$home/docs%one";
  my $root = $custom ? "$home/cache%two" : "$source/_eolang";
  my $cache = "$root/main";
  make_path($source, $cache);
  my $doc = "\\documentclass{article}\n\\begin{document}\n\\phiq{answer}\n";
  savefile("$cache/inline-phiq.tex", 'answer');
  savefile("$cache/inline-phiq-post.tex", "Inline% \\undefinedIfCommentCatcodeChanged\ntext\n");
  for my $kind ('sodg', 'phiquation', 'phiquation*') {
    (my $suffix = $kind) =~ s/\*$//;
    my $id = $kind eq 'phiquation*' ? 'starred' : $kind;
    savefile("$cache/$id-$suffix.tex", "$id\n");
    savefile("$cache/$id-$suffix-post.tex", "Block% \\undefinedIfCommentCatcodeChanged\ntext\n");
    $doc .= "\\begin{$kind}\n$id\n\\end{$kind}\n";
  }
  $doc .= "\\end{document}\n";
  savefile("$source/main.tex", $doc);
  my @options = $custom ? ("--tmpdir=$root") : ();
  is(system($^X, $script, @options, "$source/main.tex", "$home/output.tex"), 0,
    'converter accepts percent signs in fragment paths');
  chdir($home) or die("Cannot enter $home");
  open(my $pdf, '-|', 'pdflatex', '-interaction=nonstopmode', '-halt-on-error', 'output.tex')
    or die('Cannot run pdflatex');
  my $output = do { local $/; <$pdf> };
  close($pdf);
  my $status = $?;
  is($status, 0, 'generated inputs compile with normal catcodes in the included files');
  diag($output) if $status != 0;
  ok(-s 'output.pdf', 'compiled document is nonempty');
  chdir($cwd) or die("Cannot return to $cwd");
}

done_testing();
