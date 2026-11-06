-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. reject customers pk. Expected: pk_customers, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("customer_id", "email", "display_name", "created_at")
VALUES (1001, 'pk-conflict@example.test', 'PK Conflict', '2026-03-03');

-- 2. reject customers email. Expected: uq_customers_0, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("customer_id", "email", "display_name", "created_at")
VALUES (1101, 'ava@example.test', 'Email Conflict', '2026-03-03');

-- 3. reject customers customer id null. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "email", "display_name", "created_at")
VALUES (NULL, 'null-customer-id@example.test', 'Null Customer ID', '2026-03-03');

-- 4. reject customers email null. Expected: email, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "email", "display_name", "created_at")
VALUES (1102, NULL, 'Null Email', '2026-03-03');

-- 5. reject customers display name null. Expected: display_name, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "email", "display_name", "created_at")
VALUES (1103, 'null-name@example.test', NULL, '2026-03-03');

-- 6. reject customers created at null. Expected: created_at, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("customer_id", "email", "display_name", "created_at")
VALUES (1104, 'null-date@example.test', 'Null Date', NULL);

-- 7. reject products pk. Expected: pk_products, SQLSTATE 23505.
INSERT INTO portfolio."products" ("product_id", "sku", "product_name", "unit_price", "available_quantity", "active")
VALUES (2001, 'SYN-PK-003', 'PK Conflict Product', 4.5, 3, TRUE);

-- 8. reject products sku. Expected: uq_products_0, SQLSTATE 23505.
INSERT INTO portfolio."products" ("product_id", "sku", "product_name", "unit_price", "available_quantity", "active")
VALUES (2101, 'SYN-001', 'SKU Conflict Product', 4.5, 3, TRUE);

-- 9. reject products product id null. Expected: product_id, SQLSTATE 23502.
INSERT INTO portfolio."products" ("product_id", "sku", "product_name", "unit_price", "available_quantity", "active")
VALUES (NULL, 'SYN-NULL-001', 'Null Product ID', 4.5, 3, TRUE);

-- 10. reject products sku null. Expected: sku, SQLSTATE 23502.
INSERT INTO portfolio."products" ("product_id", "sku", "product_name", "unit_price", "available_quantity", "active")
VALUES (2102, NULL, 'Null SKU', 4.5, 3, TRUE);

-- 11. reject products name null. Expected: product_name, SQLSTATE 23502.
INSERT INTO portfolio."products" ("product_id", "sku", "product_name", "unit_price", "available_quantity", "active")
VALUES (2103, 'SYN-NULL-003', NULL, 4.5, 3, TRUE);

-- 12. reject products price null. Expected: unit_price, SQLSTATE 23502.
INSERT INTO portfolio."products" ("product_id", "sku", "product_name", "unit_price", "available_quantity", "active")
VALUES (2104, 'SYN-NULL-004', 'Null Price', NULL, 3, TRUE);

-- 13. reject products quantity null. Expected: available_quantity, SQLSTATE 23502.
INSERT INTO portfolio."products" ("product_id", "sku", "product_name", "unit_price", "available_quantity", "active")
VALUES (2105, 'SYN-NULL-005', 'Null Quantity', 4.5, NULL, TRUE);

-- 14. reject products active null. Expected: active, SQLSTATE 23502.
INSERT INTO portfolio."products" ("product_id", "sku", "product_name", "unit_price", "available_quantity", "active")
VALUES (2106, 'SYN-NULL-006', 'Null Active', 4.5, 3, NULL);

-- 15. reject orders pk. Expected: pk_orders, SQLSTATE 23505.
INSERT INTO portfolio."orders" ("order_id", "customer_id", "placed_at", "status")
VALUES (3001, 1001, '2026-03-03T09:00:00Z', 'pk-conflict');

-- 16. reject orders customer fk. Expected: fk_orders_0, SQLSTATE 23503.
INSERT INTO portfolio."orders" ("order_id", "customer_id", "placed_at", "status")
VALUES (3101, 9999, '2026-03-03T09:00:00Z', 'placed');

