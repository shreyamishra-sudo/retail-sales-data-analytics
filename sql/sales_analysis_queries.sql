/* =========================================================
   Project: Retail Sales Data Analytics
   Database: retail_analytics
   Purpose: Curated SQL analysis queries
   ========================================================= */

/* =======================
   Database Context
   ======================= */
USE retail_analytics;

/* =======================
   Table Schema (Reference)
   ======================= */
-- Sales data table structure
-- (Created via CSV import)
CREATE TABLE IF NOT EXISTS sales_data (
    ship_mode VARCHAR(50),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(10,2)
);

/* =======================
   Data Validation Checks
   ======================= */
-- Total row count
SELECT COUNT(*) AS total_rows
FROM sales_data;

/* =======================
   Core Business Analysis
   ======================= */

-- 1. Sales and profit by category
SELECT 
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY category
ORDER BY total_sales DESC;

-- 2. Top 10 cities by total sales
SELECT 
    city,
    ROUND(SUM(sales), 2) AS total_sales
FROM sales_data
GROUP BY city
ORDER BY total_sales DESC
LIMIT 10;

-- 3. Loss-making transactions
SELECT 
    city,
    category,
    sub_category,
    sales,
    discount,
    profit
FROM sales_data
WHERE profit < 0
ORDER BY profit ASC
LIMIT 10;

-- 4. Impact of discount on profitability
SELECT 
    discount,
    COUNT(*) AS total_orders,
    ROUND(AVG(profit), 2) AS avg_profit
FROM sales_data
GROUP BY discount
ORDER BY discount;

-- 5. Sub-category profitability
SELECT 
    sub_category,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY sub_category
ORDER BY total_profit DESC;

-- 6. Customer segment analysis
SELECT 
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY segment;

-- 7. High-sales but low-profit categories
SELECT 
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY category
HAVING total_sales > 50000
   AND total_profit < 0;
