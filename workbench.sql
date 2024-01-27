-- Active: 1700161145836@@127.0.0.1@3306@auction
--              Create a database and use it
CREATE DATABASE auction;

USE auction;

--              Create tables with appropriate fields
CREATE TABLE seller (
    seller_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    `password` VARCHAR(100) NOT NULL,
    phone_number VARCHAR(100) UNIQUE NOT NULL,
    `address` VARCHAR(100) NOT NULL,
    account_balance FLOAT DEFAULT 0.0,
    `status` ENUM('active', 'suspended', 'banned') DEFAULT 'active',
    total_items_posted INT DEFAULT(0),
    rating FLOAT CHECK (rating <= 5) DEFAULT 0.0,
    total_transactions INT DEFAULT 0,
    last_transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    account_created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE buyer (
    buyer_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    `password` VARCHAR(100) NOT NULL,
    phone_number VARCHAR(100) UNIQUE NOT NULL,
    `address` VARCHAR(100) NOT NULL,
    account_balance FLOAT DEFAULT 0.0,
    account_created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE item (
    item_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    seller_id INT NOT NULL,
    FOREIGN KEY (seller_id) REFERENCES seller (seller_id),
    item_title VARCHAR(200) NOT NULL,
    item_description VARCHAR(500),
    posted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMP NOT NULL,
    starting_price FLOAT NOT NULL DEFAULT 0.0,
    current_status ENUM(
        'pending',
        'active',
        'sold',
        'expired',
        'rejected'
    ) DEFAULT 'pending'
);

CREATE TABLE itemImage (
    image_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    item_id INT NOT NULL,
    FOREIGN KEY (item_id) REFERENCES item (item_id),
    image_URL VARCHAR(300) NOT NULL
)

CREATE TABLE bid (
    bid_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    bidder_id INT NOT NULL,
    FOREIGN KEY (bidder_id) REFERENCES buyer (buyer_id),
    item_id INT NOT NULL,
    FOREIGN KEY (item_id) REFERENCES item (item_id),
    bid_amount FLOAT NOT NULL CHECK (bid_amount > 0.0),
    bid_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE itemsBid (
    items_bid_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    item_id INT , FOREIGN KEY(item_id) REFERENCES item(item_id),
    total_bids INT DEFAULT 0,
    last_bid_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    highest_bid INT, FOREIGN KEY(highest_bid) REFERENCES bid(highest_bid),
)

CREATE TABLE `transaction` (
    transaction_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    item_id INT NOT NULL,
    FOREIGN KEY (item_id) REFERENCES item (item_id),
    seller_id INT NOT NULL,
    FOREIGN KEY (seller_id) REFERENCES seller (seller_id),
    buyer_id INT NOT NULL,
    FOREIGN KEY (buyer_id) REFERENCES buyer (buyer_id),
    transaction_amount FLOAT NOT NULL CHECK (transaction_amount > 0.0),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_status ENUM('pending', 'completed') DEFAULT 'pending'
);

CREATE TABLE complain (
    complain_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    complainer_id INT NOT NULL,
   FOREIGN KEY (complainer_id) REFERENCES buyer (buyer_id),
    seller_id INT NOT NULL,
    FOREIGN KEY (seller_id) REFERENCES seller (seller_id),
    complain_text VARCHAR(700) NOT NULL,
    `status` ENUM('read', 'unread') DEFAULT 'unread'
);



CREATE TABLE `admin` (
    admin_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    `password` VARCHAR(100) NOT NULL,
    `role` ENUM('ItemsAdmin', 'UsersAdmin', 'SuperAdmin') NOT NULL
);


CREATE TABLE `statistics` (
    total_users INT DEFAULT 0,
    total_sellers INT DEFAULT 0,
    total_buyers INT DEFAULT 0,
    total_posted_items INT DEFAULT 0,
    total_active_items INT DEFAULT 0,
    total_sold_items INT DEFAULT 0,
    total_rejected_items INT DEFAULT 0,
    total_transactions INT DEFAULT 0,
    total_transaction_money FLOAT DEFAULT 0,
    total_profit FLOAT DEFAULT 0
);

INSERT INTO `statistics` (total_users, total_sellers, total_buyers, total_posted_items, total_active_items, total_sold_items, total_rejected_items, total_transactions,total_transaction_money, total_profit) VALUES(0,0,0,0,0,0,0,0,0,0);

-- ########## Procedures ##########

-- ## Sign up for a seller
DELIMITER &&
CREATE PROCEDURE RegisterSeller (IN full_name VARCHAR(100), IN email VARCHAR(100), IN `password` VARCHAR(100), IN phone_number VARCHAR(100), IN `address` VARCHAR(100))
BEGIN
INSERT INTO seller (full_name, email, `password`, phone_number, `address`) VALUES(full_name, email, `password`, phone_number, `address`);
END &&

CALL `RegisterSeller`('Abdi', 'abdi32@gmail.com', '123', '98928983', 'hawasa');

SELECT * FROM seller

-- ## Sign up for a buyer 
CREATE PROCEDURE RegisterBuyer (IN full_name VARCHAR(100), IN email VARCHAR(100), IN `password` VARCHAR(100), IN phone_number VARCHAR(100), IN `address` VARCHAR(100))
BEGIN
INSERT INTO buyer (full_name, email, `password`, phone_number, `address`) VALUES(full_name, email,`password`, phone_number, `address`);
END &&

CALL RegisterBuyer('Faysel Abdella', 'faysel32@gmail.com', '123', '039887852', 'Adama, Ethiopia');

SELECT * FROM buyer;
-- ## Add money to buyer account
CREATE PROCEDURE AddMoney (IN buyer_id_param INT, amount FLOAT)
BEGIN
UPDATE buyer
SET account_balance = account_balance + amount
WHERE buyer_id = buyer_id_param;
END &&

CALL AddMoney (1, 600000);

SELECT * FROM buyer

-- ## Adding items
CREATE PROCEDURE AddItem (IN item_id_param INT, IN seller_id_param INT, IN item_title VARCHAR(200), item_description VARCHAR(500), item_image VARCHAR(300), start_date TIMESTAMP, end_date TIMESTAMP, starting_price FLOAT)
BEGIN
    INSERT INTO item(seller_id, item_title, item_description, start_date, end_date, starting_price) VALUES(seller_id_param, item_title, item_description, start_date, end_date, starting_price);

    INSERT INTO itemImage(item_id_param, image_URL) VALUES(item_id, item_image);  
END &&

CALL AddItem(1, 1, "A 180 villa house", "This house is located around ASTU main get and it has a total of 8 rooms", "https://images.com/house/villa/1", "2024-01-27 10:00:00", "2024-02-02 10:00:00", 500000)

SELECT * FROM item;

-- ## Bid for item
CREATE PROCEDURE BidItem (
    IN bidder_id INT, IN item_id INT, bid_amount FLOAT)
BEGIN
INSERT INTO bid (bidder_id, item_id, bid_amount) VALUES(bidder_id, item_id, bid_amount);
END &&

CALL BidItem (1, 1, 550000);
SELECT * FROM bid

-- ## submit a complain

CREATE PROCEDURE ComplainSeller (IN complainer_id_param INT, IN seller_id_param INT, complain_text VARCHAR(700))
BEGIN
INSERT INTO complain (complainer_id, seller_id, complain_text) VALUES(complainer_id_param, seller_id_param, complain_text);
END &&

CALL ComplainSeller(1, 1, "He scammed me and the item is corrupted");
SELECT * FROM complain

-- ## Create item ADMIN

CREATE PROCEDURE RegisterAdmin (IN full_name VARCHAR(100), email VARCHAR(100), `password` VARCHAR(100), `role` VARCHAR(20))
BEGIN
INSERT INTO `admin` (full_name, email, `password`, `role`) VALUES(full_name, email, `password`, `role`);
END &&

CALL RegisterAdmin('Faysel Abdella', 'fayselcode@gmail.com', '123', 'ItemsAdmin');

SELECT * FROM `admin`

-- ## Perform transaction
CREATE PROCEDURE PerformTransaction (IN item_id_param INT, IN seller_id_param INT, IN buyer_id_param INT, IN transaction_amount FLOAT)
BEGIN
    INSERT INTO `transaction` (item_id, seller_id, buyer_id, transaction_amount) VALUES (item_id_param, seller_id_param, buyer_id_param, transaction_amount);

    SET @transaction_fee = transaction_amount * 0.05;
    SET @buyer_balance = (SELECT account_balance FROM buyer WHERE buyer_id = buyer_id_param LIMIT 1);

    IF @buyer_balance >= transaction_amount + @transaction_fee THEN 
        UPDATE seller
        SET account_balance = account_balance + (transaction_amount - @transaction_fee)
        WHERE seller_id = seller_id_param;

        UPDATE buyer
        SET account_balance = account_balance - (transaction_amount - @transaction_fee)
        WHERE buyer_id = buyer_id_param;

        UPDATE item
        SET current_status = 'sold'
        WHERE item_id = item_id_param;
    ELSE
        SELECT 'Buyer does not have sufficient funds' AS error_message;        
    END IF;
END &&


CALL PerformTransaction(1, 1, 4, 2000000);


DELIMITER ;

-- ########## Triggers ##########

-- ## Update the statistics table whenever a write operations performed on the seller, buyer, item, bid, transaction, complain tables

DELIMITER &&
CREATE TRIGGER UpdateTotalSellersStatistics 
AFTER INSERT ON seller
FOR EACH ROW
BEGIN
UPDATE `statistics`
SET total_users = total_users + 1,
    total_sellers = total_sellers + 1;
END &&

CREATE TRIGGER UpdateTotalBuyersStatistics 
AFTER INSERT ON buyer
FOR EACH ROW
BEGIN
UPDATE `statistics`
SET total_users = total_users + 1,
    total_buyers = total_buyers + 1;
END &&

CREATE TRIGGER UpdateItemsStatistics 
AFTER INSERT ON item
FOR EACH ROW
BEGIN
UPDATE 'statistics' 
SET total_posted_items = total_posted_items + 1
END &&


SELECT * FROM statistics


DELIMITER ;







