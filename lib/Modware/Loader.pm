package Modware::Loader;
{
    $Modware::Loader::VERSION = '1.0.0';
}

1;

__END__

=pod

=head1 NAME

Modware::Loader

=head1 VERSION

version 1.0.0

=head1 NAME

Modware::Loader -  Command line apps for Chado relational database 

L<Chado|http://gmod.org/wiki/Introduction_to_Chado> is an open-source modular database
schema for biological data. This distribution provides L<MooseX::App::Cmd> based command
line applications to import and export biological data from Chado database.

=head1 INSTALLATION

First you have to install L<BioPortal|https://github.com/dictyBase/BioPortal-WebService>
distribution from github. Since none of this module is yet to ready for B<cpan>,  you have to install it
directly from B<github>. For a stable release,  use any of the tarball from git B<tag> and
for a developer release use the B<build/develop> branch. All the recepies below use the
developer release,  suit your script accordingly if you want to use the stable one.

=head2 Using cpanm

=head3 Single step

=over

  $_> curl -o BioPortal-WebService.tar.gz -L -k \
     https://github.com/dictyBase/BioPortal-WebService/archive/build/develop.tar.gz && \
     cpanm -n BioPortal-WebService.tar.gz  && \
     curl -o Modware-Loader.tar.gz -L -k \
     https://github.com/dictyBase/Modware-Loader/archive/build/develop.tar.gz && \
     cpanm -n Modware-Loader.tar.gz && \
     rm BioPortal-WebService.tar.gz Modware-Loader.tar.gz

=back

=head3 Manually

Download the BioPortal-Webservice and Modware-Loader tarballs and invoke B<cpanm> on them.
Read the included B<INSTALL> file for details.

=head2 Using Build.PL,  cpan and friends

Just follow the instuctions in the B<INSTALL> file.

=head2 Directly from the git repository

This is primarilly intended for authors/developers.

=over

    git checkout git://github.com/dictyBase/Modware-Loader.git
    cpanm -n Dist::Zilla
    curl -o BioPortal-WebService.tar.gz -L -k \
       https://github.com/dictyBase/BioPortal-WebService/archive/build/develop.tar.gz && \
    dzil listdeps --author --missing | cpanm -n
    dzil install

=back

=head1 AUTHOR

Siddhartha Basu <biosidd@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Siddhartha Basu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
