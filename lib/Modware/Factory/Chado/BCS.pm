package Modware::Factory::Chado::BCS;
{
  $Modware::Factory::Chado::BCS::VERSION = '1.0.0';
}

use warnings;
use strict;

# Other modules:
use Module::Find;
use Carp;
use Class::MOP;
use Try::Tiny;
use List::MoreUtils qw/firstval/;

# Module implementation
#
sub new {
    my ( $class, %arg ) = @_;
    my $engine = $arg{engine} ? ucfirst lc( $arg{engine} ) : 'Generic';
    my $package = firstval {/$engine$/}
        findsubmod('Modware::DataSource::Chado::BCS::Engine');
    croak "cannot find plugins for engine: $engine\n" if !$package;
    try {
        Class::MOP::load_class($package);
    }
    catch {
        croak "Issue in loading $package $_\n";
    };
    return $package->new(%arg);
}

1;    # Magic true value required at end of module

__END__

=pod

=head1 NAME

Modware::Factory::Chado::BCS

=head1 VERSION

version 1.0.0

=head1 AUTHOR

Siddhartha Basu <biosidd@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Siddhartha Basu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
