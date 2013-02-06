
use strict;

package Modware::Loader::GAF;
{
  $Modware::Loader::GAF::VERSION = '1.0.0';
}

use Moose;
use namespace::autoclean;

has 'gaf' => (
    is  => 'rw',
    isa => 'IO::File'
);

has 'limit' => ( is => 'rw', isa => 'Int|Undef', writer => 'set_limit' );

has 'manager' => (
    is     => 'rw',
    isa    => 'Modware::Loader::GAF::Manager',
    writer => 'set_manager'
);

sub set_input {
    my ( $self, $input ) = @_;
    my $io = IO::File->new( $input, 'r' );
    $self->gaf($io);
}


sub load_gaf {
    my ($self) = @_;
    if ( !$self->gaf ) {
        $self->logger->warn('Input not set');
        exit;
    }
    else {
        my $count = 0;
        while ( my $row = $self->gaf->getline ) {
            my $annotation = $self->manager->parse($row);
            if ( !$annotation ) {
                next;
            }
            my $rank = $self->get_rank($annotation);

            $self->upsert( $annotation, $rank );
            $count = $count + 1;
            if ( ( $count % 5000 ) == 0 ) {
                $self->manager->logger->info(
                    $count . ' annotations loaded so far' );
            }
            if ( $self->limit ) {
                return if ( $self->limit == $count );
            }
        }
    }
    $self->manager->logger->info( 'Finished loading '
            . $self->manager->schema->resultset('Sequence::FeatureCvterm')
            ->search( {}, {} )->count
            . ' annotations' );
}


sub get_rank {
    my ( $self, $annotation ) = @_;
    my $rank_rs
        = $self->manager->schema->resultset('Sequence::FeatureCvterm')
        ->search(
        {   feature_id => $annotation->feature_id,
            cvterm_id  => $annotation->cvterm_id,
            pub_id     => $annotation->pub_id
        },
        { cache => 1, select => 'rank', order_by => { -desc => 'rank' } }
        )->first;
    my $rank = 0;
    if ($rank_rs) {
        $rank = $rank_rs->rank + 1;
    }
    return $rank;
}


sub upsert {
    my ( $self, $annotation, $rank ) = @_;

    my $fcvt
        = $self->manager->schema->resultset('Sequence::FeatureCvterm')
        ->find_or_create(
        {   feature_id => $annotation->feature_id,
            cvterm_id  => $annotation->cvterm_id,
            pub_id     => $annotation->pub_id,
            rank       => $rank
        }
        );

    if ( $annotation->has_pubs ) {
        for my $i ( 0 .. $annotation->has_pubs - 1 ) {
            $fcvt->create_related( 'feature_cvterm_pubs',
                { pub_id => $annotation->get_pub($i) } );
        }
    }

    $fcvt->create_related(
        'feature_cvtermprops',
        {   type_id => $annotation->cvterm_id_evidence_code,
            value   => 1,
            rank    => $rank
        }
    );

    if ( $annotation->qualifier ) {
        $fcvt->create_related(
            'feature_cvtermprops',
            {   type_id => $self->manager->get_cvterm_for_feature_cvtermprop(
                    'qualifier'),
                value => $annotation->qualifier,
                rank  => $rank
            }
        );
    }

    if ( $annotation->date ) {
        $fcvt->create_related(
            'feature_cvtermprops',
            {   type_id =>
                    $self->manager->get_cvterm_for_feature_cvtermprop('date'),
                value => $annotation->date,
                rank  => $rank
            }
        );
    }

    if ( $annotation->with_from ) {
        $fcvt->create_related(
            'feature_cvtermprops',
            {   type_id =>
                    $self->manager->get_cvterm_for_feature_cvtermprop('with'),
                value => $annotation->with_from,
                rank  => $rank
            }
        );
        if ( $annotation->has_dbxrefs ) {
            for my $i ( 0 .. $annotation->has_dbxrefs - 1 ) {
                $fcvt->create_related( 'feature_cvterm_dbxrefs',
                    { dbxref_id => $annotation->get_dbxref($i) } );
            }
        }
    }

    if ( $annotation->assigned_by ) {
        $fcvt->create_related(
            'feature_cvtermprops',
            {   type_id => $self->manager->get_cvterm_for_feature_cvtermprop(
                    'source'),
                value => $annotation->assigned_by,
                rank  => $rank
            }
        );
    }
}

1;

__END__

=pod

=head1 NAME

Modware::Loader::GAF

=head1 VERSION

version 1.0.0

=head1 SYNOPSIS

=head1 DESCRIPTION

=item load_gaf()

=item get_rank()

=item upsert()

=head1 NAME

=head1 VERSION

=head1 AUTHOR

Siddhartha Basu <biosidd@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Siddhartha Basu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
