-- ########## Triggers ##########
-- ## Update the statistics table whenever a write operations performed on the seller, buyer, item, bid, transaction, complain tables
DELIMITER & & CREATE TRIGGER UpdateTotalSellersStatistics

AFTER
INSERT
    ON seller FOR EACH ROW BEGIN
UPDATE `statistics`
SET
    total_users = total_users + 1,
    total_sellers = total_sellers + 1;

END & &
CREATE TRIGGER UpdateTotalBuyersStatistics AFTER
INSERT
    ON buyer FOR EACH ROW BEGIN
UPDATE `statistics`
SET
    total_users = total_users + 1,
    total_buyers = total_buyers + 1;

END & &
CREATE TRIGGER UpdateItemsStatistics AFTER
INSERT
    ON item FOR EACH ROW BEGIN
UPDATE `statistics`
SET
    total_posted_items = total_posted_items + 1;

END & & SELECT * FROM statistics DELIMITER;