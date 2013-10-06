package Atopynote::Controller;
use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;
use Plack::Session;
use Log::Minimal;
use utf8;

# Access to '/'. 
# Check session
# If session is not ok, show static top page(top.html)
# Otherwise, show index (TODO)
sub top {
  my $self = shift;
  my $request = Plack::Request->new($self->req->env);
  my $session = Plack::Session->new( $request->env );

  my $verified = $session->get('verified');
  print Dumper $verified;
  if (defined $verified) {
      # session is ok 
      print Dumper $session;
      $request->session_options->{change_id}++;
      $self->stash( uid => $verified );
      $self->render('index');
  } else {
      # no session 
      $self->redirect_to('/top.html');
  }
}

sub form_submit {
    my $self = shift;
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
    $data->{username} = $self->param('username');
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

    my $request = Plack::Request->new($self->req->env);
    my $session = Plack::Session->new( $request->env );

    my $data;
    $data->{id} = $self->param('id');
    $data->{password} = $self->param('password');

    # if ok, then $result is user_id 
    my $result = $self->model->login($data);

    if ($result eq "notok") {
        $self->render(text => $result );
    }else{
        # For Session Fixation!!
        $request->session_options->{change_id}++;
        $session->set('verified', $result); # store id attribute in User
        print Dumper $session;
        $self->render(text => 'ok');
    }
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

sub form_meal {
    my $self = shift;
    $self->render(json => $self->model->config->{meal});
}

sub homeview {
    my $self = shift;
    my $request = Plack::Request->new($self->req->env);
    my $session = Plack::Session->new( $request->env );
    my $user_id = $session->get('verified');
    if (! defined $user_id || $user_id eq "") {
        warnf("User ID can be found. Redirect to top.html");
        $self->redirect_to('/top.html');
    }
    my $result = $self->model->get_homeview($user_id);
    $self->render(json => $result );
}



1;
