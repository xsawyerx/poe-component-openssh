package POE::Component::OpenSSH;

use strict;
use warnings;

our $VERSION = '0.01';

use Moose;
use Net::OpenSSH;
use POE::Component::Generic;

has 'args'    => ( is => 'ro', isa => 'ArrayRef', default => sub { [] } );
has 'options' => ( is => 'ro', isa => 'HashRef',  default => sub { {} } );
has 'alias'   => ( is => 'ro', isa => 'Str',      default => ''         );
has 'debug'   => ( is => 'ro', isa => 'Bool',     default => 0          );
has 'verbose' => ( is => 'ro', isa => 'Bool',     default => 0          );

has 'obj' => (
    is         => 'rw',
    isa        => 'POE::Component::Generic',
    lazy_build => 1,
);

sub _build_obj {
    my $self = shift;

    my @optional = ( qw( alias debug verbose options ) );
    my $obj  = POE::Component::Generic->spawn(
        package => 'Net::OpenSSH',
        object_options => $self->args,
    );

    $self->obj($obj);
}

1;

__END__

=head1 NAME

POE::Component::OpenSSH - Nonblocking SSH Component for POE using Net::OpenSSH

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Need nonblocking SSH? You like Net::OpenSSH? Try out this stuff right here.

    use POE::Component::OpenSSH;

    my $ssh = POE::Component::OpenSSH->new( args => [ $host, user => $user ] );

    # perhaps using verbose, debug?
    my $ssh = POE::Component::OpenSSH->new(
        args    => [ $host, user => 'root', passwd => $pass ],
        verbose => 1, # turns on POE::Component::Generic verbose
        debug   => 1, # turns on POE::Component::Generic debug
    );

    # now set up events
    $ssh->
    ...

=head1 DESCRIPTION

This module allows you to use SSH (via L<Net::OpenSSH>) in a nonblocking manner.

I kept having to write this small thing each time I needed nonblocking SSH in a project. I got tired of it so I wrote this instead.

Why put the args in an "args" attribute instead of straight away attributes? Because Net::OpenSSH has a lot of options and they may collide with POE::Component::Generic's options, and I don't feel like maintaining the mess.

It's on Github so you can patch it up if you want (I accept patches... and foodstamps).

=head1 AUTHOR

Sawyer X, C<< <xsawyerx at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-poe-component-openssh at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=POE-Component-OpenSSH>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

Also available is the Github's issue tracker at L<http://github.com/xsawyerx/poe-component-openssh/issues>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc POE::Component::OpenSSH

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=POE-Component-OpenSSH>

=item * Github issue tracker

L<http://github.com/xsawyerx/poe-component-openssh/issues>

=item * Github page

L<http://github.com/xsawyerx/poe-component-openssh/tree/master>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/POE-Component-OpenSSH>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/POE-Component-OpenSSH>

=item * Search CPAN

L<http://search.cpan.org/dist/POE-Component-OpenSSH/>

=back

=head1 DEPENDENCIES

L<Net::OpenSSH>

L<POE>

L<POE::Component::Generic>

L<Moose>

L<MooseX::POE>

=head1 ACKNOWLEDGEMENTS

All the people involved in the aforementioned projects.

=head1 COPYRIGHT & LICENSE

Copyright 2009 Sawyer X, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

