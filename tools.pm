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

package tools;

use strict;
use warnings;
use Exporter;

our @ISA = qw( Exporter );
our @EXPORT = qw( readfile savefile info debug error );

# Read file content.
sub readfile {
  my ($path) = @_;
  open(my $h, '<', $path) or die('Cannot read from file: ' . $path);
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

# Hash of incoming command line arguments.
my %args = map { $_ => 1 } @ARGV;

# Print INFO message to the console.
sub info {
  my ($txt) = @_;
  print $txt . "\n";
}

# Print DEBUG message to the console.
sub debug {
  my ($txt) = @_;
  if (exists $args{'--verbose'}) {
    print $txt . "\n";
  }
}

# Print ERROR message to the console.
sub error {
  my ($txt) = @_;
  print STDERR $txt . "\n";
}

1;
