#!perl

use strict;
use warnings;
use Test::More;
use Test::Exception;
use FindBin qw($Bin);

use lib "$Bin/lib";
use on::demand "on::demand::_::test::subclass";

my $item;
lives_ok {
    $item = on::demand::_::test::subclass->new;
} "inherited method acts as expected";

lives_ok {
    is( $item->frobnicate, 42, "subclass actually loaded" );
} "frobnicate lives";
is $on::demand::_::test::sample::alive, 1, "parent new() called";

undef $item;
is $on::demand::_::test::sample::alive, 0, "parent DESTROY() called";

done_testing;
