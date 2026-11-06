# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection order_events for order_placed and stock_reserved events. These are fictional event examples based on orders, customers, order_lines, products.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related customers details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "order_placed",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "order_lines",
        "key": {
            "line_id": 4001
        },
        "snapshot": {
            "line_id": 4001,
            "order_id": 3001,
            "product_id": 2001,
            "quantity": 2,
            "captured_unit_price": 12.5
        }
    },
    "embedded": {
        "customers": [
            {
                "key": {
                    "customer_id": 1001
                },
                "snapshot": {
                    "customer_id": 1001,
                    "email": "ava@example.test",
                    "display_name": "Ava Sample",
                    "created_at": "2026-01-10"
                },
                "via": [
                    "order_lines.order_id → orders.customer_id → customers"
                ]
            }
        ]
    },
    "references": {
        "orders": [
            {
                "key": {
                    "order_id": 3001
                },
                "via": [
                    "order_lines.order_id → orders"
                ]
            }
        ],
        "products": [
            {
                "key": {
                    "product_id": 2001
                },
                "via": [
                    "order_lines.product_id → products"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 2 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 4 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("order_events").find({"eventType":"order_placed"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "line_id": 4001
    }
  },
  {
    "_id": "event_000003",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "line_id": 4002
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("order_events").find({"source.key.line_id":4001}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "line_id": 4001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "stock_reserved",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "line_id": 4001
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("order_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "line_id": 4001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "stock_reserved",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "line_id": 4001
    }
  },
  {
    "_id": "event_000003",
    "eventType": "order_placed",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "line_id": 4002
    }
  },
  {
    "_id": "event_000004",
    "eventType": "stock_reserved",
    "occurredAt": {
      "$date": "2030-01-01T10:03:00Z"
    },
    "source": {
      "line_id": 4002
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("order_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| order_placed | 2 |
| stock_reserved | 2 |

## Validation and suitability

MongoDB inserted 4 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 4 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Emereuwa_Jessica_301906616_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Emereuwa_Jessica_301906616_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

