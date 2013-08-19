package Atopynote::Controller;
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
  if (defined $verified) {
      # session is ok 
      # TODO this should be integreated to main Mojo view
      $self->redirect_to('/index.html');
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

1;
