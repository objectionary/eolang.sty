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
for my $save (0, 1) {
  my $temp = tempdir(CLEANUP => 1);
  for my $file ('eolang.ins', 'eolang.dtx') {
    copy($file, File::Spec->catfile($temp, $file)) or die "Cannot copy $file: $!";
  }
  chdir($temp) or die "Cannot enter $temp: $!";
  system('pdflatex -halt-on-error -interaction=batchmode eolang.ins > unpack.out 2>&1') == 0
    or BAIL_OUT(readfile('unpack.out'));
  my $source = <<'TEX';
\documentclass{article}
\usepackage[nocomments]{eolang}
\begin{document}
\phiq{\text{100\%}+\text{50\%}}
SAVE_PHI
\begin{phiquation}
\text{100\%}+\text{50\%} % discard this comment
\end{phiquation}
SAVE_STAR
\begin{phiquation*}
\text{100\%}+\text{50\%}
\end{phiquation*}
SAVE_SODG
\begin{sodg}
v0
v1 xy:v0,1,1
v0->v1 a:\text{100\%}+\text{50\%}
\end{sodg}
\end{document}
TEX
  $source =~ s/SAVE_PHI/$save ? '\\phiSaveTo{phi.tex}' : ''/e;
  $source =~ s/SAVE_STAR/$save ? '\\phiSaveTo{star.tex}' : ''/e;
  $source =~ s/SAVE_SODG/$save ? '\\sodgSaveTo{graph.tex}' : ''/e;
  savefile('article.tex', $source);
  for my $warm (0, 1) {
    my $label = "save=$save, warm=$warm";
    my $status = system('pdflatex -halt-on-error -shell-escape -interaction=batchmode article.tex > compile.out 2>&1');
    ok($status == 0, "$label: document compiles") or diag(readfile('compile.out'));
    my @posts;
    find(sub { push @posts, $File::Find::name if /-post\.tex\z/ }, '_eolang');
    is(scalar @posts, 4, "$label: all fragment types generated");
    for my $path (sort @posts) {
      my $text = readfile($path);
      like($text, qr/\\text\s*\{100\\%\}.*\\text\s*\{50\\%\}/s,
        "$label: $path preserves percent signs and following text");
      unlike($text, qr/(?<!\\)%/, "$label: $path has no TeX comments");
    }
    if ($save) {
      for my $path ('phi.tex', 'star.tex', 'graph.tex') {
        ok(-f $path, "$label: $path saved");
        like(readfile($path), qr/\\text\s*\{100\\%\}.*\\text\s*\{50\\%\}/s,
          "$label: $path preserves percent signs") if -f $path;
      }
    }
    last if $status != 0;
    unlike(readfile('article.log'), qr/Start parsing|Parsed `phiq'/,
      "$label: converters are not rerun") if $warm;
  }
  chdir($root) or die "Cannot return to $root: $!";
}
done_testing();
