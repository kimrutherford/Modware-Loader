
use strict;

package Modware::Load::Command::gaf2chado;
{
  $Modware::Load::Command::gaf2chado::VERSION = '1.0.0';
}

use Moose;
use namespace::autoclean;

use Modware::Loader::GAF;
use Modware::Loader::GAF::Manager;
extends qw/Modware::Load::Chado/;

has '+input'         => ( documentation => 'GAF file' );
has '+input_handler' => ( traits        => [qw/NoGetopt/] );

has 'prune' => (
    is            => 'rw',
    isa           => 'Bool',
    default       => 1,
    lazy          => 1,
    documentation => 'Prune all existing annotations, default is ON'
);

has 'print_gaf' =>
    ( is => 'rw', isa => 'Bool', documentation => 'Print GAF' );

has 'limit' => (
    is            => 'rw',
    isa           => 'Int',
    documentation => 'Limit for number of annotations to be loaded'
);

sub execute {
    my ($self) = @_;

    my $manager = Modware::Loader::GAF::Manager->new;
    $manager->set_logger( $self->logger );
    $manager->set_schema( $self->schema );

    my $loader = Modware::Loader::GAF->new;
    $loader->set_manager($manager);

    if ( $self->input ) {
        $loader->set_input( $self->input );
    }
    else {
        $loader->set_input( $manager->query_ebi() );
    }
    $loader->set_limit( $self->limit );

    my $guard = $self->schema->storage->txn_scope_guard;
    if ( $self->prune ) {
        $manager->prune();
    }
    $loader->load_gaf();
    $guard->commit;
}

1;

__END__

=pod

=head1 NAME

Modware::Load::Command::gaf2chado

=head1 VERSION

version 1.0.0

=head1 AUTHOR

Siddhartha Basu <biosidd@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Siddhartha Basu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
