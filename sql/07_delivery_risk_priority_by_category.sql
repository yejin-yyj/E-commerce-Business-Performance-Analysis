WITH review_per_order AS (
    SELECT
        order_id,
        AVG(review_score) AS review_score
    FROM reviews
    GROUP BY order_id
),

order_category AS (
    SELECT
        oi.order_id,
        COALESCE(
            ct.product_category_name_english,
            p.product_category_name,
            'Unknown'
        ) AS product_category,
        SUM(oi.price) AS category_revenue
    FROM order_items AS oi
    LEFT JOIN products AS p
        ON oi.product_id = p.product_id
    LEFT JOIN category_translation AS ct
        ON p.product_category_name = ct.product_category_name
    GROUP BY
        oi.order_id,
        product_category
)

SELECT
    oc.product_category,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oc.category_revenue), 2) AS total_revenue,
    COUNT(DISTINCT CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN o.order_id
    END) AS late_orders,
    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN o.order_id
        END)
        / COUNT(DISTINCT o.order_id),
        2
    ) AS late_rate,
    ROUND(AVG(CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
        THEN r.review_score
    END), 2) AS on_time_review,
    ROUND(AVG(CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN r.review_score
    END), 2) AS late_review,
    ROUND(SUM(CASE
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
        THEN oc.category_revenue
        ELSE 0
    END), 2) AS late_revenue
FROM order_category AS oc
INNER JOIN orders AS o
    ON oc.order_id = o.order_id
LEFT JOIN review_per_order AS r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY oc.product_category
HAVING COUNT(DISTINCT o.order_id) >= 500
ORDER BY total_revenue DESC;
