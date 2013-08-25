package Atopynote::Model;
use Moo;
use Data::Dumper;
use FindBin qw($Bin);
use Atopynote::DB;
use Atopynote::DB::Schema;
use Digest::SHA qw(sha256_hex);
use Cache::Memcached::Fast;
use TheSchwartz;

has 'config' => (
    is => 'ro',
    required => 1,
);

has 'db' => (
    is => 'ro',
    builder => '_build_db',
);

has 'memd' => (
    is => 'ro',
    builder => '_build_memcached',
    lazy => 1,
);

has 'qclient' => (
    is => 'ro',
    lazy => 1,
    builder => '_build_qclient',
);

has 'schema' => (
    is => 'ro',
    default => sub { Atopynote::DB::Schema->schema_info }
);

sub _build_db {
    my $self = shift;
    return Atopynote::DB->new(+{
        dsn => $self->config->{db_dsn},
        username => $self->config->{db_username},
        password => $self->config->{password}
    });
}

sub _build_memcached {
    my $self = shift;
    my $server = $self->config->{memcache_server};
    my $port = $self->config->{memcache_port};
    if (defined $server && defined $port){
        return Cache::Memcached::Fast->new({ 
            servers => [ { address => "$server:$port" }],
            utf8 => 1,
        });
    }
    else {
        return undef;
    }
}

sub _build_qclient {
    my $self = shift;
    return TheSchwartz->new(
        databases => [{
            #dsn  => 'dbi:mysql:TheSchwartz',
            # TODO TheSchartz DB is the same as main one
            dsn => $self->config->{db_dsn},
            user =>  $self->config->{db_username},
            pass =>  $self->config->{password},
        }],
        verbose => 1,
    );
}

# Tokumaru book :)
sub get_password_hash{
    my ($self, $id, $pass) = @_;
    my $salt = $self->get_salt($id);
    my $hash = '';
    for (1..$self->config->{stretch_count}) {
        $hash =  sha256_hex($hash . $pass . $salt);
    }
    return $hash;
}

sub get_salt{
    my ($self, $id) = @_;
    return $id . pack("H*", $self->config->{fixed_salt});
}

sub register {
    my ($self, $data) = @_;
    #-----------------------------
    # 1. Create hash with salt
    # 2. Send mail with Job Queue
    #-----------------------------
    my $hash = $self->get_password_hash($data->{id}, $data->{password});
    $data->{password} = $hash;
    $data->{onetime} = int(rand(90000)) + 10000; # 5 number to authenticate later
    $self->memd->set($data->{id}, $data, 60 * 15);

    # Send mail now
    $self->qclient->insert(MailWorker => 
        { 
            code => $data->{onetime}, 
            email => $data->{id}, 
        }
    ); 

}

sub add_page {
    my ($self, $data) = @_;

    print Dumper $data;

    # prepare {breakfirst,lunch,dinner}_id, 
    my %meal_id;
    for my $type (qw/breakfirst lunch dinner/){
        # prepare query
        my $query;
        # if nothing is submitted
        if (scalar @{ $data->{$type} } == 0 ){
            for my $col ( @{ $self->schema->{Meal}->{columns} }){
                next if ($col eq "id");
                $query->{$col} = 0;
            }
        }else {
            for my $col ( @{ $self->schema->{Meal}->{columns} }){
                next if ($col eq "id");
                for my $stuff (@{ $data->{$type} }){
                    if ($stuff eq $col) {
                        $query->{$col} = 1;
                    }else {
                        $query->{$col} = 0;
                    }
                }
            }
        }

        print Dumper $query;
        my $row = $self->db->single('Meal', $query);
        if (defined $row) {
            $meal_id{$type} = $row->get_column('id');
        }else {
            my $r =  $self->db->create('Meal', $query);
            if (defined $r) {
                $meal_id{$type} = $r->get_column('id');
            }else {
                #TODO error handling
            }
        }
    }
        
    my $row = $self->db->single('Page', 
        {
            bowels => $data->{bowels},
            stress => $data->{stress},
            feeling => $data->{feeling},
            itch => $data->{itch},
            sleep => $data->{sleep},
            exercise => $data->{exercise},
            breakfirst_id => $meal_id{breakfirst},
            lunch_id => $meal_id{lunch},
            dinner_id => $meal_id{dinner}
        }
    );

    my $page_id;
    if(defined $row) {
        $page_id = $row->get_column('id');
    }else {
        my $r = $self->db->create(
            'Page', 
            {
                bowels => $data->{bowels},
                stress => $data->{stress},
                feeling => $data->{feeling},
                itch => $data->{itch},
                sleep => $data->{sleep},
                exercise => $data->{exercise},
                breakfirst_id => $meal_id{breakfirst},
                lunch_id => $meal_id{lunch},
                dinner_id => $meal_id{dinner}
            }
        );
        $page_id = $r->get_column('id');
    }

    # TODO 
    my $user_id = 1;

    # One page for One day
    my $d_row = $self->db->single(
        'Diary', 
        {
            date => $data->{date},
            user_id => $user_id, 
        }
    );
    if (defined $d_row) {
        my $r = $self->db->update(
            'Diary',
            {
                page_id => $page_id,
            },
            {
                date => $data->{date},
                user_id => $user_id, 
            }
        );
        unless(defined $r) {
            # TODO error handling
        }
    }else{
        my $r = $self->db->create(
            'Diary', 
            {
                date => $data->{date},
                page_id => $page_id,
                user_id => $user_id, 
            }
        );
        unless (defined $r) {
            #TODO error handling 
        }
    }
}

sub confirm_registry {
    my ($self, $data) = @_;
    my $user_info = $self->memd->get($data->{id});
    print Dumper $user_info;
    if ($data->{code} eq $user_info->{onetime} ){
        $self->db->create('User', 
            {
                email => $user_info->{id},
                username => $user_info->{username},
                age => $user_info->{age},
                gender => $user_info->{gender},
                password => $user_info->{password},
             }
        );
        return "ok";
    }else {
        return "notok";
    }
}

sub login {
    my ($self, $session, $data) = @_;
    print Dumper $data;
    my $row = $self->db->single('User', {email => $data->{id} });
    if (defined $row) {
        my $db_pass = $row->get_column('password');
        my $hash = $self->get_password_hash($data->{id}, $data->{password});
        if ($db_pass eq $hash) {
            return 'ok';
        }else {
            return 'notok';
        }
    }else {
        return "notok";
    }
}

sub validate_user {
    my ($self, $username) = @_;
    my $row = $self->db->single('User', {username => $username });
    if (defined $row) {
        return Mojo::JSOON->false;
    }else {
        return Mojo::JSON->true;
    }
}

1;
