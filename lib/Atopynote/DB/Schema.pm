package Atopynote::DB::Schema;
use DBIx::Skinny::Schema;

install_table User => schema {
    pk 'id';
    columns qw/ 
        id
        email
        username
        password
    /;
};

install_table Diary => schema {
    pk 'id';
    columns qw/ 
        id
        user_id
        page_id
    /;
};

install_table Page => schema {
    pk 'id';
    columns qw/ 
        id
        date
        itch
        feeling
        stress
        bowels
        sleep
        exercise
        meal_id
    /;
};

install_table Meal => schema {
    pk 'id';
    columns qw/ 
        id
        rice
        bread
        poteto
        lite_vege
        dark_vege
        egg
        dairy
        soy
        seaweed_mushroom
        seed
        chiken
        beef
        pork
        fish
        beer
        wine
        other_alcohol
        fried
        fruit
        snack
    /;
};

1;
