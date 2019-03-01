#!perl

use strict;
use warnings;
use Test::More;
use Test::Exception;
use FindBin qw($Bin);

use lib "$Bin/lib";
use on::demand "on::demand::_::test::sample";

my $code = on::demand::_::test::sample->can("new");

is ref $code, 'CODE', "can new";
is $on::demand::_::test::sample::VERSION, 42, "module loaded after can";

is( on::demand::_::test::sample->can("can"), UNIVERSAL->can("can")
    , "can() was reset to normal");

done_testing;
