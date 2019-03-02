#!perl

use strict;
use warnings;
use Test::More;
use Test::Exception;
use FindBin qw($Bin);

use lib "$Bin/lib";
use on::demand "on::demand::_::test::subclass";

my $isa = on::demand::_::test::subclass->isa("on::demand::_::test::sample");

ok $isa, "isa correct";
is $on::demand::_::test::subclass::VERSION, 3.14, "subclass loaded";
is $on::demand::_::test::sample::VERSION, 42, "base class loaded";

done_testing;
