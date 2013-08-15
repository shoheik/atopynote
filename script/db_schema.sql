SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS User;
CREATE TABLE User 
(
    id BIGINT AUTO_INCREMENT, 
    email VARCHAR(50),
    username VARCHAR(20),
    password CHAR(40),
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Diary;
CREATE TABLE Diary 
(
    id BIGINT AUTO_INCREMENT, 
    user_id BIGINT,
    page_id BIGINT,
    PRIMARY KEY (id),
    INDEX(id),
    FOREIGN KEY(page_id) REFERENCES Page(id)
      ON DELETE CASCADE,
    FOREIGN KEY(user_id) REFERENCES User(id)
      ON DELETE CASCADE
) ENGINE=INNODB;;


DROP TABLE IF EXISTS Page;
CREATE TABLE Page 
(
    id BIGINT AUTO_INCREMENT, 
    date DATETIME,
    itch INT,
    feeling INT,
    stress INT,
    bowels INT,
    sleep FLOAT,
    exercise INT,
    meal_id INT,
    PRIMARY KEY(id)
) ENGINE=INNODB;;

DROP TABLE IF EXISTS Meal;
CREATE TABLE Meal 
(
    id INT AUTO_INCREMENT, 
    type VARCHAR(10),
    rice BOOL,
    bread BOOL,
    poteto BOOL,
    lite_vege BOOL,
    dark_vege BOOL,
    egg BOOL,
    dairy BOOL,
    soy BOOL,
    seaweed_mushroom BOOL,
    seed BOOL,
    chiken BOOL,
    beef BOOL,
    pork BOOL,
    fish BOOL,
    beer BOOL,
    wine BOOL,
    other_alcohol BOOL,
    fried BOOL,
    fruit BOOL,
    snack BOOL,
    PRIMARY KEY (id)
);

SET FOREIGN_KEY_CHECKS=1;
