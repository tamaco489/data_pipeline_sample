
-- +migrate Up
CREATE TABLE IF NOT EXISTS `charges` (
  `id` CHAR(36) PRIMARY KEY COMMENT '決済ID',
  `reservation_id` CHAR(36) NOT NULL COMMENT '予約ID',
  `user_id` VARCHAR(255) NOT NULL COMMENT '決済を行ったユーザーID',
  `amount` INT UNSIGNED NOT NULL COMMENT '請求金額（合計）',
  `status` ENUM('unpaid', 'paid', 'failed') NOT NULL DEFAULT 'unpaid' COMMENT '決済ステータス',
  `charged_at` DATETIME NULL COMMENT 'デフォルトはNULL。決済APIを実行し売上が確定した際にその日時に更新',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY (`reservation_id`, `user_id`),
  FOREIGN KEY (`reservation_id`) REFERENCES `reservations`(`id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- +migrate Down
DROP TABLE IF EXISTS `charges`;
