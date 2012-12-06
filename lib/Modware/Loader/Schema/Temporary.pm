package Modware::Loader::Schema::Temporary;


package Modware::Loader::Schema::Temporary::Cvterm;
use strict;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('temp_cvterm');
__PACKAGE__->add_columns(
    'name' => { data_type => 'varchar', size => 1024 } );
__PACKAGE__->add_columns(
    'accession' => { data_type => 'varchar', size => 1024 } );
__PACKAGE__->add_columns( 'definition' => { data_type => 'text' } );
__PACKAGE__->add_columns( 'comment' => { data_type => 'text' } );
__PACKAGE__->add_columns(
    'is_relationshiptype' => { data_type => 'int', default => 0 } );
__PACKAGE__->add_columns(
    'is_obsolete' => { data_type => 'int', default => 0 } );
__PACKAGE__->add_columns(
    'cv_id' => { data_type => 'int', nullable => 0 } );
__PACKAGE__->add_columns(
    'db_id' => { data_type => 'int', nullable => 0 } );

1;


package Modware::Loader::Schema::Temporary::CvtermRelationship;
use strict;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('temp_cvterm_relationship');
__PACKAGE__->add_columns(
    'subject' => { data_type => 'varchar', size => 1024 } );
__PACKAGE__->add_columns(
    'object' => { data_type => 'varchar', size => 1024 } );
__PACKAGE__->add_columns(
    'type' => { data_type => 'varchar', size => 256 } );

1;

1;    # Magic true value required at end of module
