package Modware::Role::Command::CanCompress;
{
  $Modware::Role::Command::CanCompress::VERSION = '1.0.0';
}

# Other modules:
use namespace::autoclean;
use Moose::Role;
use IO::Compress::Gzip qw($GzipError gzip);

# Module implementation
#

requires 'output';

has 'compressed_output' => ( is => 'rw', isa => 'Str' );

after 'execute' => sub {
    my $self   = shift;
    my $logger = $self->logger;
    $self->compressed_output( $self->output . ".gz" );

    my $status = gzip $self->output => $self->compressed_output
        or die "gzip failed: " . $GzipError . "\n";

    if ($status) {
        $logger->info('File successfully compressed');
    }
};

1;

__END__

=pod

=head1 NAME

Modware::Role::Command::CanCompress

=head1 VERSION

version 1.0.0

=head1 AUTHOR

Siddhartha Basu <biosidd@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Siddhartha Basu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
