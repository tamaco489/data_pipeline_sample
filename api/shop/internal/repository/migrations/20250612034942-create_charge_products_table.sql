
-- +migrate Up
CREATE TABLE IF NOT EXISTS `charge_products` (
  `charge_id` CHAR(36) NOT NULL COMMENT '決済ID',
  `product_id` INT UNSIGNED NOT NULL COMMENT '決済対象の商品ID',
  `quantity` INT UNSIGNED NOT NULL COMMENT '購入数量',
  `unit_price` INT UNSIGNED NOT NULL COMMENT '決済時点の単価',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`charge_id`, `product_id`),
  FOREIGN KEY (`charge_id`) REFERENCES `charges`(`id`),
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- +migrate Down
DROP TABLE IF EXISTS `charge_products`;
