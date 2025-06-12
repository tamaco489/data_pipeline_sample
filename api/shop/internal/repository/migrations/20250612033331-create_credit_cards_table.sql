-- +migrate Up
CREATE TABLE IF NOT EXISTS `credit_cards` (
  `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'カードID',
  `user_id` VARCHAR(255) NOT NULL COMMENT 'ユーザーID',
  `payment_provider_card_id` VARCHAR(255) NOT NULL COMMENT '決済事業者が発行するカードID',
  `provider_type` ENUM('stripe', 'fincode', 'gmo_pg', 'linepay') NOT NULL COMMENT '決済事業者種別',
  `is_default` BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'デフォルトカードか',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  UNIQUE KEY `uk_user_payment_provider_card` (`user_id`, `payment_provider_card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- +migrate Down
DROP TABLE IF EXISTS `credit_cards`;
