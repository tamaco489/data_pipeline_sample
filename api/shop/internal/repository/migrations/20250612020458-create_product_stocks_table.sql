
-- +migrate Up
CREATE TABLE IF NOT EXISTS `product_stocks` (
  `product_id` INT UNSIGNED PRIMARY KEY COMMENT '商品ID',
  `stock_quantity` INT UNSIGNED NOT NULL COMMENT '在庫数',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- +migrate Down
DROP TABLE IF EXISTS `product_stocks`;
