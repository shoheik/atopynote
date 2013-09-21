package Atopynote::Model;
use Moo;
use Data::Dumper;
use FindBin qw($Bin);
use Atopynote::DB;
use Atopynote::DB::Schema;
use Digest::SHA qw(sha256_hex);
use Cache::Memcached::Fast;
use TheSchwartz;
use POSIX qw(strftime);


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
    my $dsn = 'dbi:mysql:' . $self->config->{dbname};
    return Atopynote::DB->new(+{
        dsn => $dsn, 
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
    my $dsn = 'dbi:mysql:' . $self->config->{q_dbname};
    return TheSchwartz->new(
        databases => [{
            #dsn  => 'dbi:mysql:jobq',
            # TODO TheSchartz DB is the same as main one
            dsn => $dsn,
            user =>  $self->config->{q_db_username},
            pass =>  $self->config->{q_password},
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
    my $email = lc $data->{id};
    my $hash = $self->get_password_hash($email, $data->{password});
    $data->{password} = $hash;
    $data->{onetime} = int(rand(90000)) + 10000; # 5 number to authenticate later
    $self->memd->set($email, $data, 60 * 15);

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
    for my $type (qw/breakfirst lunch break dinner drink/){
        my $query;

        # init as 0
        for my $col ( @{ $self->schema->{Meal}->{columns} }){
            next if ($col eq "id");
            $query->{$col} = 0;
        }

        for my $input (@{ $data->{'meal'} }){
            if ($type eq $input->{name}){
                my $food = $input->{value};
                $query->{$food} = 1;
            }
        }
            
    #    # prepare query
    #    # if nothing is submitted
    #    if (scalar @{ $data->{$type} } == 0 ){
    #        for my $col ( @{ $self->schema->{Meal}->{columns} }){
    #            next if ($col eq "id");
    #            $query->{$col} = 0;
    #        }
    #    }else {
    #        for my $col ( @{ $self->schema->{Meal}->{columns} }){
    #            next if ($col eq "id");
    #            for my $stuff (@{ $data->{$type} }){
    #                if ($stuff eq $col) {
    #                    $query->{$col} = 1;
    #                }else {
    #                    $query->{$col} = 0;
    #                }
    #            }
    #        }
    #    }

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
    print Dumper $data;
    my $query;
    my $date;
    my $memo;
    for my $input (@{ $data->{meal} }){

        if($input->{name} eq 'memo'){
            $memo = $input->{value};
            next;
        } elsif ($input->{name} eq 'date'){
            $date = $input->{value};
            next;
        } elsif ($input->{name} eq 'lunch' || $input->{name} eq 'breakfirst' || $input->{name} eq 'dinner'
            || $input->{name} eq 'break' || $input->{name} eq 'drink'){
            next;
        }
        $query->{$input->{name}} = $input->{value};
    }
    for my $type (qw/breakfirst lunch break dinner drink/){
        $query->{$type."_id"} = $meal_id{$type};
    }
    
    print Dumper $query;
    my $row = $self->db->single('Page', $query); 
    my $page_id;
    if(defined $row) {
        $page_id = $row->get_column('id');
    }else {
        my $r = $self->db->create('Page', $query);
        $page_id = $r->get_column('id');
    }

    my $user_id = $data->{uid};

    ## One page for One day
    my $d_row = $self->db->single(
        'Diary', 
        {
            date => $date,
            user_id => $user_id, 
        }
    );
    print Dumper $d_row;
    if (defined $d_row) {
        my $r = $self->db->update(
            'Diary',
            {
                page_id => $page_id,
            },
            {
                date => $date,
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
                date => $date,
                page_id => $page_id,
                user_id => $user_id, 
                memo => $memo,
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
    my $today = strftime "%Y-%m-%d", localtime;
    print Dumper $user_info;
    my $email = lc $user_info->{id};
    my $username = lc $user_info->{username};
    if ($data->{code} eq $user_info->{onetime} ){
        $self->db->create('User', 
            {
                email => $email, 
                username => $username,
                age => $user_info->{age},
                gender => $user_info->{gender},
                password => $user_info->{password},
                start_date => $today,
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
    my $email = lc $data->{id};
    my $row = $self->db->single('User', {email => $email });
    if (defined $row) {
        my $db_pass = $row->get_column('password');
        my $hash = $self->get_password_hash($email, $data->{password});
        if ($db_pass eq $hash) {
            return $row->get_column('id');
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
        return Mojo::JSON->false;
    }else {
        return Mojo::JSON->true;
    }
}

1;
