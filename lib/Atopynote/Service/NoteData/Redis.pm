package Atopynote::Service::NoteData::Redis;
use Moo;
use Redis;

with ('Atopynote::Service::Role::NoteData');

has instance => (
    is => 'ro',
    lazy => 1,
    builder => '_build_instance',
);

sub _build_instance {
    my $self = shift;
    my $server_port = $self->config->{'redis_server'} . ":" . $self->config->{'redis_port'};
    return Redis->new(server => $server_port); 
}

sub get {
    my ($self, $func, $options) = @_;
}

sub set {
    my ($self, $func, $options) = @_;
    return $self->_set_feeling_history($options) if($func eq "feeling_history");
}

sub _set_feeling_history{
    my ($self, $options) = @_;
    my $key = $options->{key};
    my $value = $options->{value};
    $self->instance->set("$key:feelings", $value);
}

sub update {
    my ($self, $func, $options) = @_;
}
sub delete {
    my ($self, $func, $options) = @_;
}



1;
