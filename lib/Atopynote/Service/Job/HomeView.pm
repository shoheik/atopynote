package Atopynote::Service::Job::HomeView;

use strict;
use warnings;
use Moo;
use Data::Dumper;
use Atopynote::Service::Config;
use Atopynote::Service::NoteData;
use Atopynote::Service::NoteData::Redis;
use Atopynote::Service::NoteData::RDB;
use JSON;

sub do_work {
    my ($self, $user_id ) = @_;

    my $num_days = 30;
    my $label_period = 10;
    my $rdb = Atopynote::Service::NoteData->new(method => Atopynote::Service::NoteData::RDB->new());
    my $redis = Atopynote::Service::NoteData->new(method => Atopynote::Service::NoteData::Redis->new());

    #-------------------------------------------------------------------
    # 1. Get historical feelings and itch from MySQL and store to Redis
    #-------------------------------------------------------------------
    # [ [date, feeling_val1, itch_val2], [],,,,]
    my $history = $rdb->get("history", { days => $num_days, user_id => $user_id, attrs  => [qw/feeling itch/] } );
    print Dumper $history;

    my $i=0;    
    my @label;
    my $history_data;
    for my $day_data (@$history){
        my ($date_label, $feeling, $itch) = @$day_data;
        $date_label = "" if ( $i % $label_period  != 0);
        push @label, $date_label;
        push @{ $history_data->{feeling} }, $feeling;
        push @{ $history_data->{itch} }, $itch;
        $i++;
    }
    
    my $linechart_data = {label => \@label, data=> $history_data};
    $redis->update("linechart:user_id:$user_id", encode_json $linechart_data);
}


1;
