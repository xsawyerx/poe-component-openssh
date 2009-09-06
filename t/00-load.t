#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'POE::Component::OpenSSH' );
}

diag( "Testing POE::Component::OpenSSH $POE::Component::OpenSSH::VERSION, Perl $], $^X" );
