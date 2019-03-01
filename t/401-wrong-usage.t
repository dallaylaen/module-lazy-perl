#!perl

use strict;
use warnings;
use Test::More;
use Test::Exception;

require on::demand; # no use!

throws_ok {
    on::demand->import;
} qr/[Uu]sage.*on::demand.*Module::Name/, "No empty usage";

throws_ok {
    on::demand->import(foo => 42);
} qr/[Uu]sage.*on::demand.*Module::Name/, "No extra arguments";

done_testing;
