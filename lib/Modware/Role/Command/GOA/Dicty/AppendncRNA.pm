
use strict;

package Modware::Role::Command::GOA::Dicty::AppendncRNA;
{
  $Modware::Role::Command::GOA::Dicty::AppendncRNA::VERSION = '1.1.0';
}

use autodie qw/open close/;
use File::ShareDir qw/module_file/;
use IO::File;
use Modware::Loader;
use Moose::Role;
use namespace::autoclean;

requires 'input';

before 'execute' => sub {
    my ($self) = @_;
    my $logger = $self->logger;
    my $input  = $self->input;
    $logger->logdie('No input found') if !$input;

    my $ncRNA_gaf_file
        = IO::File->new( module_file( 'Modware::Loader', 'dicty_ncRNA.gaf' ),
        'r' );

    my $writer = IO::File->new( $input, 'a' );
    while ( my $line = $ncRNA_gaf_file->getline ) {
        $writer->print($line);
    }
    $ncRNA_gaf_file->close;
    $writer->close;
};

1;

__END__

=pod

=head1 NAME

Modware::Role::Command::GOA::Dicty::AppendncRNA

=head1 VERSION

version 1.1.0

=head1 AUTHOR

Siddhartha Basu <biosidd@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Siddhartha Basu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
