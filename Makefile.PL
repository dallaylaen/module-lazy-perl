use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'on::demand',
    AUTHOR           => q{Konstantin S. Uvarin <khedin@cpan.org>},
    VERSION_FROM     => 'lib/on/demand.pm',
    ABSTRACT_FROM    => 'lib/on/demand.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    MIN_PERL_VERSION => '5.008',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '0',
    },
    BUILD_REQUIRES => {
        'Test::More'      => 0.98, # done_testing + subtest
        'Test::Exception' => 0.03,
    },
    PREREQ_PM => {
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'on-demand*' },
    META_MERGE => {
        'meta-spec' => { version => 2 },
        resources   => {
            bugtracker => {
                web => 'https://github.com/dallaylaen/on-demand-perl/issues',
            },
            repository => {
                type => 'git',
                url => 'https://github.com/dallaylaen/on-demand-perl.git',
                web => 'https://github.com/dallaylaen/on-demand-perl',
            },
        },
        x_contributors => [
            # Alphabetically, with a comma at the end of line
        ],
    },
);
