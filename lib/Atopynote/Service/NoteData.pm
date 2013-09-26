package Atopynote::Service::NoteData;

use Moo;

has method => (
    is => 'ro',
    handles => "Atopynote::Service::Role::NoteData",
);

1;
