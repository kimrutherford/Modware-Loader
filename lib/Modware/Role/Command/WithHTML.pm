package Modware::Role::Command::WithHTML;
{
  $Modware::Role::Command::WithHTML::VERSION = '1.1.0';
}

# Other modules:
use namespace::autoclean;
use Moose::Role;
use Path::Class::File;
use Modware::Publication::DictyBase;

# Module implementation
#

requires 'execute';
requires 'current_logger';

has 'output_html' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1
);

has '_update_stack' => (
    is      => 'rw',
    isa     => 'ArrayRef[Modware::Publication::DictyBase]',
    traits  => [qw/Array NoGetopt/],
    handles => {
        'add_publication'  => 'push',
        'all_publications' => 'elements', 
        'publications' => 'count'
    }, 
    default => sub {[]}
);

after 'execute' => sub {
    my ($self) = @_;
    return if !$self->publications;
    my $logger = $self->current_logger;
    my $output = Path::Class::File->new( $self->output_html )->openw;
    $output->print('<br/><h4>This week\'s new papers</h4>');
    for my $new_pub ($self->all_publications) {
        my $link =
            '/publication/'.$new_pub->pub_id;
        my $citation = $new_pub->formatted_citation;
        $citation =~ s{<b>}{<a href=$link><b>};
        $citation =~ s{</b>}{</b></a>};
        $output->print( $citation, '<br/><hr/>' );
        $logger->info('pubmed id: ', $new_pub->pubmed_id,  ' written to html output');
    }
    $output->close;
};

1;    # Magic true value required at end of module

__END__

=pod

=head1 NAME

Modware::Role::Command::WithHTML

=head1 VERSION

version 1.1.0

=head1 AUTHOR

Siddhartha Basu <biosidd@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Siddhartha Basu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
