package Atopynote::Model;
use Moo;
use Data::Dumper;
use FindBin qw($Bin);
use Atopynote::DB;
use utf8;
use Encode;
#use Cache::Memcached::Fast;

has 'config' => (
    is => 'ro',
    required => 1,
);

has 'db' => (
    is => 'ro',
    builder => '_build_db',
);

sub _build_db {
    my $self = shift;
    return Atopynote::DB->new(+{
        dsn => $self->config->{db_dsn},
        username => $self->config->{db_username},
        password => $self->config->{password}
    });
}

sub add_page {
    my ($self, $data) = @_;
    $self->db->create(
        'Page', 
        {
            date => $data->{date},
            bowels => $data->{bowels},
            stress => $data->{stress},
            feeling => $data->{feeling},
            itch => $data->{itch},
            sleep => $data->{sleep},
            exercise => $data->{exercise}
        }
    );
    print Dumper $data;
}


1;
