package Atopynote::DB::Schema;
use DBIx::Skinny::Schema;

install_table User => schema {
    pk 'id', 'email', 'username';
    columns qw/ 
        id
        email
        username
        password
        gender
        age
    /;
};

install_table Diary => schema {
    pk 'id','date', 'user_id';
    columns qw/ 
        id
        date
        user_id
        page_id
    /;
};

install_table Page => schema {
    pk 'id';
    columns qw/ 
        id
        itch
        feeling
        stress
        bowels
        sleep
        exercise
        breakfirst_id
        lunch_id
        dinner_id
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
        seaweed
        mushroom
        seed
        chiken
        beef
        pork
        fish
        beer
        wine
        jp_sake
        soju
        wiskey
        voka
        awamori
        brandy
        jin
        liqueur
        cocktail
        fruit_juice
        coke
        coffee
        tea
        other_alcohol
        fried
        fruit
        snack
        jp_sweets
        chocolate
        cake
        icecream
        pudding
    /;
};

1;
