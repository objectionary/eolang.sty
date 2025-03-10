#!/usr/bin/perl
# SPDX-FileCopyrightText: Copyright (c) 2021-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

package eolang;

use strict;
use warnings;
use lib('.');
use test_tools;
use File::Temp qw/ tempdir /;
use File::Basename;
use File::Spec;

# Checks whether rewritting happens for \phiq.
sub rewrites_phiq {
  my ($temp, $from, $to) = @_;
  my $src = $temp . '/foo.tex';
  savefile($src, $from);
  my $stdout = `perl '$temp/_eolang/article-phi.pl' phiq '$src' 2>&1`;
  if (index($stdout, $to) eq -1) {
    error("Didn't rewrite:\n");
    error("--- from: ---\n");
    error($from);
    error("\n--- expected: ---\n");
    error($to);
    error("\n--- received: ---\n");
    error($stdout);
    error("\n---\n");
    exit(1);
  }
  info('OK!');
}

my $temp = tempdir(CLEANUP => 1);
my $self = dirname(dirname(File::Spec->rel2abs($0)));
debug(`cd '$temp' && cp '$self/eolang.ins' . && cp '$self/eolang.dtx' . && pdflatex eolang.ins 2>&1`);
my $article = $temp . '/article.tex';
savefile($article, '\documentclass{article}\usepackage{./eolang}\begin{document}\end{document}');
debug(`cd '$temp' && pdflatex -halt-on-error -shell-escape -interaction=batchmode article.tex 2>&1`);

rewrites_phiq($temp, 'a -> b', '\(a \mathbin{\mapsto} b\)');
rewrites_phiq($temp, 'a -> \textbf{b}', 'a \mathbin{\mapsto} \textbf{b}');
rewrites_phiq($temp, '|a| -> b', '\textnormal{\texttt{a}}{} \mathbin{\mapsto} b');
rewrites_phiq($temp, '[\ccc]', '[\ccc]');

info('SUCCESS');

1;
