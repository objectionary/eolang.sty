#!/usr/bin/perl
# (The MIT License)
#
# Copyright (c) 2022-2024 Yegor Bugayenko
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

my $home = tempdir(CLEANUP => 1);

my $src = $home . '/main.tex';
my $target = $home . '/new.tex';

print `echo 'Hello, \\\\phiq{ abc -> \@, \\\\alpha -> []}!' > '$src'`;
print `mkdir -p $home/_eolang/main`;
print `echo 'abc -> \@, \\\\alpha -> []' > '$home/_eolang/main/A1B2C3-phiq.tex'`;
my $post = '\\(|abc| \\to \\varphi\\)';
print `echo '\\\\(|abc| \\\\to \\\\varphi\\\\)' > '$home/_eolang/main/A1B2C3-phiq-post.tex'`;
# print `tree '$home'`;
# print `cat '$src'`;
# print `cat '$home/_eolang/main/A1B2C3-phiq.tex'`;
# print `cat '$home/_eolang/main/A1B2C3-phiq-post.tex'`;

my $stdout = `perl ./eolang.pl '$src' '$target' 2>&1`;
print $stdout;

open(my $in, '<', $target) or die('No target file');
my $after; { local $/; $after = <$in>; }
close($in);

if (index($after, '\\(|abc| \\to \\varphi\\)') == -1) {
  print "Didn't inject \\phiq:\n";
  print "---\n";
  print $after;
  print "\n---\n";
  exit 1;
}

print `cat '$target'`;

print "SUCCESS\n";

1;