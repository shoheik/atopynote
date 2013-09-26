use strict;
use warnings;

use Test::More;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Atopynote::Service::NoteData;
use Atopynote::Service::NoteData::Redis;
use Data::Dumper;

my $redis = Atopynote::Service::NoteData->new(method => Atopynote::Service::NoteData::Redis->new( config => '' ));
isa_ok($redis, "Atopynote::Service::NoteData");

done_testing();
