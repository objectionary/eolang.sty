#!/usr/bin/perl
# SPDX-FileCopyrightText: Copyright (c) 2021-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

use strict;
use warnings;
use File::Temp qw(tempdir);
use IPC::Open3;
use Symbol qw(gensym);
use Test::More;

my $home = tempdir(CLEANUP => 1);
my $src = "$home/source.tex";
for my $case (["$home/missing/output.tex", 10], ['/dev/full', 10], ['/dev/full', 100_000]) {
  my ($target, $size) = @$case;
  SKIP: {
    skip '/dev/full is unavailable', 3 if $target eq '/dev/full' && !-c $target;
    open(my $input, '>', $src) or die($!);
    print {$input} 'x' x $size;
    close($input) or die($!);
    my $errors = gensym();
    my $pid = open3(undef, my $output, $errors, $^X, './eolang.pl', $src, $target);
    my $message = do { local $/; <$errors> };
    waitpid($pid, 0);
    isnt($?, 0, "$target ($size bytes) fails");
    like($message, qr/\Q$target\E/, 'diagnostic names the output path');
    unlike($message, qr/closed filehandle/, 'does not continue after an open failure');
  }
}
done_testing();
