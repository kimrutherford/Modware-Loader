package Modware::Legacy::Schema::LocusGp;
{
  $Modware::Legacy::Schema::LocusGp::VERSION = '1.0.0';
}

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("locus_gp");
__PACKAGE__->add_columns(
    "locus_no",
    {   data_type     => "NUMBER",
        default_value => undef,
        is_nullable   => 0,
        size          => 10
    },
    "gene_product_no",
    {   data_type     => "NUMBER",
        default_value => undef,
        is_nullable   => 0,
        size          => 10
    },
);
__PACKAGE__->set_primary_key( "locus_no", "gene_product_no" );

# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-07 11:10:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:p00Suss/vEFbVuxnIDzXLg

__PACKAGE__->belongs_to( 'locus_gene_product', 'Modware::Legacy::Schema::GeneProduct',
    { 'foreign.gene_product_no' => 'self.gene_product_no' } );

# You can replace this text with custom content, and it will be preserved on regeneration
1;

__END__

=pod

=head1 NAME

Modware::Legacy::Schema::LocusGp

=head1 VERSION

version 1.0.0

=head1 AUTHOR

Siddhartha Basu <biosidd@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Siddhartha Basu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
