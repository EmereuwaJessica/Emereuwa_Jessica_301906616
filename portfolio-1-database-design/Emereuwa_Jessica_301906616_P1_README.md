# Portfolio 1 — Database Design and Modelling

I organised the data into customers, products, orders, order_lines. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| customers | 2 |
| products | 2 |
| orders | 2 |
| order_lines | 2 |

The 32 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Emereuwa_Jessica_301906616_P1_Design.md)
- [ER diagram](Emereuwa_Jessica_301906616_P1_ERDiagram.md)
- [Normalisation](Emereuwa_Jessica_301906616_P1_Normalisation.md)
- [Schema](Emereuwa_Jessica_301906616_P1_Schema.sql)
- [Sample data](Emereuwa_Jessica_301906616_P1_SampleData.sql)
- [Constraint tests](Emereuwa_Jessica_301906616_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Emereuwa_Jessica_301906616_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

