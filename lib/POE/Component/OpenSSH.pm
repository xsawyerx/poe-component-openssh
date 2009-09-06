package POE::Component::OpenSSH;

use strict;
use warnings;

our $VERSION = '0.02';

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
        alias          => $self->alias,
        package        => 'Net::OpenSSH',
        object_options => $self->args,
        debug          => $self->debug,
        verbose        => $self->verbose,
    );

    $self->obj($obj);
}

1;

__END__

=head1 NAME

POE::Component::OpenSSH - Nonblocking SSH Component for POE using Net::OpenSSH

=head1 VERSION

Version 0.02

=head1 SYNOPSIS

Need nonblocking SSH? You like Net::OpenSSH? Try out this stuff right here.

    use POE::Component::OpenSSH;

    my $ssh = POE::Component::OpenSSH->new( args => [ $host, user => $user ] );

    # perhaps using verbose, debug?
    my $ssh = POE::Component::OpenSSH->new(
        args    => [ ''root@host', passwd => $pass ],
        verbose => 1, # turns on POE::Component::Generic verbose
        debug   => 1, # turns on POE::Component::Generic debug
    );
    ...

Here is an example using L<MooseX::POE>. If you know POE::Session, you can use that too:

    package Runner;

    use MooseX::POE;

    has 'host' => ( is => 'ro', isa => 'Str', default => 'localhost' );
    has 'user' => ( is => 'ro', isa => 'Str', default => 'root'      );
    has 'pass' => ( is => 'ro', isa => 'Str', default => 'psss'      );
    has 'cmd'  => ( is => 'ro', isa => 'Str', default => 'w'         );

    sub START {
        my $self = $_[OBJECT];
        my $ssh  = POE::Component::OpenSSH->new(
            args => [
                $self->host,
                user   => $self->user,
                passwd => $self->passwd,
            ],
        );

        # remember, $ssh is just POE::Component::OpenSSH
        # you want the Net::OpenSSH object (or psuedo-object)
        $ssh->obj->capture( { event => 'parse_cmd' }, $cmd );
    }

    event 'parse_cmd' => sub {
        my ( $self, $output ) @_[ OBJECT, ARG1 ];
        my $host = $self->host;
        print "[$host]: $output";
    };

    package main;

    my @machines = ( qw( server1 server2 server3 ) );

    foreach my $machine (@machines) {
        Runner->new(
            host => $machine,
            pass => 'my_super_pass',
            cmd  => 'uname -a',
        );
    }

=head1 DESCRIPTION

This module allows you to use SSH (via L<Net::OpenSSH>) in a nonblocking manner.

I kept having to write this small thing each time I needed nonblocking SSH in a project. I got tired of it so I wrote this instead.

You might ask 'why put the args in an "args" attribute instead of straight away attributes?' Because Net::OpenSSH has a lot of options and they may collide with POE::Component::Generic's options and I don't feel like maintaining the mess.

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

=head1 SEE ALSO

If you have no idea what I'm doing (but you generally know what POE is), check these stuff:

L<POE::Component::Generic>

L<Net::OpenSSH>

If you don't know POE at all, check L<POE>.

=head1 DEPENDENCIES

These are the actual dependencies, though I don't use Moose or POE directly but rather MooseX::POE.

L<Net::OpenSSH>

L<POE>

L<POE::Component::Generic>

L<Moose>

L<MooseX::POE>


=head1 ACKNOWLEDGEMENTS

All the people involved in the aforementioned projects and the Perl community.

=head1 COPYRIGHT & LICENSE

Copyright 2009 Sawyer X, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

