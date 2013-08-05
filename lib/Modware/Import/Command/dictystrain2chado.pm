
use strict;

package Modware::Import::Command::dictystrain2chado;

use Moose;
use namespace::autoclean;

extends qw/Modware::Import::Command/;
with 'Modware::Role::Command::WithLogger';

sub execute {

    my ($self) = @_;

    my $stock_rs = $self->schema->resultset('Stock::Stock')
        ->search( { 'type.name' => 'strain' }, { join => 'type' } );

}

1;

__END__

=head1 NAME

Modware::Import::Command::dictystrain2chado - Command to import strain data from dicty stock 

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut
