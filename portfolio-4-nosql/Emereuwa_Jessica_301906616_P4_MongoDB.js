// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("order_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("order_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "order_placed",
                    "stock_reserved"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "order_lines"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "line_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("order_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "stock_reserved",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "status_detail": "illustrative status_detail",
                "reservation_detail": "illustrative reservation_detail",
                "client_context": "illustrative client_context"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "order_placed",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "order_lines",
            "key": {
                "line_id": 4002
            },
            "snapshot": {
                "line_id": 4002,
                "order_id": 3002,
                "product_id": 2002,
                "quantity": 1,
                "captured_unit_price": 8.75
            }
        },
        "embedded": {
            "customers": [
                {
                    "key": {
                        "customer_id": 1002
                    },
                    "snapshot": {
                        "customer_id": 1002,
                        "email": "noah@example.test",
                        "display_name": "Noah Sample",
                        "created_at": "2026-02-14"
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
                        "order_id": 3002
                    },
                    "via": [
                        "order_lines.order_id → orders"
                    ]
                }
            ],
            "products": [
                {
                    "key": {
                        "product_id": 2002
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
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "stock_reserved",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "order_lines",
            "key": {
                "line_id": 4002
            },
            "snapshot": {
                "line_id": 4002,
                "order_id": 3002,
                "product_id": 2002,
                "quantity": 1,
                "captured_unit_price": 8.75
            }
        },
        "embedded": {
            "customers": [
                {
                    "key": {
                        "customer_id": 1002
                    },
                    "snapshot": {
                        "customer_id": 1002,
                        "email": "noah@example.test",
                        "display_name": "Noah Sample",
                        "created_at": "2026-02-14"
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
                        "order_id": 3002
                    },
                    "via": [
                        "order_lines.order_id → orders"
                    ]
                }
            ],
            "products": [
                {
                    "key": {
                        "product_id": 2002
                    },
                    "via": [
                        "order_lines.product_id → products"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "status_detail": "illustrative status_detail",
                "reservation_detail": "illustrative reservation_detail",
                "client_context": "illustrative client_context"
            }
        }
    }
]));
  await db.getCollection("order_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("order_events").find({"eventType":"order_placed"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("order_events").find({"source.key.line_id":4001}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("order_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("order_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("order_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("order_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("order_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
