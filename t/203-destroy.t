#!perl

use strict;
use warnings;
use Test::More;
use Test::Exception;
use FindBin qw($Bin);

use on::demand "on::demand::_::test::sample";

push @INC, "$Bin/lib";

my $foo = bless {}, "on::demand::_::test::sample";
is $on::demand::_::test::sample::VERSION, undef, "module not loaded";

lives_ok {
    undef $foo;
} "destroy has no error";

is $on::demand::_::test::sample::VERSION, 42, "module loaded after destroy";

done_testing;
