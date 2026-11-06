# E-commerce and Online Shopping Management — ER diagram

```mermaid
erDiagram
    direction LR
    customers {
        bigint customer_id PK
        text email UK
        text display_name
        date created_at
    }
    products {
        bigint product_id PK
        text sku UK
        text product_name
        numeric unit_price
        integer available_quantity
        boolean active
    }
    orders {
        bigint order_id PK
        bigint customer_id FK
        timestamptz placed_at
        text status
    }
    order_lines {
        bigint line_id PK
        bigint order_id FK
        bigint product_id FK
        integer quantity
        numeric captured_unit_price
    }
    customers ||--o{ orders : "customer_id"
    orders ||--o{ order_lines : "order_id"
    products ||--o{ order_lines : "product_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Emereuwa_Jessica_301906616_ERDiagram.png)
