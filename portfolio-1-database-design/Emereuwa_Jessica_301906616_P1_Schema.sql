-- E-commerce and Online Shopping Management: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."customers" (
  "customer_id" bigint NOT NULL,
  "email" text NOT NULL,
  "display_name" text NOT NULL,
  "created_at" date NOT NULL,
  CONSTRAINT "pk_customers" PRIMARY KEY ("customer_id"),
  CONSTRAINT "uq_customers_0" UNIQUE ("email")
);
CREATE TABLE portfolio."products" (
  "product_id" bigint NOT NULL,
  "sku" text NOT NULL,
  "product_name" text NOT NULL,
  "unit_price" numeric(18,2) NOT NULL,
  "available_quantity" bigint NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_products" PRIMARY KEY ("product_id"),
  CONSTRAINT "uq_products_0" UNIQUE ("sku")
);
CREATE TABLE portfolio."orders" (
  "order_id" bigint NOT NULL,
  "customer_id" bigint NOT NULL,
  "placed_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_orders" PRIMARY KEY ("order_id")
);
CREATE TABLE portfolio."order_lines" (
  "line_id" bigint NOT NULL,
  "order_id" bigint NOT NULL,
  "product_id" bigint NOT NULL,
  "quantity" bigint NOT NULL,
  "captured_unit_price" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_order_lines" PRIMARY KEY ("line_id"),
  CONSTRAINT "uq_order_lines_0" UNIQUE ("order_id", "product_id")
);
ALTER TABLE portfolio."orders" ADD CONSTRAINT "fk_orders_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customers" ("customer_id");
ALTER TABLE portfolio."order_lines" ADD CONSTRAINT "fk_order_lines_0" FOREIGN KEY ("order_id") REFERENCES portfolio."orders" ("order_id");
ALTER TABLE portfolio."order_lines" ADD CONSTRAINT "fk_order_lines_1" FOREIGN KEY ("product_id") REFERENCES portfolio."products" ("product_id");
ALTER TABLE portfolio."products" ADD CONSTRAINT "product_price_positive" CHECK ("unit_price" > 0);
ALTER TABLE portfolio."products" ADD CONSTRAINT "stock_nonnegative" CHECK ("available_quantity" >= 0);
ALTER TABLE portfolio."order_lines" ADD CONSTRAINT "line_quantity_positive" CHECK ("quantity" > 0);
COMMIT;
