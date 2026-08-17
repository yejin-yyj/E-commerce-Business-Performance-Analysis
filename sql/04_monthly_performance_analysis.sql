-- Business Question: How is the business performing over time?
-- Revenue is defined as the sum of item prices for delivered orders.
-- Initial data-quality review showed that 2016 contains very sparse delivered-order coverage,
-- so the trend analysis is restricted to 2017-01 through 2018-08.

SELECT
    strftime('%Y-%m', o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS avg_order_value
FROM orders AS o
LEFT JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY month
ORDER BY month;
