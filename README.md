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

The query is saved in [`sql/01_orders_customers_join.sql`](sql/01_orders_customers_join.sql).

### 2. Testing Whether Order Concentration Also Drives Revenue Concentration

**Question:** Do the states with the highest order volumes also generate the highest revenue?

To answer this, I added `order_items` to the existing order and customer data because product price is stored at the item level rather than in the `orders` table. Revenue is defined here as the sum of `order_items.price` for delivered orders.

The query is saved in [`sql/02_state_order_revenue_analysis.sql`](sql/02_state_order_revenue_analysis.sql).

**Result:** The top states by order volume were also the top states by revenue. São Paulo ranked first with 40,501 delivered orders and approximately 5.07M in product revenue, followed by Rio de Janeiro and Minas Gerais. The top three states accounted for about 63% of total delivered-order product revenue.

**Interpretation:** Geographic revenue concentration broadly follows order volume concentration. However, high total revenue does not necessarily mean customers in those states spend more per order.

### 3. Comparing Average Order Value Across States

**Question:** Are high-revenue states also generating higher revenue per order?

The query is saved in [`sql/03_state_aov_analysis.sql`](sql/03_state_aov_analysis.sql).

**Result:** São Paulo generated the highest total revenue, but its Average Order Value was 125.12, below Rio de Janeiro at 142.48 and Minas Gerais at 136.73. Paraíba had the highest AOV at 217.77, but only 517 delivered orders.

**Interpretation:** The largest revenue markets are driven primarily by transaction volume rather than unusually high spending per order. High AOV in smaller states should be interpreted cautiously because those markets have much lower order volumes.

### 4. Reviewing Monthly Business Performance

**Question:** How is the business performing over time?

Before interpreting the trend, I checked the time coverage of delivered orders. The 2016 portion of the dataset is extremely sparse, so I restricted trend interpretation to January 2017 through August 2018.

The query is saved in [`sql/04_monthly_performance_analysis.sql`](sql/04_monthly_performance_analysis.sql).

**Result:** Revenue grew substantially through 2017 and reached approximately 987.8K in November 2017. Revenue again approached this level in April and May 2018 at approximately 973.5K and 977.5K. Revenue then softened from June through August 2018.

**Interpretation:** The data shows strong growth through 2017 followed by a high but more stable performance level in 2018, with some softening during the final three observed months. Because delivered-order coverage ends in August 2018, this should not be interpreted as evidence of a full-year decline.

### 5. Comparing Product Category Performance

**Question:** Which product categories are driving revenue, and are they driven by order volume or higher spending per order?

To answer this, I connected `orders` to `order_items`, `products`, and `category_translation` so that delivered orders could be evaluated by English product category name. I compared distinct order count, total product revenue, and Average Order Value by category.

The query is saved in [`sql/05_category_performance_analysis.sql`](sql/05_category_performance_analysis.sql).

**Result:** `health_beauty` generated the highest product revenue at approximately 1.23M from 8,647 delivered orders, with an AOV of 142.61. `watches_gifts` ranked second at approximately 1.17M from 5,495 orders and had a much higher AOV of 212.23. `bed_bath_table` ranked third at approximately 1.02M from 9,272 orders, but its AOV was lower at 110.38. Together, the top three categories accounted for approximately 25.9% of delivered-order product revenue.

**Interpretation:** Revenue leadership is generated through different commercial patterns. `bed_bath_table` is more volume-driven, while `watches_gifts` produces nearly as much revenue with substantially fewer orders because spending per order is higher. `health_beauty` combines relatively high order volume with a moderate AOV, giving it the strongest overall revenue contribution.

### 6. Testing the Relationship Between Delivery Performance and Customer Satisfaction

**Question:** Is delivery performance associated with customer satisfaction?

I classified delivered orders as `On Time` when the actual customer delivery date was on or before the estimated delivery date, and `Late` otherwise. I then joined orders to review scores and compared the average review score across the two delivery groups.

The query is saved in [`sql/06_delivery_review_analysis.sql`](sql/06_delivery_review_analysis.sql).

**Result:** Late deliveries accounted for 7,661 orders and had an average review score of 2.57. On-time deliveries accounted for 88,163 orders and had an average review score of 4.29. Among orders with the required delivery and review information, approximately 8.0% were late.

**Interpretation:** Customer satisfaction is substantially lower among late deliveries, with a 1.72-point gap in average review score between late and on-time orders. This is a strong operational signal that delivery reliability is associated with customer experience. However, the analysis is observational and does not prove that delivery lateness alone caused the lower review scores.

## Dashboard

Power BI dashboard development will follow after the SQL analysis and KPI definitions are finalized.

## Key Findings

- Delivered order activity is strongly concentrated in a small number of states.
- São Paulo leads both delivered order volume and product revenue, but its revenue leadership is primarily scale-driven rather than AOV-driven.
- Paraíba has the highest state-level AOV, but its much smaller order base means AOV alone should not be used to prioritize regions.
- Monthly revenue expanded strongly through 2017 and remained near peak levels in early 2018 before softening in the final observed months.
- Sparse 2016 activity was excluded from trend interpretation to avoid presenting incomplete early-period coverage as a genuine business decline.
- `health_beauty`, `watches_gifts`, and `bed_bath_table` are the three largest revenue categories and together contribute approximately 25.9% of product revenue.
- Category revenue drivers differ: `watches_gifts` is supported by high AOV, while `bed_bath_table` is more dependent on order volume.
- Late deliveries represent about 8.0% of evaluated orders and are associated with a substantially lower average review score: 2.57 compared with 4.29 for on-time deliveries.

## Recommendations

- Monitor late-delivery rate alongside review score as a core customer-experience KPI.
- Prioritize investigation of operational drivers behind late deliveries before choosing interventions, since this analysis establishes association rather than causation.
- Evaluate high-revenue categories using both order volume and AOV rather than total revenue alone, because different categories generate revenue through different commercial patterns.
- Treat high-AOV, low-volume regions as potential opportunities for further investigation rather than automatically prioritizing them as the most valuable markets.

## Limitations

- Revenue in this analysis is defined as the sum of item prices and excludes freight and other payment-related components.
- Regional value conclusions should not be based on total revenue alone because differences may primarily reflect order volume.
- Average Order Value in low-volume states should be interpreted carefully because smaller order counts can make comparisons less stable.
- The delivered-order time series is sparse in 2016 and ends in August 2018, so trend conclusions are restricted to the period with consistent coverage.
- Monthly movements are descriptive only. The dataset alone does not establish the causal drivers behind individual peaks or declines.
- Product category analysis describes revenue contribution but does not include product cost or gross margin, so it should not be interpreted as category profitability.
- The delivery analysis is observational. Differences in review scores may also be related to product quality, seller experience, customer expectations, or other factors not isolated in this analysis.
