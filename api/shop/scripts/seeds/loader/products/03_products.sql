INSERT INTO `products` (`id`, `name`, `description`, `price`, `category_id`, `discount_id`, `vip_only`) VALUES
  -- 無償通貨 (category_id = 1)
  (10001001, '無料ジェム100個', 'ログインボーナスなどで獲得できる無償通貨。', 0.00, 1, NULL, FALSE),
  (10001006, '無料ジェム200個', 'イベント報酬などで獲得できる無償通貨。', 0.00, 1, NULL, FALSE),

  -- 有償通貨 (category_id = 2)
  (10001002, '有償ジェム500個', 'ショップで購入できる有償通貨パック。', 1200.00, 2, 1, FALSE),
  (10001007, '有償ジェム1000個', 'お得な有償通貨大容量パック。', 2200.00, 2, 2, FALSE),
  (10001008, '有償ジェム2000個 + ボーナス付き', '大量購入でボーナス付きのジェムパック。', 4200.00, 2, 3, TRUE),

  -- ガチャチケット (category_id = 3)
  (10001003, '10連ガチャチケット', '10連ガチャが1回引けるチケット。', 3000.00, 3, 2, TRUE),
  (10001009, '単発ガチャチケット', '1回分のガチャチケット。', 300.00, 3, NULL, FALSE),
  (10001010, '★5確定ガチャチケット', '★5キャラが1体確定で出現する特別なチケット。', 5000.00, 3, 4, TRUE),

  -- 限定アイテム (category_id = 4)
  (10001004, '限定スキンセット', '期間限定のキャラスキンを含むアイテムパック。', 4800.00, 4, NULL, TRUE),
  (10001011, '限定武器パック', 'イベント限定武器を含むセット。', 3500.00, 4, 2, TRUE),
  (10001012, 'コラボ記念スキン', 'コラボキャラ専用スキン。', 4000.00, 4, 1, TRUE),

  -- 育成素材 (category_id = 5)
  (10001005, '覚醒素材パック', 'キャラクター育成に使用する覚醒素材一式。', 1800.00, 5, 3, FALSE),
  (10001013, '進化石セット', '進化に必要な石を集めたお得なセット。', 1500.00, 5, NULL, FALSE),
  (10001014, '強化素材まとめ売り', 'EXP素材をまとめて手に入るパック。', 1000.00, 5, 4, FALSE),
  (10001015, '特級育成セット', '高レア素材を含む豪華育成パック。', 2500.00, 5, 5, TRUE);
