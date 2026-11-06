-- Fictional sample records for E-commerce and Online Shopping Management.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customers" ("customer_id", "email", "display_name", "created_at") VALUES (1001, 'ava@example.test', 'Ava Sample', '2026-01-10');
INSERT INTO portfolio."customers" ("customer_id", "email", "display_name", "created_at") VALUES (1002, 'noah@example.test', 'Noah Sample', '2026-02-14');
INSERT INTO portfolio."products" ("product_id", "sku", "product_name", "unit_price", "available_quantity", "active") VALUES (2001, 'SYN-001', 'Synthetic Mug', 12.5, 20, TRUE);
INSERT INTO portfolio."products" ("product_id", "sku", "product_name", "unit_price", "available_quantity", "active") VALUES (2002, 'SYN-002', 'Synthetic Notebook', 8.75, 35, TRUE);
INSERT INTO portfolio."orders" ("order_id", "customer_id", "placed_at", "status") VALUES (3001, 1001, '2026-03-01T10:15:00Z', 'completed');
INSERT INTO portfolio."orders" ("order_id", "customer_id", "placed_at", "status") VALUES (3002, 1002, '2026-03-02T13:30:00+00:00', 'placed');
INSERT INTO portfolio."order_lines" ("line_id", "order_id", "product_id", "quantity", "captured_unit_price") VALUES (4001, 3001, 2001, 2, 12.5);
INSERT INTO portfolio."order_lines" ("line_id", "order_id", "product_id", "quantity", "captured_unit_price") VALUES (4002, 3002, 2002, 1, 8.75);
COMMIT;
