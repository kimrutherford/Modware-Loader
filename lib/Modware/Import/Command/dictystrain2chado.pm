
use strict;

package Modware::Import::Command::dictystrain2chado;

use Data::Dumper;
use Moose;
use namespace::autoclean;

extends qw/Modware::Import::Command/;
with 'Modware::Role::Command::WithLogger';
with 'Modware::Role::Stock::Import::Strain';

has 'prune' => ( is => 'rw', isa => 'Bool', default => 0 );

has data => (
    is  => 'rw',
    isa => 'ArrayRef',
    default =>
        sub { [qw/characteristics publications inventory genotype props/] }
);

sub execute {

    my ($self) = @_;

    my $guard = $self->schema->txn_scope_guard;

    if ( $self->prune ) {
        $self->schema->storage->dbh_do(
            sub {
                my ( $storage, $dbh ) = @_;
                my $sth = $dbh->prepare(qq{DELETE FROM stock});
                $sth->execute;
                $sth = $dbh->prepare(qq{DELETE FROM stockprop});
                $sth->execute;
                $sth = $dbh->prepare(qq{DELETE FROM stock_genotype});
                $sth->execute;
                $sth = $dbh->prepare(qq{DELETE FROM genotype});
                $sth->execute;
            }
        );
    }

    my $type_id = $self->schema->resultset('Cv::Cvterm')
        ->search( { name => 'strain' }, {} )->first->cvterm_id;

    my $io = IO::File->new( $self->input, 'r' );
    my $hash;
    my $stockprop_data;

    while ( my $line = $io->getline ) {
        my @cols = split( /\t/, $line );
        $hash->{uniquename}  = $cols[0] if $cols[0] =~ /^DBS[0-9]{7}/;
        $hash->{name}        = $cols[1];
        $hash->{organism_id} = $self->find_or_create_organism( $cols[2] )
            if $cols[2];
        $hash->{description} = $self->trim( $cols[3] );
        $hash->{type_id}     = $type_id;

        my $stock_rs
            = $self->schema->resultset('Stock::Stock')->create($hash);

        if ( $self->has_characteristics( $hash->{uniquename} ) ) {
            my $rank         = 0;
            my $char_type_id = $self->find_cvterm('characteristics');
            foreach my $characteristics (
                @{ $self->get_characteristics( $hash->{uniquename} ) } )
            {
                $stock_rs->create_related(
                    'stockprops',
                    {   type_id => $char_type_id,
                        value   => $self->trim($characteristics),
                        rank    => $rank
                    }
                );
                $rank = $rank + 1;
            }
        }

        if ( $self->has_publications( $hash->{uniquename} ) ) {
            foreach my $pmid (
                @{ $self->get_publications( $hash->{uniquename} ) } )
            {
                my $pub_id = $self->find_pub($pmid);
                if ($pub_id) {
                    $stock_rs->create_related( 'stock_pubs',
                        { pub_id => $pub_id } );
                }
                else {
                    $self->logger->warn(
                        "Reference does not exist for PMID:$pmid");
                }
            }
        }

        if ( $self->has_inventory( $hash->{uniquename} ) ) {
            my $rank = 0;
            foreach my $inventory (
                @{ $self->get_inventory( $hash->{uniquename} ) } )
            {
                foreach my $key ( keys $inventory ) {
                    my $type = $key;
                    $type =~ s/_/ /g if $type =~ /_/;

                    $stock_rs->create_related(
                        'stockprops',
                        {   type_id => $self->find_cvterm($type),
                            value   => $self->trim( $inventory->{$key} ),
                            rank    => $rank
                        }
                    ) if $inventory->{$key};
                }
                $rank = $rank + 1;
            }
        }

        if ( $self->has_genotype( $hash->{uniquename} ) ) {
            my $genotype = @{ $self->get_genotype( $hash->{uniquename} ) }[0];
            my ( $key, $value ) = each %$genotype;
            my $genotype_type_id = $self->find_cvterm('genotype');
            my $genotype_rs
                = $self->schema->resultset('Genetic::Genotype')->create(
                {   name       => $self->trim($value),
                    uniquename => $self->trim($key),
                    type_id    => $genotype_type_id
                }
                );
            $stock_rs->create_related( 'stock_genotypes',
                { genotype_id => $genotype_rs->genotype_id } );
        }

        if ( $self->has_props( $hash->{uniquename} ) ) {
            my $rank;
            my $previous_type = '';
            my @props         = @{ $self->get_props( $hash->{uniquename} ) };
            foreach my $prop (@props) {
                my ( $key, $value ) = each %$prop;
                $rank = 0 if $previous_type ne $key;
                my $props_type_id = $self->find_cvterm($key);
                $stock_rs->create_related(
                    'stockprops',
                    {   type_id => $props_type_id,
                        value   => $self->trim($value),
                        rank    => $rank
                    }
                );
                $rank          = $rank + 1;
                $previous_type = $key;
            }
        }

    }

    $guard->commit;
    $self->schema->storage->disconnect;
}

1;

__END__

=head1 NAME

Modware::Import::Command::dictystrain2chado - Command to import strain data from dicty stock 

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut
