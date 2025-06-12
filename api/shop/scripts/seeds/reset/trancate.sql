SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE charge_products;
TRUNCATE TABLE charges;
TRUNCATE TABLE reservation_products;
TRUNCATE TABLE reservations;
TRUNCATE TABLE credit_cards;
TRUNCATE TABLE payment_provider_customers;
TRUNCATE TABLE product_ratings;
TRUNCATE TABLE product_images;
TRUNCATE TABLE product_stocks;
TRUNCATE TABLE products;
TRUNCATE TABLE discount_master;
TRUNCATE TABLE category_master;
TRUNCATE TABLE users;

SET FOREIGN_KEY_CHECKS = 1;
