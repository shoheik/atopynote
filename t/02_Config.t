use strict;
use warnings;

use Test::More;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Atopynote::Service::Config;
use Data::Dumper;

my $config =  Atopynote::Service::Config->new(file => "$Bin/../etc/atopynote.conf");
my $conf = $config->get();
is($conf->{dbname}, "atopynote", "loaded properly");

done_testing();
