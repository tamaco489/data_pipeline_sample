-- name: GetProductByID :one
SELECT 
  p.id AS product_id,
  p.name AS product_name,
  p.description,
  CAST(p.price * 100 AS UNSIGNED) AS price,
  p.vip_only,
  cm.name AS category_name,
  dm.name AS discount_name,
  dm.rate AS discount_rate,
  ps.stock_quantity,
  pi.image_url AS main_image_url,
  CAST(COALESCE(AVG(pr.rate), 0) AS UNSIGNED) AS average_rating,
  COUNT(pr.rate) AS rating_count
FROM products p
INNER JOIN category_master cm ON p.category_id = cm.id
LEFT JOIN discount_master dm ON p.discount_id = dm.id
INNER JOIN product_stocks ps ON p.id = ps.product_id
LEFT JOIN product_images pi ON p.id = pi.product_id AND pi.is_main = TRUE
LEFT JOIN product_ratings pr ON p.id = pr.product_id
WHERE p.id = sqlc.arg('product_id')
GROUP BY
  p.id, p.name, p.description, p.price, p.vip_only,
  cm.name, dm.name, dm.rate,
  ps.stock_quantity, pi.image_url;

-- name: GetProductsByIDs :many
SELECT
  p.id AS product_id,
  FLOOR(p.price) AS product_price,
  dm.rate AS discount_rate,
  ps.stock_quantity AS product_stock_quantity
FROM products as p
INNER JOIN category_master as cm ON p.category_id = cm.id
INNER JOIN product_stocks as ps ON p.id = ps.product_id
LEFT JOIN discount_master as dm ON p.discount_id = dm.id
WHERE p.id IN (sqlc.slice('product_ids'))
ORDER BY p.id;
