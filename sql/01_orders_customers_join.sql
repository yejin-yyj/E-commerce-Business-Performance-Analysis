-- Business need:
-- Add customer location and unique customer identifiers to order-level data
-- so regional and customer analyses can be performed.

SELECT
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp
FROM orders AS o
LEFT JOIN customers AS c
    ON o.customer_id = c.customer_id
LIMIT 10;
