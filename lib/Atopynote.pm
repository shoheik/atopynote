package Atopynote;
use FindBin qw($Bin);
use Mojo::Base 'Mojolicious';
use Atopynote::Model;
use Data::Dumper;
use YAML;

# This method will run once at server start
sub startup {
    my $self = shift;

    # load config
    my $config = $self->plugin('Config', {file => "$Bin/../etc/atopynote.conf"});
    $self->plugin('Config', {file => "$Bin/../etc/meal.conf"});
    #print Dump $config;
    $self->types->type(json => 'application/json; charset=utf-8');

    my $m = Atopynote::Model->new(config => $config);
    $self->helper(model => sub {$m});

    # Router
    my $r = $self->routes;

    # Normal route to controller
    $r->get('/')->to('controller#top');
    $r->get('/form/meal')->to('controller#form_meal');
    $r->post('/form/submit')->to('controller#submit');
    $r->post('/register')->to('controller#register');
    $r->post('/confirm_registry')->to('controller#confirm_registry');
    $r->post('/login')->to('controller#login');
    $r->get('/logoff')->to('controller#logoff');
    $r->get('/ajaxValidateFieldName')->to('controller#validate_user');
}

1;
