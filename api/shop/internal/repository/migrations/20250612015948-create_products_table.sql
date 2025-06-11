
-- +migrate Up
CREATE TABLE IF NOT EXISTS `products` (
  `id` INT UNSIGNED PRIMARY KEY COMMENT '商品ID',
  `name` VARCHAR(255) NOT NULL COMMENT '商品名',
  `description` TEXT COMMENT '商品説明',
  `price` DECIMAL(10,2) NOT NULL COMMENT '税込価格',
  `category_id` INT UNSIGNED NOT NULL COMMENT 'カテゴリID',
  `discount_id` INT UNSIGNED DEFAULT NULL COMMENT '割引ID（NULL可）',
  `vip_only` BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'VIP限定フラグ',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`category_id`) REFERENCES `category_master`(`id`),
  FOREIGN KEY (`discount_id`) REFERENCES `discount_master`(`id`),
  INDEX `idx_category_id` (`category_id`),
  INDEX `idx_discount_id` (`discount_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- +migrate Down
DROP TABLE IF EXISTS `products`;
