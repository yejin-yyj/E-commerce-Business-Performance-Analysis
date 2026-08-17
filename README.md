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

## Dashboard

Power BI dashboard development will follow after the SQL analysis and KPI definitions are finalized.

## Key Findings

To be added after analysis.

## Recommendations

To be added after findings are validated.

## Limitations

To be documented after the data quality and analytical scope are assessed.
