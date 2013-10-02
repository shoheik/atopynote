package Atopynote::Service::Role::NoteData;
use Moo::Role;

requires qw/get set update delete/;

has config => (
    is => 'ro',
    builder => '_build_config',
    lazy => 1
);

sub _build_config {
    my $self = shift;
    my $config = new Atopynote::Service::Config();
    return $config->get();
}

1;
