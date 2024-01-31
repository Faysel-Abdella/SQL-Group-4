-- ########## Views ##########
DELIMITER &&

-- View all available items

CREATE VIEW GetAllAvailableItems AS
SELECT item.item_title, item.item_description, item.posted_date, item.start_date, item.end_date, item.starting_price
FROM item
    INNER JOIN seller ON item.seller_id = seller.seller_id
WHERE
    item.current_status = 'available';

-- View all users

CREATE VIEW GetAllUsers AS
SELECT
    seller_id AS id,
    full_name,
    email,
    phone_number,
    `address`
from seller
UNION ALL
SELECT
    buyer_id AS id,
    full_name,
    email,
    phone_number,
    `address`
from buyer;
-- View all sellers
CREATE VIEW GetAllUsers AS SELECT * FROM seller;

-- View all buyers
CREATE VIEW GetAllBuyer AS SELECT * FROM buyer;

DELIMITER;

SELECT * FROM GetAllBuyer;

DROP VIEW GETAllUsers;