#!perl

use strict;
use warnings;
use Test::More;

use FindBin qw($Bin);
use lib "$Bin/lib";

use Module::Lazy "Module::Lazy::_::test::mro::top";

TODO: {
    $TODO = "don't know how to solve this";
    is( Module::Lazy::_::test::mro::top->frobnicate, "new--new", "diamond loading works" );

    # Now that everything loaded
    is( Module::Lazy::_::test::mro::top->frobnicate, "new--new", "diamond loading works" );
};

done_testing;
