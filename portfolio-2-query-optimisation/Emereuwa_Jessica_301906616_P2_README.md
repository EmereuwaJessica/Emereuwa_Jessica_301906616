# E-commerce and Online Shopping Management — SQL queries

## 1. Show related order_lines, products records (up to 20).

```sql
SELECT t0."line_id" AS "order_lines_line_id",
       t0."quantity" AS "order_lines_quantity",
       t1."product_id" AS "products_product_id",
       t1."sku" AS "products_sku"
FROM portfolio."order_lines" t0
JOIN portfolio."products" t1 ON t0."product_id" = t1."product_id"
ORDER BY t0."line_id", t1."product_id"
LIMIT 20;
```

| order_lines_line_id | order_lines_quantity | products_product_id | products_sku |
| --- | --- | --- | --- |
| 4001 | 2 | 2001 | SYN-001 |
| 4002 | 1 | 2002 | SYN-002 |

## 2. Find orders records where placed_at matches "2026-03-01T10:15:00Z" (up to 20).

```sql
SELECT * FROM portfolio."orders"
WHERE "placed_at" IS NOT DISTINCT FROM '2026-03-01T10:15:00Z'
ORDER BY "order_id"
LIMIT 20;
```

| order_id | customer_id | placed_at | status |
| --- | --- | --- | --- |
| 3001 | 1001 | 2026-03-01T10:15:00+00:00 | completed |

## 3. Count orders records for each customer_id (up to 20 groups).

```sql
SELECT "customer_id", count(*) AS record_count
FROM portfolio."orders"
GROUP BY "customer_id"
ORDER BY record_count DESC, "customer_id" NULLS LAST
LIMIT 20;
```

| customer_id | record_count |
| --- | --- |
| 1001 | 1 |
| 1002 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.396 | 2.392, 2.416, 2.396 | Sort → Seq Scan | 274 |
| After index | 0.355 | 0.264, 0.355, 0.406 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.396 ms to 0.355 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.362..2.365 rows=50 loops=1)
  Seq Scan on orders (actual time=0.014..2.325 rows=50 loops=1)
Planning Time: 0.321 ms
Execution Time: 2.392 ms
```

### Before index, run 2

```text
Sort (actual time=2.389..2.391 rows=50 loops=1)
  Seq Scan on orders (actual time=0.013..2.35 rows=50 loops=1)
Planning Time: 0.31 ms
Execution Time: 2.416 ms
```

### Before index, run 3

```text
Sort (actual time=2.368..2.371 rows=50 loops=1)
  Seq Scan on orders (actual time=0.013..2.329 rows=50 loops=1)
Planning Time: 0.315 ms
Execution Time: 2.396 ms
```

### After index, run 1

```text
Sort (actual time=0.211..0.214 rows=50 loops=1)
  Bitmap Heap Scan on orders (actual time=0.031..0.158 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.531 ms
Execution Time: 0.264 ms
```

### After index, run 2

```text
Sort (actual time=0.277..0.281 rows=50 loops=1)
  Bitmap Heap Scan on orders (actual time=0.042..0.22 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.022..0.022 rows=50 loops=1)
Planning Time: 2.618 ms
Execution Time: 0.355 ms
```

### After index, run 3

```text
Sort (actual time=0.323..0.327 rows=50 loops=1)
  Bitmap Heap Scan on orders (actual time=0.048..0.238 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.026..0.026 rows=50 loops=1)
Planning Time: 1.531 ms
Execution Time: 0.406 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Emereuwa_Jessica_301906616_P2_Queries.sql, then Emereuwa_Jessica_301906616_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Emereuwa_Jessica_301906616_P2_QueryResults.png) · [Index comparison](screenshots/Emereuwa_Jessica_301906616_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

