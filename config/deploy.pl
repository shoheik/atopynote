# config/deploy.pl
# See http://d.hatena.ne.jp/naoya/20130118/1358477523
use strict;
use warnings;
use Cinnamon::DSL;
use Data::Dumper;
 
set application => 'atopynote';
set repository  => 'https://github.com/shoheik/atopynote.git';
set user        => 'kamesho'; 
set password    => '';
 
role development => ['localhost'], {
    deploy_to   => '/tmp/apps',
    branch      => 'master',
};

role production => ['ec2'], {
    deploy_to   => '/home/kamesho/atopynote',
    branch      => 'master',
};


task hello => {
    world => sub {
        my ($host, @args) = @_;
        print "Hello World\n";
        print Dumper @args;
        my $pass = $ENV{PASS};
        print $pass, "\n";
        remote {
            run "echo helloworld";
        } $host;
    }
};
 
task deploy  => {

    dbsetup => sub {
        my ($host) = @_;
        my $dbpass = $ENV{DBPASS};
        my $rootpass = $ENV{ROOTPASS};
        exit if ($dbpass eq "" || $rootpass eq "");
        remote {
            run "/usr/bin/mysqladmin -uroot -p$rootpass create atopynote &&", 
                "/usr/bin/mysql -Datopynote -uroot -p$rootpass -e \"GRANT ALL PRIVILEGES ON *.* TO atopin\@localhost IDENTIFIED BY '$dbpass'\"";
                #mysql -u atopin -Datopynote -plivewithatopy < script/db_schema.sql
        } $host;
    },
    setup => sub {
        my ($host) = @_;
        my $repository = get('repository');
        my $deploy_to  = get('deploy_to');
        my $branch   = 'origin/' . get('branch');
        remote {
            run "git clone $repository $deploy_to && cd $deploy_to && git checkout -q $branch";
        } $host;
    },
    update => sub {
        my ($host) = @_;
        my $deploy_to = get('deploy_to');
        my $branch   = 'origin/' . get('branch');
        remote {
            #run "cd $deploy_to && git fetch origin && git checkout -q $branch && git submodule update --init";
            run "cd $deploy_to && git fetch origin && git checkout -q $branch";
        } $host;
    },
};
 
task server => {
    start => sub {
        my ($host) = @_;
        remote {
            #sudo "supervisorctl start myapp";
            run "cd $deploy_to && ./script/start_atopynote.sh";
        } $host;
    },
    stop => sub {
        my ($host) = @_;
        remote {
            #sudo "supervisorctl stop myapp";
            run "cd $deploy_to && ./script/stop_atopynote.sh";
        } $host;
    },
    restart => sub {
        my ($host) = @_;
        remote {
            run "kill -HUP `cat /tmp/atopynote.pid`";
        } $host;
    },
    status => sub {
        my ($host) = @_;
        remote {
            sudo "supervisorctl status";
        } $host;
    },
};
 
task carton => {
    install => sub {
        my ($host) = @_;
        my $deploy_to = get('deploy_to');
        remote {
            #run ". ~/perl5/perlbrew/etc/bashrc && cd $deploy_to && carton install";
            run ". ~/.bash_profile && cd $deploy_to && carton install";
        } $host;
    },
};
