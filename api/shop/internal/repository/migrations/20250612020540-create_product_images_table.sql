
-- +migrate Up
CREATE TABLE IF NOT EXISTS `product_images` (
  `id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '画像ID',
  `product_id` INT UNSIGNED NOT NULL COMMENT '商品ID',
  `image_url` TEXT NOT NULL COMMENT '商品画像URL',
  `is_main` BOOLEAN DEFAULT FALSE COMMENT 'メイン画像かどうか',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`),
  INDEX `idx_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- +migrate Down
DROP TABLE IF EXISTS `product_images`;
