use strict;
use warnings;

use Test::More;
use FindBin qw($Bin);
use lib "$Bin/../lib";

use_ok "Atopynote";
use_ok "Atopynote::DB";
use_ok "Atopynote::DB::Schema";
use_ok "Atopynote::Controller";
use_ok "Atopynote::Model";

done_testing();
