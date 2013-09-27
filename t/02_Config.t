use strict;
use warnings;

use Test::More;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Atopynote::Service::Config;
use Data::Dumper;

my $config = Atopynote::Service::Config->new(file => "$Bin/../etc/atopynote.conf");
is($config->content->{dbname}, "atopynote", "loaded properly");

done_testing();
