CREATE TABLE IF NOT EXISTS `users` (
  `id` VARCHAR(255) PRIMARY KEY COMMENT 'ユーザーID',
  `username` VARCHAR(255) COMMENT 'ユーザー名',
  `email` VARCHAR(255) COMMENT 'ユーザーのメールアドレス',
  `role` ENUM('general', 'admin', 'beta_tester') NOT NULL COMMENT 'ユーザーの権限',
  `status` ENUM('active', 'inactive', 'banned') NOT NULL COMMENT 'ユーザーのステータス',
  `last_login_at` DATETIME NOT NULL COMMENT '最終ログイン日時',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_email` (`email`),
  INDEX `idx_role` (`role`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `category_master` (
  `id` INT UNSIGNED PRIMARY KEY COMMENT 'カテゴリID',
  `name` VARCHAR(255) NOT NULL COMMENT 'カテゴリ名',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discount_master` (
  `id` INT UNSIGNED PRIMARY KEY COMMENT '割引ID',
  `name` VARCHAR(255) NOT NULL COMMENT '割引キャンペーン名',
  `rate` INT NOT NULL CHECK (`rate` BETWEEN 0 AND 100) COMMENT '割引率（%）',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

CREATE TABLE IF NOT EXISTS `product_stocks` (
  `product_id` INT UNSIGNED PRIMARY KEY COMMENT '商品ID',
  `stock_quantity` INT UNSIGNED NOT NULL COMMENT '在庫数',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

CREATE TABLE IF NOT EXISTS `product_ratings` (
  `id` INT AUTO_INCREMENT PRIMARY KEY COMMENT '評価ID',
  `product_id` INT UNSIGNED NOT NULL COMMENT '商品ID',
  `user_id` VARCHAR(255) NOT NULL COMMENT '評価を行ったユーザーID',
  `rate` INT NOT NULL CHECK (`rate` BETWEEN 1 AND 5) COMMENT '評価（1〜5）',
  `rated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '評価日時',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`product_id`) REFERENCES `products`(`id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

CREATE TABLE IF NOT EXISTS `reservations` (
  `id` CHAR(36) PRIMARY KEY COMMENT '予約ID',
  `user_id` VARCHAR(255) NOT NULL COMMENT '予約を行ったユーザーID',
  `reserved_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '予約日時',
  `expired_at` DATETIME NOT NULL COMMENT '失効日時',
  `status` ENUM('pending', 'confirmed', 'canceled') NOT NULL DEFAULT 'pending' COMMENT '予約ステータス',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
