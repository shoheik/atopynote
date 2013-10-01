package Atopynote::Service::NoteData::RDB;
use Moo;
use Atopynote::DB;

with ('Atopynote::Service::Role::NoteData');

has instance => (
    is => 'ro',
    lazy => 1,
    builder => '_build_instance',
    handles => [qw/search/],
);

sub _build_instance {
    my $self = shift;
    my $dsn = 'dbi:mysql:' . $self->config->{dbname};
    return Atopynote::DB->new(+{
        dsn => $dsn, 
        username => $self->config->{db_username},
        password => $self->config->{password}
    });
}

sub get {
    my ($self, $func, $options) = @_;

    # {[[x1, y1], [x2, y2],,] = get("feeling", $num_of_days) 
    return $self->_get_attr_history($options, "feeling") if ($func eq "feeling");

    # {[[x1, y1], [x2, y2],,] = get("itch", $num_of_days) 
    return $self->_get_attr_history($options, "itch") if ($func eq "itch");
}

sub _get_attr_history {
    my ($self, $options, $attr) = @_;

    my $num_days = $options->{days};
    my $user_id = $options->{user_id};

    my $itr = $self->search('Diary', 
        { 
            user_id => $user_id 
        },
        {
            limit => $num_days,
            order_by => { 'date' => 'ASC' },
        }
    );

    my @page_ids;
    my %date_page;
    my @dates;
    while (my $row = $itr->next) { 
        my $date = $row->get_column('date');
        my $page_id = $row->get_column('page_id');
        $date_page{$date} = $page_id;
        push @dates, $date; 
        push @page_ids, $page_id;
    }

    $itr = $self->search('Page', 
        { id => \@page_ids },
    );

    my %data;
    while (my $row = $itr->next) { 
        my $id =  $row->get_column('id');
        $data{$id} = $row->get_column($attr);
    }

    my @result;
    for my $date (@dates){
        my $attr_value = $data{ $date_page{$date} };
        #print "$date: $attr_value : $date_page{$date} \n";
        push @result, [$date, $attr_value];
    }
    return \@result; 
}



sub set {
    my ($self, $func, $options) = @_;
}

sub update {
    my ($self, $func, $options) = @_;
}
sub delete {
    my ($self, $func, $options) = @_;
}



1;
