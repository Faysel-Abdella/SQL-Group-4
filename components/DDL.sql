CREATE DATABASE auction;

USE auction;

--              Create tables with appropriate fields
CREATE TABLE seller (
    seller_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, full_name VARCHAR(100) NOT NULL, email VARCHAR(100) UNIQUE NOT NULL, `password` VARCHAR(100) NOT NULL, phone_number VARCHAR(100) UNIQUE NOT NULL, `address` VARCHAR(100) NOT NULL, account_balance FLOAT DEFAULT 0.0, `status` ENUM(
        'active', 'suspended', 'banned'
    ) DEFAULT 'active', total_items_posted INT DEFAULT(0), rating FLOAT CHECK (rating <= 5) DEFAULT 0.0, total_transactions INT DEFAULT 0, last_transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, account_created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE buyer (
    buyer_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, full_name VARCHAR(100) NOT NULL, email VARCHAR(100) UNIQUE NOT NULL, `password` VARCHAR(100) NOT NULL, phone_number VARCHAR(100) UNIQUE NOT NULL, `address` VARCHAR(100) NOT NULL, account_balance FLOAT DEFAULT 0.0, account_created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE item (
    item_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, seller_id INT NOT NULL, FOREIGN KEY (seller_id) REFERENCES seller (seller_id), item_title VARCHAR(200) NOT NULL, item_description VARCHAR(500), posted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, end_date TIMESTAMP NOT NULL, starting_price FLOAT NOT NULL DEFAULT 0.0, current_status ENUM(
        'pending', 'available', 'sold', 'rejected'
    ) DEFAULT 'pending'
);

CREATE TABLE itemImage (
    image_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, item_id INT NOT NULL, FOREIGN KEY (item_id) REFERENCES item (item_id), image_URL VARCHAR(300) NOT NULL
)
CREATE TABLE bid (
    bid_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, bidder_id INT NOT NULL, FOREIGN KEY (bidder_id) REFERENCES buyer (buyer_id), item_id INT NOT NULL, FOREIGN KEY (item_id) REFERENCES item (item_id), bid_amount FLOAT NOT NULL CHECK (bid_amount > 0.0), bid_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE itemsBid (
    items_bid_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, item_id INT, FOREIGN KEY (item_id) REFERENCES item (item_id), total_bids INT DEFAULT 0, last_bid_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, highest_bid INT, FOREIGN KEY (highest_bid) REFERENCES bid (highest_bid),
)
CREATE TABLE `transaction` (
    transaction_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, item_id INT NOT NULL, FOREIGN KEY (item_id) REFERENCES item (item_id), seller_id INT NOT NULL, FOREIGN KEY (seller_id) REFERENCES seller (seller_id), buyer_id INT NOT NULL, FOREIGN KEY (buyer_id) REFERENCES buyer (buyer_id), transaction_amount FLOAT NOT NULL CHECK (transaction_amount > 0.0), transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, payment_status ENUM('pending', 'completed') DEFAULT 'pending'
);

CREATE TABLE complain (
    complain_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, complainer_id INT NOT NULL, FOREIGN KEY (complainer_id) REFERENCES buyer (buyer_id), seller_id INT NOT NULL, FOREIGN KEY (seller_id) REFERENCES seller (seller_id), transaction_id IN NOT NULL, FOREIGN KEY (transaction_id) REFERENCES `transaction` (transaction_id), complain_text VARCHAR(700) NOT NULL, `status` ENUM('read', 'unread') DEFAULT 'unread'
);

CREATE TABLE `admin` (
    admin_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, full_name VARCHAR(100) NOT NULL, email VARCHAR(100) NOT NULL, `password` VARCHAR(100) NOT NULL, `role` ENUM(
        'ItemsAdmin', 'UsersAdmin', 'SuperAdmin'
    ) NOT NULL
);

CREATE TABLE `statistics` (
    total_users INT DEFAULT 0, total_sellers INT DEFAULT 0, total_buyers INT DEFAULT 0, total_posted_items INT DEFAULT 0, total_active_items INT DEFAULT 0, total_sold_items INT DEFAULT 0, total_rejected_items INT DEFAULT 0, total_transactions INT DEFAULT 0, total_transaction_money FLOAT DEFAULT 0, total_profit FLOAT DEFAULT 0
);