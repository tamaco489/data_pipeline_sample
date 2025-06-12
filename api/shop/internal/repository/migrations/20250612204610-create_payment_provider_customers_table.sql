
-- +migrate Up
CREATE TABLE IF NOT EXISTS `payment_provider_customers` (
  `user_id` VARCHAR(255) NOT NULL COMMENT 'ユーザーID（自社のユーザーID）',
  `payment_provider_customer_id` VARCHAR(255) NOT NULL COMMENT '決済事業者が発行する顧客ID',
  `provider_type` ENUM('stripe', 'fincode', 'gmo_pg', 'linepay') NOT NULL COMMENT '決済事業者種別',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `provider_type`),
  UNIQUE KEY `uk_provider_customer` (`payment_provider_customer_id`, `provider_type`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- +migrate Down
DROP TABLE IF EXISTS `payment_provider_customers`;
