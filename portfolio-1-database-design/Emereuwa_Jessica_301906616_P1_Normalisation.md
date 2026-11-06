# E-commerce and Online Shopping Management — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| order_id | order_lines records (list) |
| --- | --- |
| 3001 | [4001] |
| 3002 | [4002] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| order_lines.line_id | order_lines.order_id | order_lines.product_id | orders.order_id | orders.customer_id | orders.status | customers.customer_id | customers.email |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4001 | 3001 | 2001 | 3001 | 1001 | completed | 1001 | ava@example.test |
| 4002 | 3002 | 2002 | 3002 | 1002 | placed | 1002 | noah@example.test |

Key: line_id.

## 2NF: depend on the whole key

order_lines: order_id is a proper part of candidate key (order_id, product_id), and determines orders details. order_lines: product_id is a proper part of candidate key (order_id, product_id), and determines products details.

## orders_example

| orders.order_id | orders.customer_id | orders.status | customers.customer_id | customers.email |
| --- | --- | --- | --- | --- |
| 3001 | 1001 | completed | 1001 | ava@example.test |
| 3002 | 1002 | placed | 1002 | noah@example.test |

## order_lines_example

| order_lines.line_id | order_lines.order_id | order_lines.product_id |
| --- | --- | --- |
| 4001 | 3001 | 2001 |
| 4002 | 3002 | 2002 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customers

| customer_id | email | display_name | created_at |
| --- | --- | --- | --- |
| 1001 | ava@example.test | Ava Sample | 2026-01-10 |
| 1002 | noah@example.test | Noah Sample | 2026-02-14 |

## products

| product_id | sku | product_name | unit_price | available_quantity | active |
| --- | --- | --- | --- | --- | --- |
| 2001 | SYN-001 | Synthetic Mug | 12.5 | 20 | true |
| 2002 | SYN-002 | Synthetic Notebook | 8.75 | 35 | true |

## orders

| order_id | customer_id | placed_at | status |
| --- | --- | --- | --- |
| 3001 | 1001 | 2026-03-01T10:15:00+00:00 | completed |
| 3002 | 1002 | 2026-03-02T13:30:00+00:00 | placed |

## order_lines

| line_id | order_id | product_id | quantity | captured_unit_price |
| --- | --- | --- | --- | --- |
| 4001 | 3001 | 2001 | 2 | 12.5 |
| 4002 | 3002 | 2002 | 1 | 8.75 |

## Dependencies

- customers: (customer_id) → email, display_name, created_at
- products: (product_id) → sku, product_name, unit_price, available_quantity, active
- orders: (order_id) → customer_id, placed_at, status
- order_lines: (line_id) → order_id, product_id, quantity, captured_unit_price

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
