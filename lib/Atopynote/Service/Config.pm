package Atopynote::Service::Config;
# load config file and the other module use this

use Moo;
with 'MooX::Singleton';

use FindBin qw($Bin);
use Data::Dumper;

has file => (
    is => 'ro',
    default => "$Bin/../etc/atopynote.conf",
);

has _content => ( 
    is => 'ro',
    lazy => 1,
    builder => "_content_builder",
);

sub _content_builder{
    my $self = shift;
    open FILE, $self->file or die "can't open file: $!";
    my @content = <FILE>;
    my $content = join "\n", @content;
    return eval $content;
}

sub get {
    my $self = shift;
    return $self->_content;
}


1;
