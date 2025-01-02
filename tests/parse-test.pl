#!/usr/bin/perl
# (The MIT License)
#
# Copyright (c) 2021-2025 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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