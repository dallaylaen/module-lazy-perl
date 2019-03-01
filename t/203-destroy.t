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
is $on::demand::_::test::sample::alive, -1, "1 object destroyed";

# this is more of a self test - check that alive counter actually works
# while module is fully loaded
my $item = on::demand::_::test::sample->new;
is $on::demand::_::test::sample::alive, 0, "1 object created";

undef $item;
is $on::demand::_::test::sample::alive, -1, "1 object destroyed";

done_testing;
