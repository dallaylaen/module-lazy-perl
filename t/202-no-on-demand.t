#!perl

use strict;
use warnings;
use Test::More tests => 2;

use File::Basename qw(dirname);
use lib dirname(__FILE__)."/lib"; # t/lib

require on::demand;

on::demand->import( "on::demand::_::test::sample" );
is $on::demand::_::test::sample::VERSION, undef, "module not loaded yet";

on::demand->unimport;
is $on::demand::_::test::sample::VERSION, 42, "module loaded now";



