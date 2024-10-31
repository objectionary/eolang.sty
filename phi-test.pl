#!/usr/bin/perl
# (The MIT License)
#
# Copyright (c) 2021-2024 Yegor Bugayenko
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
use File::Temp qw/ tempdir /;
use File::Basename;
use File::Spec;

# Read file content.
sub readfile {
  my ($path) = @_;
  open(my $h, '<', $path) or die('Cannot open file: ' . $path);
  my $content; { local $/; $content = <$h>; }
  return $content;
}

# Save content to file.
sub savefile {
  my ($path, $content) = @_;
  open(my $f, '>', $path) or error('Cannot open file for writing: ' . $path);
  print $f $content;
  close($f);
}

# Checks whether rewritting happens for \phiq.
sub rewrites_phiq {
  my ($temp, $from, $to) = @_;
  my $src = $temp . '/foo.tex';
  savefile($src, $from);
  my $stdout = `perl '$temp/_eolang/article-phi.pl' phiq '$src' 2>&1`;
  if (index($stdout, $to) eq -1) {
    print "Didn't rewrite:\n";
    print "--- from: ---\n";
    print $from;
    print "\n--- expected: ---\n";
    print $to;
    print "\n--- received: ---\n";
    print $stdout;
    print "\n---\n";
    exit(1);
  }
  print "OK!\n\n";
}

my $temp = tempdir(CLEANUP => 1);
my $self = dirname(File::Spec->rel2abs($0));
print `cd '$temp' && cp '$self/eolang.ins' . && cp '$self/eolang.dtx' . && pdflatex eolang.ins 2>&1`;
my $article = $temp . '/article.tex';
savefile($article, '\documentclass{article}\usepackage{./eolang}\begin{document}\end{document}');
print `cd '$temp' && pdflatex -halt-on-error -shell-escape -interaction=batchmode article.tex 2>&1`;

rewrites_phiq($temp, 'a -> b', '\(a \mathbin{\mapsto} b\)');

print "SUCCESS\n";

1;