-- 17. reject orders order id null. Expected: order_id, SQLSTATE 23502.
INSERT INTO portfolio."orders" ("order_id", "customer_id", "placed_at", "status")
VALUES (NULL, 1001, '2026-03-03T09:00:00Z', 'placed');

-- 18. reject orders customer id null. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."orders" ("order_id", "customer_id", "placed_at", "status")
VALUES (3102, NULL, '2026-03-03T09:00:00Z', 'placed');

-- 19. reject orders placed at null. Expected: placed_at, SQLSTATE 23502.
INSERT INTO portfolio."orders" ("order_id", "customer_id", "placed_at", "status")
VALUES (3103, 1001, NULL, 'placed');

-- 20. reject orders status null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."orders" ("order_id", "customer_id", "placed_at", "status")
VALUES (3104, 1001, '2026-03-03T09:00:00Z', NULL);

-- 21. reject lines pk. Expected: pk_order_lines, SQLSTATE 23505.
INSERT INTO portfolio."order_lines" ("line_id", "order_id", "product_id", "quantity", "captured_unit_price")
VALUES (4001, 3001, 2001, 1, 6.25);

-- 22. reject lines unique. Expected: uq_order_lines_0, SQLSTATE 23505.
INSERT INTO portfolio."order_lines" ("line_id", "order_id", "product_id", "quantity", "captured_unit_price")
VALUES (4101, 3001, 2001, 3, 12.5);

-- 23. reject lines order fk. Expected: fk_order_lines_0, SQLSTATE 23503.
INSERT INTO portfolio."order_lines" ("line_id", "order_id", "product_id", "quantity", "captured_unit_price")
VALUES (4102, 9999, 2001, 1, 12.5);

-- 24. reject lines product fk. Expected: fk_order_lines_1, SQLSTATE 23503.
INSERT INTO portfolio."order_lines" ("line_id", "order_id", "product_id", "quantity", "captured_unit_price")
VALUES (4103, 3001, 9999, 1, 12.5);

-- 25. reject lines line id null. Expected: line_id, SQLSTATE 23502.
INSERT INTO portfolio."order_lines" ("line_id", "order_id", "product_id", "quantity", "captured_unit_price")
VALUES (NULL, 3001, 2001, 1, 12.5);

-- 26. reject lines order id null. Expected: order_id, SQLSTATE 23502.
INSERT INTO portfolio."order_lines" ("line_id", "order_id", "product_id", "quantity", "captured_unit_price")
VALUES (4104, NULL, 2001, 1, 12.5);

-- 27. reject lines product id null. Expected: product_id, SQLSTATE 23502.
INSERT INTO portfolio."order_lines" ("line_id", "order_id", "product_id", "quantity", "captured_unit_price")
VALUES (4105, 3001, NULL, 1, 12.5);

-- 28. reject lines quantity null. Expected: quantity, SQLSTATE 23502.
INSERT INTO portfolio."order_lines" ("line_id", "order_id", "product_id", "quantity", "captured_unit_price")
VALUES (4106, 3001, 2001, NULL, 12.5);

-- 29. reject lines price null. Expected: captured_unit_price, SQLSTATE 23502.
INSERT INTO portfolio."order_lines" ("line_id", "order_id", "product_id", "quantity", "captured_unit_price")
VALUES (4107, 3001, 2001, 1, NULL);

-- 30. reject products price check. Expected: product_price_positive, SQLSTATE 23514.
INSERT INTO portfolio."products" ("product_id", "sku", "product_name", "unit_price", "available_quantity", "active")
VALUES (2107, 'SYN-CHECK-001', 'Invalid Price', 0, 3, TRUE);

-- 31. reject products stock check. Expected: stock_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."products" ("product_id", "sku", "product_name", "unit_price", "available_quantity", "active")
VALUES (2108, 'SYN-CHECK-002', 'Invalid Stock', 4.5, -1, TRUE);

-- 32. reject lines quantity check. Expected: line_quantity_positive, SQLSTATE 23514.
INSERT INTO portfolio."order_lines" ("line_id", "order_id", "product_id", "quantity", "captured_unit_price")
VALUES (4108, 3001, 2002, 0, 8.75);
