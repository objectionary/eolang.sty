#!/usr/bin/perl
# SPDX-FileCopyrightText: Copyright (c) 2021-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

use strict;
use warnings;

system('texlua', 'tests/build-test.lua') == 0
  or die "CTAN hook regression tests failed\n";
