SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS User;
CREATE TABLE User 
(
    id BIGINT AUTO_INCREMENT, 
    email VARCHAR(50),
    username VARCHAR(20),
    gender VARCHAR(6),
    age INT,
    password CHAR(40),
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Diary;
CREATE TABLE Diary 
(
    id BIGINT AUTO_INCREMENT, 
    date DATE,
    user_id BIGINT,
    page_id BIGINT,
    PRIMARY KEY (id, date, user_id),
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
    itch INT,
    feeling INT,
    stress INT,
    bowels INT,
    sleep FLOAT,
    exercise INT,
    breakfirst_id INT,
    lunch_id INT,
    dinner_id INT,
    PRIMARY KEY(id)
) ENGINE=INNODB;;

DROP TABLE IF EXISTS Meal;
CREATE TABLE Meal 
(
    id INT AUTO_INCREMENT, 
    rice BOOL NOT NULL DEFAULT 0,
    bread BOOL NOT NULL DEFAULT 0,
    poteto BOOL NOT NULL DEFAULT 0,
    lite_vege BOOL NOT NULL DEFAULT 0,
    dark_vege BOOL NOT NULL DEFAULT 0,
    egg BOOL NOT NULL DEFAULT 0,
    dairy BOOL NOT NULL DEFAULT 0,
    soy BOOL NOT NULL DEFAULT 0,
    seaweed_mushroom BOOL NOT NULL DEFAULT 0,
    seed BOOL NOT NULL DEFAULT 0,
    chiken BOOL NOT NULL DEFAULT 0,
    beef BOOL NOT NULL DEFAULT 0,
    pork BOOL NOT NULL DEFAULT 0,
    fish BOOL NOT NULL DEFAULT 0,
    beer BOOL NOT NULL DEFAULT 0,
    wine BOOL NOT NULL DEFAULT 0,
    other_alcohol BOOL NOT NULL DEFAULT 0,
    fried BOOL NOT NULL DEFAULT 0,
    fruit BOOL NOT NULL DEFAULT 0,
    snack BOOL NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
);

SET FOREIGN_KEY_CHECKS=1;
