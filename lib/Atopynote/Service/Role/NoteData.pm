package Atopynote::Service::Role::NoteData;
use Moo::Role;

requires qw/get set update delete/;

has config => (
    is => 'ro',
    required => 1
);


1;
