# E-commerce Business Performance Analysis

**Tools:** SQL | Power BI  
**Dataset:** Olist Brazilian E-Commerce Public Dataset

## Project Objective

This project analyzes e-commerce transaction and customer data to identify the key drivers of business performance and translate them into decision-ready insights.

The goal is not only to build a dashboard, but to demonstrate a structured analytical workflow: understanding the business question, identifying the required data, connecting relevant data sources, defining meaningful KPIs, and communicating actionable findings.

## Business Questions

1. How is the business performing over time?
2. Which product categories and regions are driving performance?
3. Is delivery performance associated with customer satisfaction?

## Data Used

For a focused analysis, I selected six tables from the Olist dataset:

- `orders`: order status, purchase date, delivery dates
- `order_items`: product-level order details and price
- `customers`: customer identifiers and state
- `products`: product information and category
- `category_translation`: English product category names
- `reviews`: customer review scores

## Analytical Approach

### 1. Connecting Orders to Customer Information

**Business need:** Regional performance analysis requires customer location information alongside each order.

**Data challenge:** The `orders` table contains transaction information but does not contain the customer's state. That information is stored separately in the `customers` table.

**Approach:** I connected `orders` and `customers` using `customer_id`, allowing each order to be analyzed with its associated customer location and unique customer identifier.

I used a `LEFT JOIN` with `orders` as the base table so that the order population remains intact while customer attributes are added where available.

```sql
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
```

The query is also saved in [`sql/01_orders_customers_join.sql`](sql/01_orders_customers_join.sql).

### 2. Testing Whether Order Concentration Also Drives Revenue Concentration

**Question:** Do the states with the highest order volumes also generate the highest revenue?

To answer this, I added `order_items` to the existing order and customer data because product price is stored at the item level rather than in the `orders` table. Revenue is defined here as the sum of `order_items.price` for delivered orders.

```sql
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders AS o
LEFT JOIN customers AS c
    ON o.customer_id = c.customer_id
LEFT JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;
```

The query is saved in [`sql/02_state_order_revenue_analysis.sql`](sql/02_state_order_revenue_analysis.sql).

**Result:** The top states by order volume were also the top states by revenue. São Paulo ranked first with 40,501 delivered orders and approximately 5.07M in product revenue, followed by Rio de Janeiro and Minas Gerais. The top three states accounted for about 63% of total delivered-order product revenue.

**Interpretation:** Geographic revenue concentration broadly follows order volume concentration. However, high total revenue does not necessarily mean customers in those states spend more per order. The next step is to compare average order value by state before drawing conclusions about regional customer value.

## Dashboard

Power BI dashboard development will follow after the SQL analysis and KPI definitions are finalized.

## Key Findings

- Delivered order activity is strongly concentrated in a small number of states.
- São Paulo leads both delivered order volume and product revenue.
- The top three states account for approximately 63% of delivered-order product revenue.
- Revenue concentration appears to be closely related to order volume concentration, which requires an Average Order Value check before interpreting these regions as higher-value markets.

## Recommendations

To be added after findings are validated.

## Limitations

- Revenue in this analysis is defined as the sum of item prices and excludes freight and other payment-related components.
- Regional value conclusions should not be based on total revenue alone because differences may primarily reflect order volume.
