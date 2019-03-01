package on::demand::_::test::subclass;

use strict;
use warnings;

# Well... No on::demand parents in production please...
# But it works (mostly accidentally) because
# AUTOLOAD uses can() for resolving the real method
# and will stumble upon overloaded can() in parent class
# which will load the parent and call can() on it
# loading the previous class and so on until the full hierarchy is loaded.
use on::demand "on::demand::_::test::sample";

our @ISA = qw( on::demand::_::test::sample );
our $VERSION = 3.14;

sub frobnicate {
    return 42;
};

1;
