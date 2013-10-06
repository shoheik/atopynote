package Atopynote::Service::NoteData::Redis;
use Moo;
use Redis;
use Data::Dumper;
use JSON;

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
    if ($func eq "biorhythm") {
        return $self->_get_biorhythm($options->{user_id});
    }
}

sub _get_biorhythm{
    my ($self, $user_id ) = @_;
    my $data = decode_json $self->instance->get("linechart:user_id:$user_id");
    print Dumper $data;
    my $line_feeling = $data->{data}->{feeling}; 
    my $line_itch = $data->{data}->{itch}; 
    my $line_label = $data->{label}; 
    my $line_chart = { datasets => [ 
                            {  
                                fillColor => "rgba(0,180,255,0.1)",
                                strokeColor => "#62a9dd",
                                pointColor => "#62a9dd",
                                pointStrokeColor =>  "#fff",
                                data => $line_feeling,
                            },

                            {
                                fillColor => "rgba(151,187,205,0.5)",
                                strokeColor => "#db6a6a",
                                pointColor => "#db6a6a",
                                pointStrokeColor => "#fff",
                                data => $line_itch 
                            }

                        ],
                        labels => $line_label, 
                     };
    return $line_chart; 
}


sub set {
    my ($self, $key, $value) = @_;
    $self->instance->set($key, $value);
}

sub update {
    my ($self, $key, $value) = @_;
    if ($self->instance->exists($key) ){
        $self->instance->del($key);
    }
    $self->instance->set($key, $value);
}

sub delete{
    my ($self, $key) = @_;
    $self->instance->del($key);
}



1;
