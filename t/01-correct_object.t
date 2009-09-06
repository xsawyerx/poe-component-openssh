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

has 'args' => ( is => 'ro', isa => 'ArrayRef' );

sub _build_ssh {
    my $self = $_[OBJECT];
    return POE::Component::OpenSSH->new(
        args  => $self->args,
        debug => 1,
    );
}

sub START {
    my $self = $_[OBJECT];

    $self->ssh->obj->capture( { event => 'hello' }, 'w' );
}

event 'hello' => sub {
    ok( 1, 'got it' );
};

package main;

use Term::ReadPassword;
use POE::Kernel;
use English '-no_match_vars';

my $user = getpwuid $EFFECTIVE_USER_ID;
my $pass = read_password("Local SSH Pass for $user: ");

test->new( args => [ 'localhost', user => $user, passwd => $pass ] );

POE::Kernel->run();

