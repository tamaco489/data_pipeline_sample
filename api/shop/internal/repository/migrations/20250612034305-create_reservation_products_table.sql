
-- +migrate Up
CREATE TABLE IF NOT EXISTS `reservation_products` (
  `reservation_id` CHAR(36) NOT NULL COMMENT '予約ID',
  `product_id` INT UNSIGNED NOT NULL COMMENT '予約された商品ID',
  `quantity` INT UNSIGNED NOT NULL COMMENT '数量',
  `unit_price` INT UNSIGNED NOT NULL COMMENT '予約時点の単価',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`reservation_id`, `product_id`),
  FOREIGN KEY (`reservation_id`) REFERENCES `reservations`(`id`),
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- +migrate Down
DROP TABLE IF EXISTS `reservation_products`;
