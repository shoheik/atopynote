package MailWorker;
 
use strict;
use warnings;
use base qw( TheSchwartz::Worker );
use Data::Dumper;
use Mail::Mailer;
use utf8;
use Encode;
 
sub work {
    my ($class, $job) = @_;

    my $info = $job->arg;
    my $subject = "認証用コード[Atopy Note]";
    my $code = $info->{code};
    my $body = "30分以内に認証用コードを入力してください\n認証用コード: $code\n";
    my $to = $info->{email};
 
    print "process...\n";
    print Dumper $job->arg;
    my $subject = encode('MIME-Header-ISO_2022_JP', $subject);
    my $body = encode('iso-2022-jp', $body);

    my $mailer = new Mail::Mailer 'smtp', Server => 'localhost';
    $mailer->open(
        {
            To => $to,
            From => 'no-reply@atopynote.com',
            Subject => $subject,
        }
    );
    print $mailer $body;
    $mailer->close; 
    $job->completed();
}
 
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
 
my $client = TheSchwartz->new(
    databases => [{
        dsn  => $config_ref->{db_dsn},
        user => $config_ref->{db_username},
        pass => $config_ref->{password},
    }],
    verbose => 0, # ログを出力
);
$client->can_do('MailWorker'); # Workerのクラス名を指定する
 
my $interval = 30; # default is 5
$client->work($interval);
