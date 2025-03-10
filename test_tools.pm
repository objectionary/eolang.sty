#!/usr/bin/perl

# SPDX-FileCopyrightText: Copyright (c) 2021-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

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
  print $txt . "\n";
}

# Print ERROR message to the console.
sub error {
  my ($txt) = @_;
  print STDERR $txt . "\n";
}

1;
