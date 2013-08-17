package Atopynote::Model;
use Moo;
use Data::Dumper;
use FindBin qw($Bin);
use Atopynote::DB;
use Atopynote::DB::Schema;
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


1;
