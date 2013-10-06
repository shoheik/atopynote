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

    #========
    # Syntax
    #========
    # [[date, value_attr1, value_attr2,,,], [],,,] 
    # = get("history", {user_id => $id,  days => $days, attrs => [attr1, attr2] }) 
    return $self->_get_attr_history($options) if($func eq "history");

}

sub _get_attr_history {
    my ($self, $options, $attr) = @_;

    my $num_days = $options->{days};
    my $user_id = $options->{user_id};
    my $attrs = $options->{attrs};

    # Get date and page_id from Diary for this user
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

    # Using the page_ids, get contents from Page table
    $itr = $self->search('Page', 
        { id => \@page_ids },
    );
    my $page_data;
    while (my $row = $itr->next) { 
        my $id =  $row->get_column('id');
        for my $attr (@$attrs){
          $page_data->{$id}->{$attr} = $row->get_column($attr);
        }
    }

    my @result;
    for my $date (@dates){
        my @attr_values;
        for my $attr (@$attrs){
            push @attr_values, $page_data->{ $date_page{$date} }->{$attr};
        }
        push @result, [$date, @attr_values];
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
