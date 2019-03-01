#!perl

use strict;
use warnings;
use Test::More tests => 4;

use File::Basename qw(dirname);
use lib dirname(__FILE__)."/lib"; # t/lib

require on::demand;

on::demand->import( "on::demand::_::test::sample" );

is $on::demand::_::test::sample::VERSION, undef, "not loaded yet";

my $new = eval {
    on::demand::_::test::sample->new;
};
is $@, '', "no exception on new()";

is ref $new, "on::demand::_::test::sample", "new() worked";
is $on::demand::_::test::sample::VERSION, 42, "loaded module at this point";

