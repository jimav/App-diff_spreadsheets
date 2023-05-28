#!/usr/bin/env perl
use FindBin qw($Bin);
use lib $Bin;
use t_Common qw/oops/; # strict, warnings, Carp
use t_TestCommon qw/bug run_perlscript/; # Test2::V0 etc.
# N.B. Can not use :silent because it breaks Capture::Tiny
use t_dsUtils qw/runtest $progname $progpath/;

my $tlib = "$Bin/../tlib";

use open ':std', IO => ':encoding(UTF-8)';

BEGIN {
  $ENV{COLUMNS} = 60;  # for fixed-width test ouput
}

# runtest($in1, $in2, $exp_out, $exp_err, $exp_exit, $desc)

runtest("$tlib/presidents.csv",
        "$tlib/presidents.csv",
        "", "", 0,
        "identical files -> no output");

runtest("$tlib/Addrlist.csv",
        "$tlib/Multisheet_AddrListSheet.csv",
        "", "", 0,
        "some other identical files -> no output");

runtest("$tlib/Addrlist.csv",
        "$tlib/presidents.csv",
        qr/./, "", 1,
        "Exit status 1 when diffs found");

runtest("$tlib/Addrlist.csv",
        "$tlib/Addrlist_mod1.csv",
        qr{^[\s\n]*\
---* Changed row 3 ---*
        CITY: '' →  'Philadelphia'

---* ADDED row 5 ---*
  FIRST NAME: 'Frederick'
   LAST NAME: 'Douglass'
    Address1: 'Mount Hope Cemetary'
    Address2: '1133 Mt Hope Ave'
        CITY: 'Rochester'
       STATE: 'NY'
         ZIP: '14620'
[\s\n]*$},
        "", 1,
          "Changed row and Added rows",
        "-m", "native"
       );

done_testing;

