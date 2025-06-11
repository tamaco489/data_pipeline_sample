
-- +migrate Up
CREATE TABLE IF NOT EXISTS `reservations` (
  `id` CHAR(36) PRIMARY KEY COMMENT '予約ID',
  `user_id` VARCHAR(255) NOT NULL COMMENT '予約を行ったユーザーID',
  `product_id` INT UNSIGNED NOT NULL COMMENT '予約された商品ID',
  `reserved_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '予約日時',
  `expired_at` DATETIME NOT NULL COMMENT '失効日時',
  `status` ENUM('pending', 'confirmed', 'canceled') NOT NULL DEFAULT 'pending' COMMENT '予約ステータス',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- +migrate Down
DROP TABLE IF EXISTS `reservations`;
