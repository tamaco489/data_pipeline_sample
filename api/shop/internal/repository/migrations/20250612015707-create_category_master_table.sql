
-- +migrate Up
CREATE TABLE IF NOT EXISTS `category_master` (
  `id` INT UNSIGNED PRIMARY KEY COMMENT 'カテゴリID',
  `name` VARCHAR(255) NOT NULL COMMENT 'カテゴリ名',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- +migrate Down
DROP TABLE IF EXISTS `category_master`;
