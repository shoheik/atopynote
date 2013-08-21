package Atopynote::Controller;
use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;
use Plack::Session;

# Access to '/'. 
# Check session
# If session is not ok, show static top page(top.html)
# Otherwise, show index (TODO)
sub top {
  my $self = shift;
  my $session = Plack::Session->new( $self->req->env );
  my $verified = $session->get('verified');
  print Dumper $verified;
  if (defined $verified) {
      # session is ok 
      # TODO this should be integreated to main Mojo view
      $self->render('index');
  } else {
      # no session 
      $self->redirect_to('/top.html');
  }
}

sub submit {
    my $self = shift;
    my $data = $self->req->json;
    $self->model->add_page($self->req->json);
    $self->render( text => 'I got this');
}

# register user
# show confirmation page 
sub register {
    my $self = shift;
    my $data;
    $data->{age} = $self->param('age');
    $data->{id} = $self->param('id');
    $data->{gender} = $self->param('gender');
    $data->{password} = $self->param('password');
    $self->model->register($data);
    $self->stash( id => $data->{id} );
    $self->render('register_confirmation');
}

sub confirm_registry {
    my $self = shift;
    my $data;
    $data->{id} = $self->param('id');
    $data->{code} = $self->param('code');
    my $result = $self->model->confirm_registry($data);
    $self->render(text => $result );
}

sub login {
    my $self = shift;
    my $session = Plack::Session->new( $self->req->env );
    my $data;
    $data->{id} = $self->param('id');
    $data->{password} = $self->param('password');
    my $result = $self->model->login($session, $data);
    if ($result eq "ok") {
        #$self->req->env->{'psgix.session.options'}->{change_id}++;
        $session->set('verified', 1);
        print Dumper $self->req;
    }
    $self->render(text => $result );
}

sub logoff {
    my $self = shift;
    my $session = Plack::Session->new( $self->req->env );
    $session->expire;
    $self->redirect_to('/top.html');
}

sub validate_user {
    my $self = shift;
    my $user = $self->param('fieldValue');
    print Dumper $user;
    my $result = $self->model->validate_user($user);
    $self->render(json => ["username", $result] );
}


1;
