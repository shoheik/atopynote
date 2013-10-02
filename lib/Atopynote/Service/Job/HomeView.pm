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
    my $feelings = $rdb->get("feeling", { days => $num_days, user_id => $user_id} );

    my $i=0;    
    my @label;
    my @data;
    for my $day_data (@$feelings){
        my ($date, $feeling) = @$day_data;
        $date = "" if ( $i / $label_period  != 0);
        push @label, $date;
        push @data, $feeling;
        $i++;
    }
    
    my $data = {label => \@label, data=> \@data};
    $redis->set("linechart:user_id:$user_id", encode_json $data);
}


1;
