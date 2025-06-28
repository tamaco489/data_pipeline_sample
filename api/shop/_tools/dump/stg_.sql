-- MySQL dump 10.13  Distrib 8.0.41, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: stg_core
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `category_master`
--

DROP TABLE IF EXISTS `category_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category_master` (
  `id` int unsigned NOT NULL COMMENT 'カテゴリID',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'カテゴリ名',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_master`
--

LOCK TABLES `category_master` WRITE;
/*!40000 ALTER TABLE `category_master` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `category_master` VALUES (1,'無償通貨','2025-06-28 12:27:56','2025-06-28 12:27:56'),(2,'有償通貨','2025-06-28 12:27:56','2025-06-28 12:27:56'),(3,'ガチャチケット','2025-06-28 12:27:56','2025-06-28 12:27:56'),(4,'限定アイテム','2025-06-28 12:27:56','2025-06-28 12:27:56'),(5,'強化素材','2025-06-28 12:27:56','2025-06-28 12:27:56');
/*!40000 ALTER TABLE `category_master` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `charge_products`
--

DROP TABLE IF EXISTS `charge_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `charge_products` (
  `charge_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '決済ID',
  `product_id` int unsigned NOT NULL COMMENT '決済対象の商品ID',
  `quantity` int unsigned NOT NULL COMMENT '購入数量',
  `unit_price` int unsigned NOT NULL COMMENT '決済時点の単価',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`charge_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `charge_products_ibfk_1` FOREIGN KEY (`charge_id`) REFERENCES `charges` (`id`),
  CONSTRAINT `charge_products_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `charge_products`
--

LOCK TABLES `charge_products` WRITE;
/*!40000 ALTER TABLE `charge_products` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `charge_products` VALUES ('0197b682-b966-7e07-adbe-998cfea60342',10001002,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-b966-7e07-adbe-998cfea60342',10001005,2,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-ba19-7b6c-bec5-ce72725d3b84',10001009,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-ba19-7b6c-bec5-ce72725d3b84',10001013,3,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-ba57-7d25-9532-74ae2d029446',10001003,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-ba57-7d25-9532-74ae2d029446',10001011,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-ba8c-751d-8c96-79b55622b965',10001002,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-ba8c-751d-8c96-79b55622b965',10001008,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bac0-7ad2-9423-cb35df6da830',10001001,2,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bafe-75fc-9628-093e8e391a19',10001009,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bb20-742b-9031-206994bbe57b',10001011,2,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bb20-742b-9031-206994bbe57b',10001013,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bb54-7b70-9c69-1e2288cf15b0',10001004,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bb7c-7bd4-ad56-acac93c0d8df',10001007,3,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bbc4-7cf9-a1a7-0ff88e01c47e',10001013,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bbe6-78a8-882c-170595b144e4',10001005,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bbe6-78a8-882c-170595b144e4',10001008,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bc13-78f7-b695-a2bfd40cee55',10001003,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bc13-78f7-b695-a2bfd40cee55',10001009,3,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bc3c-788a-b723-7bf4a7459130',10001004,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bc5f-79a2-9f5d-3d0d85272fd8',10001002,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bc80-71e5-9868-33d40cba4423',10001010,3,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bca8-75bd-a5d9-59ff7f18d54c',10001013,2,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bcc6-7e42-9c7f-a6a7fa538ad0',10001001,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bce5-7281-806f-fdb54e7a357f',10001004,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bd05-71a3-994f-aefd45d3117e',10001005,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bd26-7048-b52c-92a1c1111366',10001008,1,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bd46-7516-b8d3-6b3a2ad68f01',10001009,3,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bd6b-7700-bed0-3402ed585daf',10001011,2,1000,'2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bd90-7b2e-a71e-c873e637c500',10001013,1,1000,'2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-bdb5-7d59-a115-d21bafcdfa67',10001003,3,1000,'2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-bdd4-78bd-af2e-951c4ed2b719',10001004,2,1000,'2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-bdf8-79d1-a88a-58398057fe8e',10001007,3,1000,'2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-be1e-7bcf-bfc3-76c6e27f7be3',10001008,1,1000,'2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-be40-703f-92c2-6248a574e577',10001010,1,1000,'2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-be5e-736b-9724-263c5e40b723',10001011,3,1000,'2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-be7c-7a07-b5fc-97597b28a117',10001001,2,1000,'2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-be9b-740c-9492-398c4123b584',10001003,1,1000,'2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-beb8-7253-959f-6a672b9dcbbe',10001005,1,1000,'2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-bed8-7670-a7dd-44715ccd710c',10001007,2,1000,'2025-06-28 12:28:31','2025-06-28 12:28:31'),('88603b81-bb62-480b-8be3-15a8c6ee3c7a',10001001,1,0,'2025-06-28 15:51:36','2025-06-28 15:51:36'),('88603b81-bb62-480b-8be3-15a8c6ee3c7a',10001003,1,2400,'2025-06-28 15:51:36','2025-06-28 15:51:36'),('88603b81-bb62-480b-8be3-15a8c6ee3c7a',10001009,3,300,'2025-06-28 15:51:36','2025-06-28 15:51:36'),('88603b81-bb62-480b-8be3-15a8c6ee3c7a',10001014,2,850,'2025-06-28 15:51:36','2025-06-28 15:51:36'),('af0a0c53-5f3a-4f48-bd46-8353dc5953c5',10001001,1,0,'2025-06-28 16:01:48','2025-06-28 16:01:48'),('af0a0c53-5f3a-4f48-bd46-8353dc5953c5',10001003,1,2400,'2025-06-28 16:01:48','2025-06-28 16:01:48'),('af0a0c53-5f3a-4f48-bd46-8353dc5953c5',10001009,3,300,'2025-06-28 16:01:48','2025-06-28 16:01:48'),('af0a0c53-5f3a-4f48-bd46-8353dc5953c5',10001014,2,850,'2025-06-28 16:01:48','2025-06-28 16:01:48');
/*!40000 ALTER TABLE `charge_products` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `charges`
--

DROP TABLE IF EXISTS `charges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `charges` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '決済ID',
  `reservation_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '予約ID',
  `user_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '決済を行ったユーザーID',
  `amount` int unsigned NOT NULL COMMENT '請求金額（合計）',
  `status` enum('unpaid','paid','failed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'unpaid' COMMENT '決済ステータス',
  `charged_at` datetime DEFAULT NULL COMMENT 'デフォルトはNULL。決済APIを実行し売上が確定した際にその日時に更新',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reservation_id` (`reservation_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `charges_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`),
  CONSTRAINT `charges_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `charges`
--

LOCK TABLES `charges` WRITE;
/*!40000 ALTER TABLE `charges` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `charges` VALUES ('0197b682-b966-7e07-adbe-998cfea60342','30000000-0000-0000-0000-000000000001','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf',2300,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-ba19-7b6c-bec5-ce72725d3b84','30000000-0000-0000-0000-000000000002','00000000-0000-0000-0000-000000000005',4000,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-ba57-7d25-9532-74ae2d029446','30000000-0000-0000-0000-000000000004','00000000-0000-0000-0000-000000000010',1600,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-ba8c-751d-8c96-79b55622b965','30000000-0000-0000-0000-000000000006','00000000-0000-0000-0000-000000000014',1600,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bac0-7ad2-9423-cb35df6da830','30000000-0000-0000-0000-000000000007','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf',2000,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bafe-75fc-9628-093e8e391a19','30000000-0000-0000-0000-000000000009','00000000-0000-0000-0000-000000000007',1000,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bb20-742b-9031-206994bbe57b','30000000-0000-0000-0000-000000000010','00000000-0000-0000-0000-000000000010',2600,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bb54-7b70-9c69-1e2288cf15b0','30000000-0000-0000-0000-000000000012','00000000-0000-0000-0000-000000000014',1000,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bb7c-7bd4-ad56-acac93c0d8df','30000000-0000-0000-0000-000000000013','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf',2400,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bbc4-7cf9-a1a7-0ff88e01c47e','30000000-0000-0000-0000-000000000015','00000000-0000-0000-0000-000000000007',1000,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bbe6-78a8-882c-170595b144e4','30000000-0000-0000-0000-000000000016','00000000-0000-0000-0000-000000000010',1400,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bc13-78f7-b695-a2bfd40cee55','30000000-0000-0000-0000-000000000018','00000000-0000-0000-0000-000000000014',3800,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bc3c-788a-b723-7bf4a7459130','30000000-0000-0000-0000-000000000019','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf',1000,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bc5f-79a2-9f5d-3d0d85272fd8','30000000-0000-0000-0000-000000000021','00000000-0000-0000-0000-000000000007',900,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bc80-71e5-9868-33d40cba4423','30000000-0000-0000-0000-000000000022','00000000-0000-0000-0000-000000000010',2550,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bca8-75bd-a5d9-59ff7f18d54c','30000000-0000-0000-0000-000000000024','00000000-0000-0000-0000-000000000014',2000,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bcc6-7e42-9c7f-a6a7fa538ad0','30000000-0000-0000-0000-000000000025','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf',1000,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bce5-7281-806f-fdb54e7a357f','30000000-0000-0000-0000-000000000027','00000000-0000-0000-0000-000000000007',1000,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bd05-71a3-994f-aefd45d3117e','30000000-0000-0000-0000-000000000028','00000000-0000-0000-0000-000000000010',700,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bd26-7048-b52c-92a1c1111366','30000000-0000-0000-0000-000000000030','00000000-0000-0000-0000-000000000014',700,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bd46-7516-b8d3-6b3a2ad68f01','30000000-0000-0000-0000-000000000031','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf',3000,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bd6b-7700-bed0-3402ed585daf','30000000-0000-0000-0000-000000000033','00000000-0000-0000-0000-000000000007',1600,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bd90-7b2e-a71e-c873e637c500','30000000-0000-0000-0000-000000000034','00000000-0000-0000-0000-000000000010',1000,'paid','2025-06-28 12:28:30','2025-06-28 12:28:30','2025-06-28 12:28:30'),('0197b682-bdb5-7d59-a115-d21bafcdfa67','30000000-0000-0000-0000-000000000036','00000000-0000-0000-0000-000000000014',2400,'paid','2025-06-28 12:28:31','2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-bdd4-78bd-af2e-951c4ed2b719','30000000-0000-0000-0000-000000000037','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf',2000,'paid','2025-06-28 12:28:31','2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-bdf8-79d1-a88a-58398057fe8e','30000000-0000-0000-0000-000000000039','00000000-0000-0000-0000-000000000007',2400,'paid','2025-06-28 12:28:31','2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-be1e-7bcf-bfc3-76c6e27f7be3','30000000-0000-0000-0000-000000000040','00000000-0000-0000-0000-000000000010',700,'paid','2025-06-28 12:28:31','2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-be40-703f-92c2-6248a574e577','30000000-0000-0000-0000-000000000042','00000000-0000-0000-0000-000000000014',850,'paid','2025-06-28 12:28:31','2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-be5e-736b-9724-263c5e40b723','30000000-0000-0000-0000-000000000043','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf',2400,'paid','2025-06-28 12:28:31','2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-be7c-7a07-b5fc-97597b28a117','30000000-0000-0000-0000-000000000045','00000000-0000-0000-0000-000000000007',2000,'paid','2025-06-28 12:28:31','2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-be9b-740c-9492-398c4123b584','30000000-0000-0000-0000-000000000046','00000000-0000-0000-0000-000000000010',800,'paid','2025-06-28 12:28:31','2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-beb8-7253-959f-6a672b9dcbbe','30000000-0000-0000-0000-000000000048','00000000-0000-0000-0000-000000000014',700,'paid','2025-06-28 12:28:31','2025-06-28 12:28:31','2025-06-28 12:28:31'),('0197b682-bed8-7670-a7dd-44715ccd710c','30000000-0000-0000-0000-000000000049','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf',1600,'paid','2025-06-28 12:28:31','2025-06-28 12:28:31','2025-06-28 12:28:31'),('88603b81-bb62-480b-8be3-15a8c6ee3c7a','0197b73c-2920-75a9-9941-1a66ffb59f09','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf',5000,'unpaid',NULL,'2025-06-28 15:51:36','2025-06-28 15:51:36'),('af0a0c53-5f3a-4f48-bd46-8353dc5953c5','0197b745-baad-7a03-9ccc-26b6383301cf','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf',5000,'unpaid',NULL,'2025-06-28 16:01:48','2025-06-28 16:01:48');
/*!40000 ALTER TABLE `charges` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `credit_cards`
--

DROP TABLE IF EXISTS `credit_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `credit_cards` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'カードID',
  `user_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ユーザーID',
  `payment_provider_card_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '決済事業者が発行するカードID',
  `provider_type` enum('stripe','fincode','gmo_pg','linepay') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '決済事業者種別',
  `is_default` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'デフォルトカードか',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_payment_provider_card` (`user_id`,`payment_provider_card_id`),
  CONSTRAINT `credit_cards_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credit_cards`
--

LOCK TABLES `credit_cards` WRITE;
/*!40000 ALTER TABLE `credit_cards` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `credit_cards` VALUES (1,'01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','5135da43-1568-4d2b-93be-589bfb330c23','fincode',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(2,'01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','cc729956-175f-465e-86e9-d3a9b0eeae9a','stripe',0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(3,'01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','94f8cb23-d9f4-4234-87fb-6418930fd4d1','linepay',0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(4,'00000000-0000-0000-0000-000000000002','card_002_a','linepay',0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(5,'00000000-0000-0000-0000-000000000002','card_002_b','stripe',0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(6,'00000000-0000-0000-0000-000000000002','card_002_c','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(7,'00000000-0000-0000-0000-000000000003','card_003_a','linepay',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(8,'00000000-0000-0000-0000-000000000003','card_003_b','linepay',0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(9,'00000000-0000-0000-0000-000000000003','card_003_c','linepay',0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10,'00000000-0000-0000-0000-000000000003','card_003_d','linepay',0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(11,'00000000-0000-0000-0000-000000000004','card_004_a','linepay',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(12,'00000000-0000-0000-0000-000000000004','card_004_b','linepay',0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(13,'00000000-0000-0000-0000-000000000005','card_005_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(14,'00000000-0000-0000-0000-000000000005','card_005_b','stripe',0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(15,'00000000-0000-0000-0000-000000000005','card_005_c','stripe',0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(16,'00000000-0000-0000-0000-000000000006','card_006_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(17,'00000000-0000-0000-0000-000000000007','card_007_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(18,'00000000-0000-0000-0000-000000000008','card_008_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(19,'00000000-0000-0000-0000-000000000009','card_009_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(20,'00000000-0000-0000-0000-000000000010','card_010_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(21,'00000000-0000-0000-0000-000000000014','card_014_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(22,'00000000-0000-0000-0000-000000000015','card_015_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(23,'00000000-0000-0000-0000-000000000016','card_016_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(24,'00000000-0000-0000-0000-000000000017','card_017_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(25,'00000000-0000-0000-0000-000000000018','card_018_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(26,'00000000-0000-0000-0000-000000000019','card_019_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(27,'00000000-0000-0000-0000-000000000020','card_020_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(28,'00000000-0000-0000-0000-000000000021','card_021_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(29,'00000000-0000-0000-0000-000000000022','card_022_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(30,'00000000-0000-0000-0000-000000000023','card_023_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(31,'00000000-0000-0000-0000-000000000024','card_024_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(32,'00000000-0000-0000-0000-000000000025','card_025_a','stripe',1,'2025-06-28 12:27:56','2025-06-28 12:27:56');
/*!40000 ALTER TABLE `credit_cards` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `discount_master`
--

DROP TABLE IF EXISTS `discount_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discount_master` (
  `id` int unsigned NOT NULL COMMENT '割引ID',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '割引キャンペーン名',
  `rate` int NOT NULL COMMENT '割引率（%）',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `discount_master_chk_1` CHECK ((`rate` between 0 and 100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discount_master`
--

LOCK TABLES `discount_master` WRITE;
/*!40000 ALTER TABLE `discount_master` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `discount_master` VALUES (1,'スタートダッシュキャンペーン',10,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(2,'限定セール',20,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(3,'VIPメンバー割引',30,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(4,'月末セール',15,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(5,'記念日キャンペーン',25,'2025-06-28 12:27:56','2025-06-28 12:27:56');
/*!40000 ALTER TABLE `discount_master` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `payment_provider_customers`
--

DROP TABLE IF EXISTS `payment_provider_customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_provider_customers` (
  `user_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ユーザーID（自社のユーザーID）',
  `payment_provider_customer_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '決済事業者が発行する顧客ID',
  `provider_type` enum('stripe','fincode','gmo_pg','linepay') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '決済事業者種別',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`provider_type`),
  UNIQUE KEY `uk_provider_customer` (`payment_provider_customer_id`,`provider_type`),
  CONSTRAINT `payment_provider_customers_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_provider_customers`
--

LOCK TABLES `payment_provider_customers` WRITE;
/*!40000 ALTER TABLE `payment_provider_customers` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `payment_provider_customers` VALUES ('00000000-0000-0000-0000-000000000002','cus_0002_stripe','stripe','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000002','cus_0002_linepay','linepay','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000003','cus_0003_stripe','linepay','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000004','cus_0004_stripe','linepay','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000005','cus_0005_stripe','stripe','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000006','cus_0006_stripe','fincode','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000007','cus_0007_stripe','stripe','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000008','cus_0008_stripe','fincode','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000009','cus_0009_stripe','gmo_pg','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000010','cus_0010_stripe','stripe','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000011','cus_0011_stripe','stripe','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000012','cus_0012_stripe','linepay','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000013','cus_0013_stripe','stripe','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000014','cus_0014_stripe','fincode','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000015','cus_0015_stripe','gmo_pg','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000016','cus_0016_stripe','gmo_pg','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000017','cus_0017_stripe','stripe','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000018','cus_0018_stripe','fincode','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000019','cus_0019_stripe','stripe','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000020','cus_0020_stripe','stripe','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000021','cus_0021_stripe','fincode','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000022','cus_0022_stripe','gmo_pg','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000023','cus_0023_stripe','fincode','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000024','cus_0024_stripe','stripe','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000025','cus_0025_stripe','linepay','2025-06-28 12:27:56','2025-06-28 12:27:56'),('01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','cus_00000001_stripe','stripe','2025-06-28 12:27:56','2025-06-28 12:27:56'),('01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','cus_00000001_fincode','fincode','2025-06-28 12:27:56','2025-06-28 12:27:56'),('01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','cus_00000001_linepay','linepay','2025-06-28 12:27:56','2025-06-28 12:27:56');
/*!40000 ALTER TABLE `payment_provider_customers` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_images` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '画像ID',
  `product_id` int unsigned NOT NULL COMMENT '商品ID',
  `image_url` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品画像URL',
  `is_main` tinyint(1) DEFAULT '0' COMMENT 'メイン画像かどうか',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `product_images` VALUES (1,10001001,'https://example.com/images/10001001/main.jpg',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(2,10001001,'https://example.com/images/10001001/alt1.jpg',0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(3,10001002,'https://example.com/images/10001002/main.jpg',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(4,10001002,'https://example.com/images/10001002/alt1.jpg',0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(5,10001002,'https://example.com/images/10001002/alt2.jpg',0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(6,10001003,'https://example.com/images/10001003/main.jpg',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(7,10001003,'https://example.com/images/10001003/alt1.jpg',0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(8,10001004,'https://example.com/images/10001004/main.jpg',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(9,10001005,'https://example.com/images/10001005/main.jpg',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10,10001006,'https://example.com/images/10001006/main.jpg',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(11,10001007,'https://example.com/images/10001007/main.jpg',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(12,10001008,'https://example.com/images/10001008/main.jpg',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(13,10001009,'https://example.com/images/10001009/main.jpg',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(14,10001010,'https://example.com/images/10001010/main.jpg',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(15,10001011,'https://example.com/images/10001011/main.jpg',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(16,10001012,'https://example.com/images/10001012/main.jpg',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(17,10001013,'https://example.com/images/10001013/main.jpg',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(18,10001014,'https://example.com/images/10001014/main.jpg',1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(19,10001015,'https://example.com/images/10001015/main.jpg',1,'2025-06-28 12:27:56','2025-06-28 12:27:56');
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `product_ratings`
--

DROP TABLE IF EXISTS `product_ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_ratings` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '評価ID',
  `product_id` int unsigned NOT NULL COMMENT '商品ID',
  `user_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '評価を行ったユーザーID',
  `rate` int NOT NULL COMMENT '評価（1〜5）',
  `rated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '評価日時',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `product_ratings_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `product_ratings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `product_ratings_chk_1` CHECK ((`rate` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_ratings`
--

LOCK TABLES `product_ratings` WRITE;
/*!40000 ALTER TABLE `product_ratings` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `product_ratings` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `product_stocks`
--

DROP TABLE IF EXISTS `product_stocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_stocks` (
  `product_id` int unsigned NOT NULL COMMENT '商品ID',
  `stock_quantity` int unsigned NOT NULL COMMENT '在庫数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_id`),
  CONSTRAINT `product_stocks_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_stocks`
--

LOCK TABLES `product_stocks` WRITE;
/*!40000 ALTER TABLE `product_stocks` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `product_stocks` VALUES (10001001,10000,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001002,5000,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001003,2000,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001004,1000,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001005,3000,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001006,8000,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001007,4000,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001008,2500,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001009,10000,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001010,1500,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001011,800,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001012,700,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001013,3500,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001014,5000,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001015,1000,'2025-06-28 12:27:56','2025-06-28 12:27:56');
/*!40000 ALTER TABLE `product_stocks` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int unsigned NOT NULL COMMENT '商品ID',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商品名',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '商品説明',
  `price` decimal(10,2) NOT NULL COMMENT '税込価格',
  `category_id` int unsigned NOT NULL COMMENT 'カテゴリID',
  `discount_id` int unsigned DEFAULT NULL COMMENT '割引ID（NULL可）',
  `vip_only` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'VIP限定フラグ',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_discount_id` (`discount_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category_master` (`id`),
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`discount_id`) REFERENCES `discount_master` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `products` VALUES (10001001,'無料ジェム100個','ログインボーナスなどで獲得できる無償通貨。',0.00,1,NULL,0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001002,'有償ジェム500個','ショップで購入できる有償通貨パック。',1200.00,2,1,0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001003,'10連ガチャチケット','10連ガチャが1回引けるチケット。',3000.00,3,2,1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001004,'限定スキンセット','期間限定のキャラスキンを含むアイテムパック。',4800.00,4,NULL,1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001005,'覚醒素材パック','キャラクター育成に使用する覚醒素材一式。',1800.00,5,3,0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001006,'無料ジェム200個','イベント報酬などで獲得できる無償通貨。',0.00,1,NULL,0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001007,'有償ジェム1000個','お得な有償通貨大容量パック。',2200.00,2,2,0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001008,'有償ジェム2000個 + ボーナス付き','大量購入でボーナス付きのジェムパック。',4200.00,2,3,1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001009,'単発ガチャチケット','1回分のガチャチケット。',300.00,3,NULL,0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001010,'★5確定ガチャチケット','★5キャラが1体確定で出現する特別なチケット。',5000.00,3,4,1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001011,'限定武器パック','イベント限定武器を含むセット。',3500.00,4,2,1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001012,'コラボ記念スキン','コラボキャラ専用スキン。',4000.00,4,1,1,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001013,'進化石セット','進化に必要な石を集めたお得なセット。',1500.00,5,NULL,0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001014,'強化素材まとめ売り','EXP素材をまとめて手に入るパック。',1000.00,5,4,0,'2025-06-28 12:27:56','2025-06-28 12:27:56'),(10001015,'特級育成セット','高レア素材を含む豪華育成パック。',2500.00,5,5,1,'2025-06-28 12:27:56','2025-06-28 12:27:56');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `reservation_products`
--

DROP TABLE IF EXISTS `reservation_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation_products` (
  `reservation_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '予約ID',
  `product_id` int unsigned NOT NULL COMMENT '予約された商品ID',
  `quantity` int unsigned NOT NULL COMMENT '数量',
  `unit_price` int unsigned NOT NULL COMMENT '予約時点の単価',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`reservation_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `reservation_products_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`),
  CONSTRAINT `reservation_products_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation_products`
--

LOCK TABLES `reservation_products` WRITE;
/*!40000 ALTER TABLE `reservation_products` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `reservation_products` VALUES ('0197b73c-2920-75a9-9941-1a66ffb59f09',10001001,1,0,'2025-06-28 15:51:02','2025-06-28 15:51:02'),('0197b73c-2920-75a9-9941-1a66ffb59f09',10001003,1,2400,'2025-06-28 15:51:02','2025-06-28 15:51:02'),('0197b73c-2920-75a9-9941-1a66ffb59f09',10001009,3,300,'2025-06-28 15:51:02','2025-06-28 15:51:02'),('0197b73c-2920-75a9-9941-1a66ffb59f09',10001014,2,850,'2025-06-28 15:51:02','2025-06-28 15:51:02'),('0197b745-baad-7a03-9ccc-26b6383301cf',10001001,1,0,'2025-06-28 16:01:29','2025-06-28 16:01:29'),('0197b745-baad-7a03-9ccc-26b6383301cf',10001003,1,2400,'2025-06-28 16:01:29','2025-06-28 16:01:29'),('0197b745-baad-7a03-9ccc-26b6383301cf',10001009,3,300,'2025-06-28 16:01:29','2025-06-28 16:01:29'),('0197b745-baad-7a03-9ccc-26b6383301cf',10001014,2,850,'2025-06-28 16:01:29','2025-06-28 16:01:29'),('30000000-0000-0000-0000-000000000001',10001002,1,1000,'2025-06-12 10:00:00','2025-06-12 10:00:00'),('30000000-0000-0000-0000-000000000001',10001005,2,1000,'2025-06-12 10:00:00','2025-06-12 10:00:00'),('30000000-0000-0000-0000-000000000002',10001009,1,1000,'2025-06-11 09:30:00','2025-06-11 09:30:00'),('30000000-0000-0000-0000-000000000002',10001013,3,1000,'2025-06-11 09:30:00','2025-06-11 09:30:00'),('30000000-0000-0000-0000-000000000003',10001001,1,1000,'2025-06-12 11:00:00','2025-06-12 11:00:00'),('30000000-0000-0000-0000-000000000003',10001010,1,1000,'2025-06-12 11:00:00','2025-06-12 11:00:00'),('30000000-0000-0000-0000-000000000004',10001003,1,1000,'2025-06-12 12:00:00','2025-06-12 12:00:00'),('30000000-0000-0000-0000-000000000004',10001011,1,1000,'2025-06-12 12:00:00','2025-06-12 12:00:00'),('30000000-0000-0000-0000-000000000005',10001004,1,1000,'2025-06-11 08:00:00','2025-06-11 08:00:00'),('30000000-0000-0000-0000-000000000005',10001007,2,1000,'2025-06-11 08:00:00','2025-06-11 08:00:00'),('30000000-0000-0000-0000-000000000006',10001002,1,1000,'2025-06-12 13:00:00','2025-06-12 13:00:00'),('30000000-0000-0000-0000-000000000006',10001008,1,1000,'2025-06-12 13:00:00','2025-06-12 13:00:00'),('30000000-0000-0000-0000-000000000007',10001001,2,1000,'2025-06-12 14:00:00','2025-06-12 14:00:00'),('30000000-0000-0000-0000-000000000008',10001005,1,1000,'2025-06-12 15:00:00','2025-06-12 15:00:00'),('30000000-0000-0000-0000-000000000008',10001010,3,1000,'2025-06-12 15:00:00','2025-06-12 15:00:00'),('30000000-0000-0000-0000-000000000009',10001009,1,1000,'2025-06-12 16:00:00','2025-06-12 16:00:00'),('30000000-0000-0000-0000-000000000010',10001011,2,1000,'2025-06-12 17:00:00','2025-06-12 17:00:00'),('30000000-0000-0000-0000-000000000010',10001013,1,1000,'2025-06-12 17:00:00','2025-06-12 17:00:00'),('30000000-0000-0000-0000-000000000011',10001001,1,1000,'2025-06-12 18:00:00','2025-06-12 18:00:00'),('30000000-0000-0000-0000-000000000011',10001003,2,1000,'2025-06-12 18:00:00','2025-06-12 18:00:00'),('30000000-0000-0000-0000-000000000012',10001004,1,1000,'2025-06-12 19:00:00','2025-06-12 19:00:00'),('30000000-0000-0000-0000-000000000013',10001007,3,1000,'2025-06-12 20:00:00','2025-06-12 20:00:00'),('30000000-0000-0000-0000-000000000014',10001002,1,1000,'2025-06-12 21:00:00','2025-06-12 21:00:00'),('30000000-0000-0000-0000-000000000014',10001010,2,1000,'2025-06-12 21:00:00','2025-06-12 21:00:00'),('30000000-0000-0000-0000-000000000015',10001013,1,1000,'2025-06-12 22:00:00','2025-06-12 22:00:00'),('30000000-0000-0000-0000-000000000016',10001005,1,1000,'2025-06-12 23:00:00','2025-06-12 23:00:00'),('30000000-0000-0000-0000-000000000016',10001008,1,1000,'2025-06-12 23:00:00','2025-06-12 23:00:00'),('30000000-0000-0000-0000-000000000017',10001001,2,1000,'2025-06-13 00:00:00','2025-06-13 00:00:00'),('30000000-0000-0000-0000-000000000018',10001003,1,1000,'2025-06-13 01:00:00','2025-06-13 01:00:00'),('30000000-0000-0000-0000-000000000018',10001009,3,1000,'2025-06-13 01:00:00','2025-06-13 01:00:00'),('30000000-0000-0000-0000-000000000019',10001004,1,1000,'2025-06-13 02:00:00','2025-06-13 02:00:00'),('30000000-0000-0000-0000-000000000020',10001007,2,1000,'2025-06-13 03:00:00','2025-06-13 03:00:00'),('30000000-0000-0000-0000-000000000021',10001002,1,1000,'2025-06-13 04:00:00','2025-06-13 04:00:00'),('30000000-0000-0000-0000-000000000022',10001010,3,1000,'2025-06-13 05:00:00','2025-06-13 05:00:00'),('30000000-0000-0000-0000-000000000023',10001011,1,1000,'2025-06-13 06:00:00','2025-06-13 06:00:00'),('30000000-0000-0000-0000-000000000024',10001013,2,1000,'2025-06-13 07:00:00','2025-06-13 07:00:00'),('30000000-0000-0000-0000-000000000025',10001001,1,1000,'2025-06-13 08:00:00','2025-06-13 08:00:00'),('30000000-0000-0000-0000-000000000026',10001003,2,1000,'2025-06-13 09:00:00','2025-06-13 09:00:00'),('30000000-0000-0000-0000-000000000027',10001004,1,1000,'2025-06-13 10:00:00','2025-06-13 10:00:00'),('30000000-0000-0000-0000-000000000028',10001005,1,1000,'2025-06-13 11:00:00','2025-06-13 11:00:00'),('30000000-0000-0000-0000-000000000029',10001007,2,1000,'2025-06-13 12:00:00','2025-06-13 12:00:00'),('30000000-0000-0000-0000-000000000030',10001008,1,1000,'2025-06-13 13:00:00','2025-06-13 13:00:00'),('30000000-0000-0000-0000-000000000031',10001009,3,1000,'2025-06-13 14:00:00','2025-06-13 14:00:00'),('30000000-0000-0000-0000-000000000032',10001010,1,1000,'2025-06-13 15:00:00','2025-06-13 15:00:00'),('30000000-0000-0000-0000-000000000033',10001011,2,1000,'2025-06-13 16:00:00','2025-06-13 16:00:00'),('30000000-0000-0000-0000-000000000034',10001013,1,1000,'2025-06-13 17:00:00','2025-06-13 17:00:00'),('30000000-0000-0000-0000-000000000035',10001001,1,1000,'2025-06-13 18:00:00','2025-06-13 18:00:00'),('30000000-0000-0000-0000-000000000036',10001003,3,1000,'2025-06-13 19:00:00','2025-06-13 19:00:00'),('30000000-0000-0000-0000-000000000037',10001004,2,1000,'2025-06-13 20:00:00','2025-06-13 20:00:00'),('30000000-0000-0000-0000-000000000038',10001005,1,1000,'2025-06-13 21:00:00','2025-06-13 21:00:00'),('30000000-0000-0000-0000-000000000039',10001007,3,1000,'2025-06-13 22:00:00','2025-06-13 22:00:00'),('30000000-0000-0000-0000-000000000040',10001008,1,1000,'2025-06-13 23:00:00','2025-06-13 23:00:00'),('30000000-0000-0000-0000-000000000041',10001009,2,1000,'2025-06-14 00:00:00','2025-06-14 00:00:00'),('30000000-0000-0000-0000-000000000042',10001010,1,1000,'2025-06-14 01:00:00','2025-06-14 01:00:00'),('30000000-0000-0000-0000-000000000043',10001011,3,1000,'2025-06-14 02:00:00','2025-06-14 02:00:00'),('30000000-0000-0000-0000-000000000044',10001013,1,1000,'2025-06-14 03:00:00','2025-06-14 03:00:00'),('30000000-0000-0000-0000-000000000045',10001001,2,1000,'2025-06-14 04:00:00','2025-06-14 04:00:00'),('30000000-0000-0000-0000-000000000046',10001003,1,1000,'2025-06-14 05:00:00','2025-06-14 05:00:00'),('30000000-0000-0000-0000-000000000047',10001004,3,1000,'2025-06-14 06:00:00','2025-06-14 06:00:00'),('30000000-0000-0000-0000-000000000048',10001005,1,1000,'2025-06-14 07:00:00','2025-06-14 07:00:00'),('30000000-0000-0000-0000-000000000049',10001007,2,1000,'2025-06-14 08:00:00','2025-06-14 08:00:00'),('30000000-0000-0000-0000-000000000050',10001008,1,1000,'2025-06-14 09:00:00','2025-06-14 09:00:00');
/*!40000 ALTER TABLE `reservation_products` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservations` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '予約ID',
  `user_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '予約を行ったユーザーID',
  `reserved_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '予約日時',
  `expired_at` datetime NOT NULL COMMENT '失効日時',
  `status` enum('pending','confirmed','canceled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending' COMMENT '予約ステータス',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservations`
--

LOCK TABLES `reservations` WRITE;
/*!40000 ALTER TABLE `reservations` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `reservations` VALUES ('0197b73c-2920-75a9-9941-1a66ffb59f09','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','2025-06-28 15:51:03','2025-06-28 16:06:03','confirmed','2025-06-28 15:51:02','2025-06-28 15:51:36'),('0197b745-baad-7a03-9ccc-26b6383301cf','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','2025-06-28 16:01:30','2025-06-28 16:16:30','confirmed','2025-06-28 16:01:29','2025-06-28 16:01:48'),('30000000-0000-0000-0000-000000000001','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','2025-06-12 10:00:00','2025-06-12 10:15:00','confirmed','2025-06-12 10:00:00','2025-06-12 10:00:00'),('30000000-0000-0000-0000-000000000002','00000000-0000-0000-0000-000000000005','2025-06-12 10:05:00','2025-06-12 10:20:00','confirmed','2025-06-12 10:05:00','2025-06-12 10:05:00'),('30000000-0000-0000-0000-000000000003','00000000-0000-0000-0000-000000000007','2025-06-12 10:10:00','2025-06-12 10:25:00','pending','2025-06-12 10:10:00','2025-06-12 10:10:00'),('30000000-0000-0000-0000-000000000004','00000000-0000-0000-0000-000000000010','2025-06-12 10:15:00','2025-06-12 10:30:00','confirmed','2025-06-12 10:15:00','2025-06-12 10:15:00'),('30000000-0000-0000-0000-000000000005','00000000-0000-0000-0000-000000000012','2025-06-12 10:20:00','2025-06-12 10:35:00','canceled','2025-06-12 10:20:00','2025-06-12 10:35:00'),('30000000-0000-0000-0000-000000000006','00000000-0000-0000-0000-000000000014','2025-06-12 10:25:00','2025-06-12 10:40:00','confirmed','2025-06-12 10:25:00','2025-06-12 10:25:00'),('30000000-0000-0000-0000-000000000007','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','2025-06-12 10:30:00','2025-06-12 10:45:00','confirmed','2025-06-12 10:30:00','2025-06-12 10:30:00'),('30000000-0000-0000-0000-000000000008','00000000-0000-0000-0000-000000000005','2025-06-12 10:35:00','2025-06-12 10:50:00','pending','2025-06-12 10:35:00','2025-06-12 10:35:00'),('30000000-0000-0000-0000-000000000009','00000000-0000-0000-0000-000000000007','2025-06-12 10:40:00','2025-06-12 10:55:00','confirmed','2025-06-12 10:40:00','2025-06-12 10:40:00'),('30000000-0000-0000-0000-000000000010','00000000-0000-0000-0000-000000000010','2025-06-12 10:45:00','2025-06-12 11:00:00','confirmed','2025-06-12 10:45:00','2025-06-12 10:45:00'),('30000000-0000-0000-0000-000000000011','00000000-0000-0000-0000-000000000012','2025-06-12 10:50:00','2025-06-12 11:05:00','canceled','2025-06-12 10:50:00','2025-06-12 11:05:00'),('30000000-0000-0000-0000-000000000012','00000000-0000-0000-0000-000000000014','2025-06-12 10:55:00','2025-06-12 11:10:00','confirmed','2025-06-12 10:55:00','2025-06-12 10:55:00'),('30000000-0000-0000-0000-000000000013','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','2025-06-12 11:00:00','2025-06-12 11:15:00','confirmed','2025-06-12 11:00:00','2025-06-12 11:00:00'),('30000000-0000-0000-0000-000000000014','00000000-0000-0000-0000-000000000005','2025-06-12 11:05:00','2025-06-12 11:20:00','pending','2025-06-12 11:05:00','2025-06-12 11:05:00'),('30000000-0000-0000-0000-000000000015','00000000-0000-0000-0000-000000000007','2025-06-12 11:10:00','2025-06-12 11:25:00','confirmed','2025-06-12 11:10:00','2025-06-12 11:10:00'),('30000000-0000-0000-0000-000000000016','00000000-0000-0000-0000-000000000010','2025-06-12 11:15:00','2025-06-12 11:30:00','confirmed','2025-06-12 11:15:00','2025-06-12 11:15:00'),('30000000-0000-0000-0000-000000000017','00000000-0000-0000-0000-000000000012','2025-06-12 11:20:00','2025-06-12 11:35:00','canceled','2025-06-12 11:20:00','2025-06-12 11:35:00'),('30000000-0000-0000-0000-000000000018','00000000-0000-0000-0000-000000000014','2025-06-12 11:25:00','2025-06-12 11:40:00','confirmed','2025-06-12 11:25:00','2025-06-12 11:25:00'),('30000000-0000-0000-0000-000000000019','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','2025-06-12 11:30:00','2025-06-12 11:45:00','confirmed','2025-06-12 11:30:00','2025-06-12 11:30:00'),('30000000-0000-0000-0000-000000000020','00000000-0000-0000-0000-000000000005','2025-06-12 11:35:00','2025-06-12 11:50:00','pending','2025-06-12 11:35:00','2025-06-12 11:35:00'),('30000000-0000-0000-0000-000000000021','00000000-0000-0000-0000-000000000007','2025-06-12 11:40:00','2025-06-12 11:55:00','confirmed','2025-06-12 11:40:00','2025-06-12 11:40:00'),('30000000-0000-0000-0000-000000000022','00000000-0000-0000-0000-000000000010','2025-06-12 11:45:00','2025-06-12 12:00:00','confirmed','2025-06-12 11:45:00','2025-06-12 11:45:00'),('30000000-0000-0000-0000-000000000023','00000000-0000-0000-0000-000000000012','2025-06-12 11:50:00','2025-06-12 12:05:00','canceled','2025-06-12 11:50:00','2025-06-12 12:05:00'),('30000000-0000-0000-0000-000000000024','00000000-0000-0000-0000-000000000014','2025-06-12 11:55:00','2025-06-12 12:10:00','confirmed','2025-06-12 11:55:00','2025-06-12 11:55:00'),('30000000-0000-0000-0000-000000000025','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','2025-06-12 12:00:00','2025-06-12 12:15:00','confirmed','2025-06-12 12:00:00','2025-06-12 12:00:00'),('30000000-0000-0000-0000-000000000026','00000000-0000-0000-0000-000000000005','2025-06-12 12:05:00','2025-06-12 12:20:00','pending','2025-06-12 12:05:00','2025-06-12 12:05:00'),('30000000-0000-0000-0000-000000000027','00000000-0000-0000-0000-000000000007','2025-06-12 12:10:00','2025-06-12 12:25:00','confirmed','2025-06-12 12:10:00','2025-06-12 12:10:00'),('30000000-0000-0000-0000-000000000028','00000000-0000-0000-0000-000000000010','2025-06-12 12:15:00','2025-06-12 12:30:00','confirmed','2025-06-12 12:15:00','2025-06-12 12:15:00'),('30000000-0000-0000-0000-000000000029','00000000-0000-0000-0000-000000000012','2025-06-12 12:20:00','2025-06-12 12:35:00','canceled','2025-06-12 12:20:00','2025-06-12 12:35:00'),('30000000-0000-0000-0000-000000000030','00000000-0000-0000-0000-000000000014','2025-06-12 12:25:00','2025-06-12 12:40:00','confirmed','2025-06-12 12:25:00','2025-06-12 12:25:00'),('30000000-0000-0000-0000-000000000031','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','2025-06-12 12:30:00','2025-06-12 12:45:00','confirmed','2025-06-12 12:30:00','2025-06-12 12:30:00'),('30000000-0000-0000-0000-000000000032','00000000-0000-0000-0000-000000000005','2025-06-12 12:35:00','2025-06-12 12:50:00','pending','2025-06-12 12:35:00','2025-06-12 12:35:00'),('30000000-0000-0000-0000-000000000033','00000000-0000-0000-0000-000000000007','2025-06-12 12:40:00','2025-06-12 12:55:00','confirmed','2025-06-12 12:40:00','2025-06-12 12:40:00'),('30000000-0000-0000-0000-000000000034','00000000-0000-0000-0000-000000000010','2025-06-12 12:45:00','2025-06-12 13:00:00','confirmed','2025-06-12 12:45:00','2025-06-12 12:45:00'),('30000000-0000-0000-0000-000000000035','00000000-0000-0000-0000-000000000012','2025-06-12 12:50:00','2025-06-12 13:05:00','canceled','2025-06-12 12:50:00','2025-06-12 13:05:00'),('30000000-0000-0000-0000-000000000036','00000000-0000-0000-0000-000000000014','2025-06-12 12:55:00','2025-06-12 13:10:00','confirmed','2025-06-12 12:55:00','2025-06-12 12:55:00'),('30000000-0000-0000-0000-000000000037','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','2025-06-12 13:00:00','2025-06-12 13:15:00','confirmed','2025-06-12 13:00:00','2025-06-12 13:00:00'),('30000000-0000-0000-0000-000000000038','00000000-0000-0000-0000-000000000005','2025-06-12 13:05:00','2025-06-12 13:20:00','pending','2025-06-12 13:05:00','2025-06-12 13:05:00'),('30000000-0000-0000-0000-000000000039','00000000-0000-0000-0000-000000000007','2025-06-12 13:10:00','2025-06-12 13:25:00','confirmed','2025-06-12 13:10:00','2025-06-12 13:10:00'),('30000000-0000-0000-0000-000000000040','00000000-0000-0000-0000-000000000010','2025-06-12 13:15:00','2025-06-12 13:30:00','confirmed','2025-06-12 13:15:00','2025-06-12 13:15:00'),('30000000-0000-0000-0000-000000000041','00000000-0000-0000-0000-000000000012','2025-06-12 13:20:00','2025-06-12 13:35:00','canceled','2025-06-12 13:20:00','2025-06-12 13:35:00'),('30000000-0000-0000-0000-000000000042','00000000-0000-0000-0000-000000000014','2025-06-12 13:25:00','2025-06-12 13:40:00','confirmed','2025-06-12 13:25:00','2025-06-12 13:25:00'),('30000000-0000-0000-0000-000000000043','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','2025-06-12 13:30:00','2025-06-12 13:45:00','confirmed','2025-06-12 13:30:00','2025-06-12 13:30:00'),('30000000-0000-0000-0000-000000000044','00000000-0000-0000-0000-000000000005','2025-06-12 13:35:00','2025-06-12 13:50:00','pending','2025-06-12 13:35:00','2025-06-12 13:35:00'),('30000000-0000-0000-0000-000000000045','00000000-0000-0000-0000-000000000007','2025-06-12 13:40:00','2025-06-12 13:55:00','confirmed','2025-06-12 13:40:00','2025-06-12 13:40:00'),('30000000-0000-0000-0000-000000000046','00000000-0000-0000-0000-000000000010','2025-06-12 13:45:00','2025-06-12 14:00:00','confirmed','2025-06-12 13:45:00','2025-06-12 13:45:00'),('30000000-0000-0000-0000-000000000047','00000000-0000-0000-0000-000000000012','2025-06-12 13:50:00','2025-06-12 14:05:00','canceled','2025-06-12 13:50:00','2025-06-12 14:05:00'),('30000000-0000-0000-0000-000000000048','00000000-0000-0000-0000-000000000014','2025-06-12 13:55:00','2025-06-12 14:10:00','confirmed','2025-06-12 13:55:00','2025-06-12 13:55:00'),('30000000-0000-0000-0000-000000000049','01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','2025-06-12 14:00:00','2025-06-12 14:15:00','confirmed','2025-06-12 14:00:00','2025-06-12 14:00:00'),('30000000-0000-0000-0000-000000000050','00000000-0000-0000-0000-000000000005','2025-06-12 14:05:00','2025-06-12 14:20:00','pending','2025-06-12 14:05:00','2025-06-12 14:05:00');
/*!40000 ALTER TABLE `reservations` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ユーザーID',
  `username` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ユーザー名',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ユーザーのメールアドレス',
  `role` enum('general','admin','beta_tester') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ユーザーの権限',
  `status` enum('active','inactive','banned') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ユーザーのステータス',
  `last_login_at` datetime NOT NULL COMMENT '最終ログイン日時',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `users` VALUES ('00000000-0000-0000-0000-000000000002','user02','user02@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000003','user03','user03@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000004','user04','user04@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000005','user05','user05@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000006','user06','user06@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000007','user07','user07@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000008','user08','user08@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000009','user09','user09@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000010','user10','user10@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000011','user11','user11@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000012','user12','user12@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000013','user13','user13@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000014','user14','user14@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000015','user15','user15@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000016','user16','user16@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000017','user17','user17@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000018','user18','user18@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000019','user19','user19@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000020','user20','user20@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000021','user21','user21@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000022','user22','user22@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000023','user23','user23@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000024','user24','user24@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000025','user25','user25@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000026','user26','user26@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000027','user27','user27@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000028','user28','user28@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000029','user29','user29@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('00000000-0000-0000-0000-000000000030','user30','user30@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56'),('01975ff1-5ba9-73ca-be9a-75aa6bb00aaf','user01','user01@example.com','general','active','2025-06-28 12:27:56','2025-06-28 12:27:56','2025-06-28 12:27:56');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-29  1:26:05
