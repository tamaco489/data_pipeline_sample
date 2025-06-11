
-- +migrate Up
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

-- +migrate Down
DROP TABLE IF EXISTS `users`;
