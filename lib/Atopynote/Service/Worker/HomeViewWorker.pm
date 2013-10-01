package Atopynote::Service::Worker::HomewViewWorker;

use strict;
use warnings;
use Data::Dumper;
use parent 'TheSchwartz::Worker';

use Atopynote::Service::Config;
use Atopynote::Service::NoteData;
use Atopynote::Service::NoteData::Redis;
use Atopynote::Service::NoteData::RDB;
use JSON;

sub work {
    my ($self, $job) = @_;
    my $arg = $job->arg;

    # variables
    my $conf = $arg->{config};
    my $user_id = $arg->{user_id};
    my $num_days = 30;
    my $label_period = 10;

    #my $config = new Atopynote::Service::Config(file => "$Bin/../etc/atopynote.conf"); 
    #my $conf = $config->get();
    my $rdb = Atopynote::Service::NoteData->new(method => Atopynote::Service::NoteData::RDB->new( config => $conf ));
    my $redis = Atopynote::Service::NoteData->new(method => Atopynote::Service::NoteData::Redis->new( config => $conf ));
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

    $job->completed();
}

1;
