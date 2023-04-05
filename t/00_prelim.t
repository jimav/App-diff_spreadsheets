#!/usr/bin/env perl
use FindBin qw($Bin);
use lib $Bin;
use t_Setup qw/:silent/; # strict, warnings, Test::More, Carp etc.
use t_Utils qw/oops bug check checkeq_literal/;
use Capture::Tiny qw/capture/;

#my $tlibdir = "$Bin/../tlib";

my $progname = "diff_spreadsheets";
my $progpath = "$Bin/../bin/$progname";

ok(-x $progpath, "Found the script");

{ my ($out, $err, $exit) = capture{ system $progpath };
  ok($out eq "", "$progname sans args -> nothing on stdout");
  like($err, qr/Usage/, "$progname sans args -> Usage on stderr");
}

{ my ($out, $err, $exit) = capture{ system $progpath, "-h" };
  like($out, qr/NAME.*SYNOPSIS.*OPTIONS/s, 
       "$progname -h => Extended help on stdout");
  ok($err eq "", "$progname -h => nothing on stderr");
}

done_testing;

