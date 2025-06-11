
-- +migrate Up
CREATE TABLE IF NOT EXISTS `users` (
  `id` VARCHAR(255) PRIMARY KEY COMMENT 'Product-specific unique ID',
  `username` VARCHAR(255) COMMENT 'Account name in the game',
  `email` VARCHAR(255) COMMENT 'User email address',
  `role` ENUM('general', 'admin', 'beta_tester') NOT NULL COMMENT 'User role level',
  `status` ENUM('active', 'inactive', 'banned') NOT NULL COMMENT 'Determine if the account is active, inactive, or banned',
  `last_login_at` DATETIME NOT NULL COMMENT 'Last login date and time',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_email` (`email`),
  INDEX `idx_role` (`role`),
  INDEX `idx_status` (`status`)
);

-- +migrate Down
DROP TABLE IF EXISTS `users`;
