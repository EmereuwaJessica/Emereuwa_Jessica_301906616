# E-commerce and Online Shopping Management — database design

My case study records customers, products, orders, order_lines.

## Users

- Customers browsing and placing orders
- Store staff managing product availability and orders
- Analysts reviewing order and product activity

## Main operations

- Maintain customer and product records
- Place orders and record their line items
- Reserve available product stock during purchase
- Review orders and summarize product sales

## Entities

| Entity | Information stored |
| --- | --- |
| customers | Stores synthetic customer contact details. |
| products | Stores the catalog and current available stock for each product. |
| orders | Records a customer's order and its placement time and status. |
| order_lines | Records each product, quantity, and captured unit price within an order. |

## customers

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| email | TEXT | Unique | Yes |
| display_name | TEXT |  | Yes |
| created_at | DATE |  | Yes |
- Unique key: (email).

## products

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| product_id | BIGINT | PK | Yes |
| sku | TEXT | Unique | Yes |
| product_name | TEXT |  | Yes |
| unit_price | NUMERIC(18,2) |  | Yes |
| available_quantity | INTEGER |  | Yes |
| active | BOOLEAN |  | Yes |
- Unique key: (sku).

## orders

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| order_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| placed_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
- customer_id → customers.customer_id

## order_lines

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| line_id | BIGINT | PK | Yes |
| order_id | BIGINT | FK | Yes |
| product_id | BIGINT | FK | Yes |
| quantity | INTEGER |  | Yes |
| captured_unit_price | NUMERIC(18,2) |  | Yes |
- order_id → orders.order_id
- product_id → products.product_id
- Unique key: (order_id, product_id).

## Relationships and business rules

- Each customer email address must be unique.
- Each product SKU must be unique.
- A product's unit price must be greater than zero.
- Available product quantity must never be negative.
- Every order must reference an existing customer through customer_id to customers.customer_id.
- Every order line must reference an existing order through order_id to orders.order_id.
- Every order line must reference an existing product through product_id to products.product_id.
- An order line quantity must be greater than zero.
- A product may appear at most once in a given order.

## Assumptions

- All identifiers are synthetic UUIDs generated from one namespace, so each table has a single-column primary key and IDs are globally unique across tables.
- A customer may place many orders; each order belongs to one customer. Each order line refers to one order and one product.
- Each product may appear at most once in an order; its order line records the quantity and the unit price captured when the order was placed.
- Worked normalization example rooted at order_lines: line_id determines order_id, product_id, quantity, and captured_unit_price. order_id and product_id refer to distinct parent entities; customer contact and product name remain in their respective tables. The captured unit price is retained as historical purchase data.
- Use only generated names, email addresses, product details, identifiers, dates, and order activity; do not use real personal or commercial data.
- Separate benchmark plan: generate 50000 synthetic orders with varied placed_at dates and statuses, then compare the same date-range filter with and without a B-tree index on placed_at. Use repeated runs and compare query plans and median latency; this is a proposed exercise, not a reported result.

