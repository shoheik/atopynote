package Atopynote::Service::NoteData::Redis;
use Moo;
use Redis;

with ('Atopynote::Service::Role::NoteData');
#Redis->new(server => 'redis.example.com:8080');

has instance => (
    is => 'ro',
    lazy => 1,
    build => '_build_instance'
);

has config => (
    is => 'ro',
    required => 1
);

sub _build_instance {
    my $self = shift;
    my $server_port = $self->config->{'redis_server'} . ":" . $self->config->{'redis_port'};
    return Redis->new(server => $server_port); 
}

sub get_feeling {
    my ($self, $days) = @_;

}

1;
