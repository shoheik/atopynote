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
    print Dumper $data;
}


1;
