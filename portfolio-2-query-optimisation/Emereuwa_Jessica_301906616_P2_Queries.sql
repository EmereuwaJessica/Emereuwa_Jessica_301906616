-- Show related order_lines, products records (up to 20).
SELECT t0."line_id" AS "order_lines_line_id",
       t0."quantity" AS "order_lines_quantity",
       t1."product_id" AS "products_product_id",
       t1."sku" AS "products_sku"
FROM portfolio."order_lines" t0
JOIN portfolio."products" t1 ON t0."product_id" = t1."product_id"
ORDER BY t0."line_id", t1."product_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."line_id" AS "order_lines_line_id",
       t0."quantity" AS "order_lines_quantity",
       t1."product_id" AS "products_product_id",
       t1."sku" AS "products_sku"
FROM portfolio."order_lines" t0
JOIN portfolio."products" t1 ON t0."product_id" = t1."product_id"
ORDER BY t0."line_id", t1."product_id"
LIMIT 20;

-- Find orders records where placed_at matches "2026-03-01T10:15:00Z" (up to 20).
SELECT * FROM portfolio."orders"
WHERE "placed_at" IS NOT DISTINCT FROM '2026-03-01T10:15:00Z'
ORDER BY "order_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."orders"
WHERE "placed_at" IS NOT DISTINCT FROM '2026-03-01T10:15:00Z'
ORDER BY "order_id"
LIMIT 20;

-- Count orders records for each customer_id (up to 20 groups).
SELECT "customer_id", count(*) AS record_count
FROM portfolio."orders"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "customer_id", count(*) AS record_count
FROM portfolio."orders"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;
