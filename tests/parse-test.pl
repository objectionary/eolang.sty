#!/usr/bin/perl
# SPDX-FileCopyrightText: Copyright (c) 2021-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

package eolang;

use strict;
use warnings;
use lib('.');
use tools;
use File::Temp qw/ tempdir /;
use File::Basename;
use File::Spec;

# Checks whether file saving happens for \phiq.
sub saves_phiq {
  my ($temp, $from, $to) = @_;
  my $article = $temp . '/article.tex';
  savefile($article, '\documentclass{article}\usepackage{./eolang}\begin{document}$ ' . $from . ' $\end{document}');
  debug(`cd '$temp' && rm -rf _eolang 2>&1`);
  debug(`cd '$temp' && pdflatex -halt-on-error -shell-escape -interaction=batchmode article.tex 2>&1`);
  my $post = `find '$temp/_eolang' -name '**-post.tex' -print0 2>&1`;
  my $tex = readfile($post);
  if (index($tex, $to) eq -1) {
    error("Didn't save:\n");
    error("--- from: ---\n");
    error($from);
    error("\n--- expected: ---\n");
    error($to);
    error("\n--- received: ---\n");
    error($tex);
    error("\n---\n");
    exit(1);
  }
  info('OK!');
}

my $temp = tempdir(CLEANUP => 1);
my $self = dirname(dirname(File::Spec->rel2abs($0)));
debug(`cd '$temp' && cp '$self/eolang.ins' . && cp '$self/eolang.dtx' . && pdflatex eolang.ins 2>&1`);

saves_phiq($temp, 'a -> b', '\(a \mathbin{\mapsto} b\)');
saves_phiq($temp, 'a -> \textbf{b}', 'a \mathbin{\mapsto} \textbf {b}');
saves_phiq($temp, 'a -> \ccc', 'a \mathbin{\mapsto} \ccc');

info('SUCCESS');

1;
