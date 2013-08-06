
use strict;

package Modware::Import::Command::dictystrain2chado;

use Moose;
use namespace::autoclean;

extends qw/Modware::Import::Command/;
with 'Modware::Role::Command::WithLogger';
with 'Modware::Role::Stock::Import::Strain';

sub execute {

    my ($self) = @_;

    my $stock_rs = $self->schema->resultset('Stock::Stock')
        ->search( { 'type.name' => 'strain' }, { join => 'type' } );

    my $hash;
    my $io = IO::File->new( $self->input, 'r' );
    while ( my $line = $io->getline ) {
        my @cols = split( /\t/, $line );
        $hash->{uniquename}  = $cols[0] if $cols[0] =~ /^DBS[0-9]{7}/;
        $hash->{name}        = $cols[1];
        $hash->{organism_id} = $self->find_or_create_organism( $cols[2] ) if $cols[2];
        print $hash->{uniquename} . "\t" . $hash->{organism_id} . "\n";
    }

}

1;

__END__

=head1 NAME

Modware::Import::Command::dictystrain2chado - Command to import strain data from dicty stock 

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut
