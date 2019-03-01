package on::demand;

use 5.008;
use strict;
use warnings;
our $VERSION = '0.01';

=head1 NAME

on::demand - postpone loading a module until it's actually used

=head1 SYNOPSIS

    use on::demand "My::Module";
    # My::Module has not been loaded

    my $var = My::Module->new;
    # My::Module is loaded now, and new() method is called

    no on::demand;
    # Force loading of all postponed modules

=head1 EXPORTED FUNCTIONS

None.

=head1 METHODS

=cut

use Carp;

=head2 import

When C<use on::demand "Some::Module";> is called,
the module in question is not loaded.
A stub package with the same name is created instead.

Should any method call be performed on the stub package,
it loads the original one and jumps to respective method.

Upon loading, C<import> is not called on the target package.
This MAY change in the future.

No extra options (except from target module name) are allowed.

=cut

my %seen;
sub import {
    my ($class, $target, @rest) = @_;

    croak "Usage: use on::demand 'Module::Name';"
        unless defined $target and @rest == 0;

    # return ASAP if already loaded by us or Perl itself
    return if $seen{$target};
    my $mod = $target;
    $mod =~ s,::,/,g;
    $mod .= ".pm";
    return if $INC{$mod};

    croak "Bad module name '$target'"
        unless $target =~ /^[A-Za-z_][A-Za-z_0-9]*(?:::[A-Za-z_0-9]+)*$/;

    $seen{$target} = $mod;

    our $AUTOLOAD;
    _set_function( $target, AUTOLOAD => sub {
        _load( $target );
        my $jump = _jump( $target, $AUTOLOAD );
        goto $jump;
    } );
};

=head2 unimport

Calling C<no on::demand;> or, alternatively, C<on::demand-E<gt>unimport;>
will cause all postponed modules to be loaded immediately,
in alphabetical order.

This may be useful to avoid deferred errors and/or side effects
of module loading.

No extra options to unimport are supported.

=cut

sub unimport {
    my $class = shift;

    croak "usage: no on::demand;"
        if @_;

    # sort keys to ensure load order stability in case of bugs
    foreach (sort keys %seen) {
        _load($_);
    };
};

sub _load {
    my $target = shift;

    my $mod = delete $seen{$target};
    croak "Module '$target' was never loaded via on::demand, that's possibly a bug"
        unless $mod;

    # reset added methods prior to loading
    _set_function( $target, AUTOLOAD => undef );
    _set_function( $target, DESTROY  => undef );

    package
        on::demand::_::quarantine;

    local $Carp::Internal{ __PACKAGE__ } = 1;
    require $mod;
    # TODO maybe import()
};

sub _jump {
    my ($target, $todo, $nodie) = @_;

    $todo =~ s/.*:://;
    my $jump = $target->can($todo);

    croak qq{Can't locate object method "$todo" via package "$target"}
        unless $jump or $nodie;

    return $jump;
};

sub _set_function {
    my ($target, $name, $code) = @_;

    if (ref $code) {
        no strict 'refs'; ## no critic
        *{ $target."::".$name } = $code;
    } else {
        no strict 'refs'; ## no critic
        delete ${ $target."::" }{ $name };
    };
};

=head1 AUTHOR

Konstantin S. Uvarin, C<< <khedin@cpan.org> >>

=head1 BUGS

Please report bugs via github or RT:

=over

=item * L<https://github.com/dallaylaen/on-demand-perl/issues>

=item * C<bug-assert-refute-t-deep at rt.cpan.org>

=item * L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=on-demand>

=back

=head1 SUPPORT

You can find documentation for this module with the C<perldoc> command.

    perldoc on::demand

You can also look for information at:

=over 4

=item * github: L<https://github.com/dallaylaen/on-demand-perl>

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=on-demand>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/on-demand>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/on-demand>

=item * Search CPAN

L<http://metacpan.org/pod/on::demand/>

=back

=head1 SEE ALSO

L<autouse> is another module with similar idea, however,
it does it for imported functions rather than methods.

=head1 ACKNOWLEDGEMENTS

=head1 LICENSE AND COPYRIGHT

Copyright 2019 Konstantin S. Uvarin.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

1; # End of on::demand
