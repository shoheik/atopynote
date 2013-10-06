package Atopynote::Service::Job::Mail;
 
use strict;
use warnings;
use Moo;
use base qw( TheSchwartz::Worker );
use Data::Dumper;
use Mail::Mailer;
use utf8;
use Encode;
 
sub do_work {
    my ($class, $code, $to ) = @_;

    my $subject = "認証用コード[Atopy Note]";
    my $body = "認証番号: $code\nこの番号をウェブページに入力してください。番号の有効期限は30分です。\n";
 
    print "process...\n";
    $subject = encode('MIME-Header-ISO_2022_JP', $subject);
    $body = encode('iso-2022-jp', $body);

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
}

1;
