package HomeViewWorker;
 
use strict;
use warnings;
use base qw( TheSchwartz::Worker );
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Atopynote::Service::Job::HomeView;
 
sub work {
    my ($class, $job) = @_;
    my $hm = new Atopynote::Service::Job::HomeView();
    $hm->do_work($job->arg->{user_id});
    $job->completed();
}

#========================================
package MailWorker;

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use base qw( TheSchwartz::Worker );
use Atopynote::Service::Job::Mail;
 
sub work {
    my ($class, $job) = @_;
    my $mail = new Atopynote::Service::Job::Mail;
    $mail->do_work($job->arg->{code}, $job->arg->{email});
    $job->completed();
}
 
#========================================
package main;
 
use strict;
use warnings;
use TheSchwartz;
use Data::Dumper;
use FindBin qw($Bin);

my $conf = "$Bin/../etc/atopynote.conf";
open FILE, "$conf";
my @content = <FILE>;
my $content = join "\n", @content;
my $config_ref  = eval $content;
#print Dumper $config_ref;
 
my $dsn = 'dbi:mysql:' . $config_ref->{q_dbname};
my $client = TheSchwartz->new(
    databases => [{
        dsn  => $dsn,
        user => $config_ref->{q_db_username},
        pass => $config_ref->{q_password},
    }],
    verbose => 1, # ログを出力
);

$client->can_do('HomeViewWorker'); # Workerのクラス名を指定する
$client->can_do('MailWorker'); 
 
my $interval = 30; # default is 5
$client->work($interval);
