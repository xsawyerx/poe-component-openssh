use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'POE::Component::OpenSSH',
    license             => 'perl',
    dist_author         => 'Sawyer X <xsawyerx@cpan.org>',
    dist_version_from   => 'lib/POE/Component/OpenSSH.pm',
    build_requires => {
        'Test::More'         => 0,
        'Term::ReadPassword' => 0,
        'MooseX::POE'        => 0,
    },
    requires => {
        'Moose'                   => 0.88,
        'POE'                     => 1.266,
        'Net::OpenSSH'            => 0.38,
        'POE::Component::Generic' => 1.1201,
    },
    add_to_cleanup     => [ 'POE-Component-OpenSSH-*' ],
    create_makefile_pl => 'traditional',
    create_readme      => 1,
    create_license     => 1,
    meta_merge         => {
        resources => {
            repository =>
                'http://github.com/xsawyerx/poe-component-openssh/tree/master',
        },
        keywords  => [ 'poe', 'ssh', 'openssh', 'component', 'poco' ],
    },
);

$builder->create_build_script();
