#!perl

package test;

use strict;
use warnings;

use Test::More tests => 1;
use MooseX::POE;
use POE::Component::OpenSSH;

has 'ssh' => (
    is         => 'ro',
    isa        => 'POE::Component::OpenSSH',
    lazy_build => 1,
);

has 'args'    => ( is => 'ro', isa => 'ArrayRef' );
has 'reached' => ( is => 'rw', isa => 'Bool', default => 0 );
sub _build_ssh {
    my $self = $_[OBJECT];
    return POE::Component::OpenSSH->new( args  => $self->args );
}

sub START {
    my ( $self, $kernel ) = @_[ OBJECT, KERNEL ];

    $self->ssh->obj->capture( { event => 'hello' }, '/bin/true' );
    $kernel->alarm( 'check_event', time() + 5 );
}

event 'hello' => sub {
    ok( 1, 'Reached event' );
    $_[OBJECT]->reached(1);
};

event 'check_event' => sub {
    # TODO: this should actually check if the password is okay
    # but it's hard to check that
    my ( $self, $kernel ) = @_[ OBJECT, KERNEL ];

    if ( ! $self->reached ) {
        skip 'Timing out. Probably wrong password.' => 1;
        $kernel->stop();
    }
};

package main;

use English '-no_match_vars';
use Test::More;
use POE::Kernel;
use Term::ReadPassword;

SKIP: {
    my $user = getpwuid $EFFECTIVE_USER_ID;
    my $pass = read_password("Local SSH Pass for $user: ");

    $user || skip 'Got no username' => 1;
    $pass || skip 'Got no pass'     => 1;

    test->new( args => [ 'localhost', user => $user, passwd => $pass ] );

    POE::Kernel->run();
}


