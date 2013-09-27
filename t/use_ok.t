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
use_ok "Atopynote::Service::Role::NoteData";
use_ok "Atopynote::Service::NoteData::Redis";
use_ok "Atopynote::Service::NoteData";
use_ok "Atopynote::Service::Config";

done_testing();
