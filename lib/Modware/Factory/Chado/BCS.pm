package Modware::Factory::Chado::BCS;
{
  $Modware::Factory::Chado::BCS::VERSION = '1.1.0';
}

# Other modules:
use Class::Load qw/load_class/;
use namespace::autoclean;
use Moose;

# Module implementation
#

has 'engine' => ( isa => 'Str',  is => 'rw');

sub get_engine {
    my ( $self, $engine ) = @_;
    $engine  = $self->engine if !$engine;
	die "need a engine name\n" if !$engine;

	my $class_name = 'Modware::DataSource::Chado::BCS::Engine::'.ucfirst(lc $engine);
	load_class($class_name);
    return $class_name->new();
}

__PACKAGE__->meta->make_immutable;

1;    # Magic true value required at end of module

__END__

=pod

=head1 NAME

Modware::Factory::Chado::BCS

=head1 VERSION

version 1.1.0

=head1 AUTHOR

Siddhartha Basu <biosidd@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Siddhartha Basu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
