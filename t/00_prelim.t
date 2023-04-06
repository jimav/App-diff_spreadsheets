#!/usr/bin/env perl
use FindBin qw($Bin);
use lib $Bin;
use t_Common qw/oops/; # strict, warnings, Carp
use t_TestCommon qw/bug/; # Test::More etc.
# N.B. Can not use :silent because it breaks Capture::Tiny

use Capture::Tiny qw/capture/;

my $progname = "diff_spreadsheets";
my $progpath = "$Bin/../bin/$progname";

# Allow the program to find lib/App/diff_spreadsheets.pm during casual
# testing with perl -Ilib t/...
$ENV{PERL5LIB} = join(':',$ENV{PERL5LIB},@INC);

note "## progpath=$progpath";

ok(-x $progpath, "Found the script");

{ my ($out, $err, $wstat) = capture{ system $progpath };

  ok($out eq "", "$progname sans args -> silent on stdout but...")
    &&
  like($err, qr/Usage/, "$progname sans args -> Usage on stderr")
    || diag dvis '\n  $out\n  $err\n  ', sprintf("  wstat=%04x\n", $wstat);
}

{ my ($out, $err, $wstat) = capture{ system $progpath, "-h" };

  like($out, qr/NAME.*SYNOPSIS.*OPTIONS/s, 
       "$progname -h => Extended help on stdout")
    || diag dvis '\n  $out\n  $err\n  ', sprintf("  wstat=%04x\n", $wstat);

  ok($err eq "", "$progname -h => nothing on stderr")
    || diag dvis '\n  $out\n  $err\n  ', sprintf("  wstat=%04x\n", $wstat);
}

done_testing;

