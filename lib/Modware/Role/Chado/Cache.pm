package Modware::Role::Chado::Cache;
{
  $Modware::Role::Chado::Cache::VERSION = '1.1.0';
}

# Other modules:
use namespace::autoclean;
use Moose::Role;

# Module implementation
#
has '_cvterm_id_stack' => (
	is => 'rw', 
	isa => 'HashRef', 
	traits => [qw/Hash/], 
	default => sub { {}}, 
	lazy => 1, 
	handles => {
		'get_cvrow_by_id' => 'get', 
		'set_cvrow_by_id' => 'set', 
		'clean_cvrow_stack' => 'clear', 
		'has_cvrow_id' => 'defined'
	}
);


has '_db_id_stack' => (
	is => 'rw', 
	isa => 'HashRef', 
	traits => [qw/Hash/], 
	default => sub { {}}, 
	lazy => 1, 
	handles => {
		'get_dbrow_by_id' => 'get', 
		'set_dbrow_by_id' => 'set', 
		'clean_dbrow_stack' => 'clear', 
		'has_db_id' => 'defined'
	}
);


1;    # Magic true value required at end of module

__END__

=pod

=head1 NAME

Modware::Role::Chado::Cache

=head1 VERSION

version 1.1.0

=head1 NAME

Modware::Role::Chado::Cache - Cache commonly used cvs, cvterms, dbs and dbxrefs entries

=head1 AUTHOR

Siddhartha Basu <biosidd@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Siddhartha Basu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
