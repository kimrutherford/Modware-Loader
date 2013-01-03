package Modware::Loader::Role::Ontology::Temp::WithOracle;
{
    $Modware::Loader::Role::Ontology::Temp::WithOracle::VERSION = '1.0.0';
}

use namespace::autoclean;
use Moose::Role;

with 'Modware::Loader::Role::Ontology::Temp::Generic';

has cache_threshold =>
    ( is => 'rw', isa => 'Int', lazy => 1, default => 8000 );

after 'load_data_in_staging' => sub {
    my ($self) = @_;
    $self->logger->debug(
        sprintf "terms:%d\tsynonyms:%d\trelationships:%d in staging tables",
        $self->entries_in_staging('TempCvterm'),
        $self->entries_in_staging('TempCvtermsynonym'),
        $self->entries_in_staging('TempCvtermRelationship')
    );
};

around 'load_cvterms_in_staging' => sub {
    my $orig = shift;
    my $self = shift;
    $self->$orig( @_, [ sub { $self->load_synonyms_in_staging(@_) } ] );
};

after 'load_cvterms_in_staging' => sub {
    my ($self) = @_;
    $self->load_cache( 'synonym', 'TempCvtermsynonym' );
};

sub create_temp_statements {
    my ( $self, $storage ) = @_;
    $storage->dbh->do(
        qq{
	        CREATE GLOBAL TEMPORARY TABLE temp_cvterm (
               name varchar2(1024) NOT NULL, 
               accession varchar2(256) NOT NULL, 
               is_obsolete number DEFAULT '0' NOT NULL, 
               is_relationshiptype number DEFAULT '0' NOT NULL, 
               definition varchar2(4000), 
               cmmnt varchar2(4000), 
               cv_id number NOT NULL, 
               db_id number NOT NULL
    ) ON COMMIT PRESERVE ROWS }
    );

    $storage->dbh->do(
        qq{
	        CREATE GLOBAL TEMPORARY  TABLE temp_cvterm_relationship (
               subject varchar2(256) NOT NULL, 
               object varchar2(256) NOT NULL, 
               type varchar2(256) NOT NULL, 
               subject_db_id number NOT NULL, 
               object_db_id number NOT NULL, 
               type_db_id number NOT NULL
    ) ON COMMIT PRESERVE ROWS }
    );

    $storage->dbh->do(
        qq{
	        CREATE GLOBAL TEMPORARY TABLE temp_cvterm_synonym (
               accession varchar2(256) NOT NULL, 
               syn varchar2(1024) NOT NULL, 
               syn_scope_id number NOT NULL, 
               db_id number NOT NULL
    ) ON COMMIT PRESERVE ROWS }
    );
}

sub drop_temp_statements {
    my ( $self, $storage ) = @_;
    $storage->dbh->do(qq{TRUNCATE TABLE temp_cvterm});
    $storage->dbh->do(qq{TRUNCATE TABLE temp_cvterm_relationship});
    $storage->dbh->do(qq{TRUNCATE TABLE temp_cvterm_synonym});
    $storage->dbh->do(qq{DROP TABLE temp_cvterm});
    $storage->dbh->do(qq{DROP TABLE temp_cvterm_relationship});
    $storage->dbh->do(qq{DROP TABLE temp_cvterm_synonym});
}

1;

__END__

=pod

=head1 NAME

Modware::Loader::Role::Ontology::Temp::WithOracle

=head1 VERSION

version 1.0.0

=head1 AUTHOR

Siddhartha Basu <biosidd@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Siddhartha Basu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut