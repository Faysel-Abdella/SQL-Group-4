-- ########## Procedures ##########
-- ## Sign up for a seller
DELIMITER & & CREATE PROCEDURE RegisterSeller (
    IN full_name VARCHAR(100),
    IN email VARCHAR(100),
    IN `password` VARCHAR(100),
    IN phone_number VARCHAR(100),
    IN `address` VARCHAR(100)
) BEGIN
INSERT INTO
    seller (
        full_name,
        email,
        `password`,
        phone_number,
        `address`
    )
VALUES
    (
        full_name,
        email,
        `password`,
        phone_number,
        `address`
    );

END & & CALL `RegisterSeller`(
    'Abdi',
    'abdi32@gmail.com',
    '123',
    '98928983',
    'hawasa'
);

SELECT
    *
FROM
    seller -- ## Sign up for a buyer 
    CREATE PROCEDURE RegisterBuyer (
        IN full_name VARCHAR(100),
        IN email VARCHAR(100),
        IN `password` VARCHAR(100),
        IN phone_number VARCHAR(100),
        IN `address` VARCHAR(100)
    ) BEGIN
INSERT INTO
    buyer (
        full_name,
        email,
        `password`,
        phone_number,
        `address`
    )
VALUES
    (
        full_name,
        email,
        `password`,
        phone_number,
        `address`
    );

END & & CALL RegisterBuyer(
    'Faysel Abdella',
    'faysel32@gmail.com',
    '123',
    '039887852',
    'Adama, Ethiopia'
);

SELECT
    *
FROM
    buyer;

-- ## Add money to buyer account
CREATE PROCEDURE AddMoney (IN buyer_id_param INT, amount FLOAT) BEGIN
UPDATE
    buyer
SET
    account_balance = account_balance + amount
WHERE
    buyer_id = buyer_id_param;

END & & CALL AddMoney (1, 600000);

SELECT
    *
FROM
    buyer -- ## Adding items
    CREATE PROCEDURE AddItem (
        IN item_id_param INT,
        IN seller_id_param INT,
        IN item_title VARCHAR(200),
        item_description VARCHAR(500),
        item_image VARCHAR(300),
        start_date TIMESTAMP,
        end_date TIMESTAMP,
        starting_price FLOAT
    ) BEGIN
INSERT INTO
    item(
        seller_id,
        item_title,
        item_description,
        start_date,
        end_date,
        starting_price
    )
VALUES
    (
        seller_id_param,
        item_title,
        item_description,
        start_date,
        end_date,
        starting_price
    );

INSERT INTO
    itemImage(item_id_param, image_URL)
VALUES
    (item_id, item_image);

END & & CALL AddItem(
    2,
    1,
    "A 180 villa house",
    "This house is located around ASTU main get and it has a total of 8 rooms",
    "https://images.com/house/villa/1",
    "2024-01-27 10:00:00",
    "2024-02-02 10:00:00",
    500000
)
SELECT
    *
FROM
    item;

-- ## Bid for item
CREATE PROCEDURE BidItem (
    IN bidder_id INT,
    IN item_id INT,
    bid_amount FLOAT
) BEGIN
INSERT INTO
    bid (bidder_id, item_id, bid_amount)
VALUES
    (bidder_id, item_id, bid_amount);

END & & CALL BidItem (1, 1, 550000);

SELECT
    *
FROM
    bid -- ## submit a complain
    CREATE PROCEDURE ComplainSeller (
        IN complainer_id_param INT,
        IN transaction_id_param INT,
        IN seller_id_param INT,
        complain_text VARCHAR(700)
    ) BEGIN
INSERT INTO
    complain (
        complainer_id,
        transaction_id_param,
        seller_id,
        complain_text
    )
VALUES
    (
        complainer_id_param,
        seller_id_param,
        complain_text
    );

END & & CALL ComplainSeller(
    1,
    1,
    1,
    "He scammed me and the item is corrupted"
);

SELECT
    *
FROM
    complain -- ## Register admin
    CREATE PROCEDURE RegisterAdmin (
        IN full_name VARCHAR(100),
        email VARCHAR(100),
        `password` VARCHAR(100),
        `role` VARCHAR(20)
    ) BEGIN
INSERT INTO
    `admin` (full_name, email, `password`, `role`)
VALUES
    (full_name, email, `password`, `role`);

END & & CALL RegisterAdmin(
    'Faysel Abdella',
    'fayselcode@gmail.com',
    '123',
    'ItemsAdmin'
);

CALL RegisterAdmin(
    'Abdi',
    'fayselcod@gmail.com',
    '123',
    'UsersAdmin'
);

CALL RegisterAdmin(
    'super man',
    'faysel12@gmail.com',
    '123',
    'SuperAdmin'
);

SELECT
    *
FROM
    `admin` -- ## Perform transaction
    CREATE PROCEDURE PerformTransaction (
        IN item_id_param INT,
        IN seller_id_param INT,
        IN buyer_id_param INT,
        IN transaction_amount FLOAT
    ) BEGIN
