use strict;
use warnings;

use Test::More;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Atopynote::Service::Config;
use Atopynote::Service::NoteData;
use Atopynote::Service::NoteData::Redis;
use Atopynote::Service::NoteData::RDB;
use Data::Dumper;

my $config = new Atopynote::Service::Config(file => "$Bin/../etc/atopynote.conf"); 
my $conf = $config->get();
#my $redis = Atopynote::Service::NoteData->new(method => Atopynote::Service::NoteData::Redis->new( config => $conf ));
my $rdb = Atopynote::Service::NoteData->new(method => Atopynote::Service::NoteData::RDB->new( config => $conf ));
my $data = $rdb->get("feeling", {days => 30, user_id => 1 } );
#my $data = $rdb->get("itch", {days => 30, user_id => 1 } );

print Dumper $data;
#$data = $rdb->get("itch", 30);
#print Dumper $data;
#$redis->set("feeling_history", {key => 3, value => "test"});

done_testing();