INSERT INTO
    `transaction` (item_id, seller_id, buyer_id, transaction_amount)
VALUES
    (
        item_id_param,
        seller_id_param,
        buyer_id_param,
        transaction_amount
    );

SET
    @transaction_fee = transaction_amount * 0.05;

SET
    @buyer_balance = (
        SELECT
            account_balance
        FROM
            buyer
        WHERE
            buyer_id = buyer_id_param
        LIMIT
            1
    );

IF @buyer_balance >= transaction_amount + @transaction_fee THEN
UPDATE
    seller
SET
    account_balance = account_balance + (transaction_amount - @transaction_fee)
WHERE
    seller_id = seller_id_param;

UPDATE
    buyer
SET
    account_balance = account_balance - (transaction_amount - @transaction_fee)
WHERE
    buyer_id = buyer_id_param;

UPDATE
    item
SET
    current_status = 'sold'
WHERE
    item_id = item_id_param;

UPDATE
    `statistics`
SET
    total_sold_items = total_sold_items + 1;

ELSE
SELECT
    'Buyer does not have sufficient funds' AS error_message;

END IF;

END & & CALL PerformTransaction(1, 1, 4, 2000000);

SELECT
    *
FROM
    transaction;

-- ## Verify a transaction
CREATE PROCEDURE VerifyTransaction (
    IN admin_id_param INT,
    IN transaction_id_param INT
) BEGIN
SET
    @this_admin_role = (
        SELECT
            `role`
        FROM
            `admin`
        WHERE
            admin_id = admin_id_param
    );

IF @this_admin_role = "SuperAdmin" THEN
SET
    @transaction_seller_id = (
        SELECT
            seller_id
        FROM
            `transaction`
        WHERE
            transaction_id = transaction_id_param
    );

SET
    @transaction_money = (
        SELECT
            transaction_amount
        FROM
            `transaction`
        WHERE
            transaction_id = transaction_id_param
    );

UPDATE
    `transaction`
SET
    payment_status = 'completed'
WHERE
    transaction_id = transaction_id_param;

UPDATE
    seller
SET
    total_transactions = total_transactions + 1,
    last_transaction_date = CURRENT_TIMESTAMP
WHERE
    seller_id = @transaction_seller_id;

UPDATE
    `statistics`
SET
    total_transactions = total_transactions + 1,
    total_transaction_money = total_transaction_money + @transaction_money,
    total_profit = @transaction_money * 0.05;

ELSE
SELECT
    'Non authorized admin' AS error_text;

END IF;

END & & CALL VerifyTransaction(3, 1);

SELECT
    *
FROM
    `transaction`;

-- ## Active, suspense or ban a seller
CREATE PROCEDURE ChangeSellerStatus (
    IN admin_id_param INT,
    IN seller_id_parm INT,
    IN new_status VARCHAR(20)
) BEGIN
SET
    @this_admin_role = (
        SELECT
            `role`
        FROM
            `admin`
        WHERE
            admin_id = admin_id_param
    );

IF @this_admin_role = "UsersAdmin" THEN
UPDATE
    seller
SET
    `status` = new_status
WHERE
    seller_id = seller_id_parm;

ELSE
SELECT
    'Non authorized admin' AS error_message;

END IF;

END & & CALL ChangeSellerStatus (2, 1, 'banned');

CREATE PROCEDURE ChangeItemStatus (
    IN admin_id_param INT,
    IN item_id_param INT,
    IN new_status VARCHAR(20)
) BEGIN
SET
    @this_admin_role = (
        SELECT
            `role`
        FROM
            `admin`
        WHERE
            admin_id = admin_id_param
    );

IF @this_admin_role = "ItemsAdmin" THEN
UPDATE
    item
SET
    current_status = new_status
WHERE
    item_id = item_id_param;

IF new_status = 'active' THEN
UPDATE
    `statistics`
SET
    total_active_items = total_active_items + 1;

ELSEIF new_status = 'rejected' THEN
UPDATE
    `statistics`
SET
    total_rejected_items = total_rejected_items + 1;

END IF;

ELSE
SELECT
    'Non authorized admin' AS error_text;

END IF;

END & & CALL ChangeItemStatus(1, 1, 'active');

SELECT
    *
FROM
    item;

CREATE PROCEDURE ReadComplain (IN admin_id_param INT, IN complain_id_param INT) BEGIN
SET
    @this_admin_role = (
        SELECT
            `role`
        FROM
            `admin`
        WHERE
            admin_id = admin_id_param
    );

IF @this_admin_role = "UsersAdmin" THEN
UPDATE
    complain
SET
    `status` = 'read'
WHERE
    admin_id = admin_id_param;

ELSE
SELECT
    'Non authorized admin' AS error_message;

END IF;

END & & DELIMITER;

DROP PROCEDURE `ChangeItemStatus`;