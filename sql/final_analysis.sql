/*
=========================================================
Retail Sales Analytics – Final SQL Analysis (Day 2)
Database: MySQL
Purpose:
- Validate data quality
- Create a clean analytical view
- Answer core business questions using SQL
=========================================================
*/

-- -------------------------------------------------------
-- 1. Basic Data Validation
-- -------------------------------------------------------
USE retail_analytics;
-- Total number of records in the dataset
SELECT COUNT(*) AS total_rows
FROM sales_data;

-- Check for NULL values in critical analytical columns
SELECT
    SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS null_profit,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS null_region,
    SUM(CASE WHEN segment IS NULL THEN 1 ELSE 0 END) AS null_segment
FROM sales_data;

-- Identify records with zero or negative sales (potential data quality issues)
SELECT COUNT(*) AS non_positive_sales_rows
FROM sales_data
WHERE sales <= 0;

-- Review discount values to understand range and validity
SELECT DISTINCT discount
FROM sales_data
ORDER BY discount;

-- Sanity check: profit should not exceed sales
SELECT COUNT(*) AS profit_greater_than_sales
FROM sales_data
WHERE profit > sales;

-- -------------------------------------------------------
-- 2. Create Clean Analytical View
-- -------------------------------------------------------
-- We do not delete raw data.
-- This view excludes records that would distort analysis.

CREATE OR REPLACE VIEW sales_data_clean AS
SELECT *
FROM sales_data
WHERE sales IS NOT NULL
  AND profit IS NOT NULL
  AND sales > 0;

-- -------------------------------------------------------
-- 3. Business Question 1:
-- Which regions and cities generate the highest revenue and profit?
-- -------------------------------------------------------

-- Region-wise revenue and profit
SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data_clean
GROUP BY region
ORDER BY total_profit DESC;

-- Top 10 cities by total sales
SELECT
    city,
    ROUND(SUM(sales), 2) AS total_sales
FROM sales_data_clean
GROUP BY city
ORDER BY total_sales DESC
LIMIT 10;

-- -------------------------------------------------------
-- 4. Business Question 2:
-- Which product categories and sub-categories are the most and least profitable?
-- -------------------------------------------------------

-- Category-level performance
SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data_clean
GROUP BY category
ORDER BY total_profit DESC;

-- Sub-category profitability ranking
SELECT
    sub_category,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data_clean
GROUP BY sub_category
ORDER BY total_profit DESC;

-- -------------------------------------------------------
-- 5. Business Question 3:
-- How do discounts impact profitability?
-- -------------------------------------------------------

SELECT
    discount,
    COUNT(*) AS total_orders,
    ROUND(AVG(sales), 2) AS avg_sales,
    ROUND(AVG(profit), 2) AS avg_profit
FROM sales_data_clean
GROUP BY discount
ORDER BY discount;

-- -------------------------------------------------------
-- 6. Business Question 4:
-- Are there high-revenue categories that are still loss-making?
-- -------------------------------------------------------

SELECT
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data_clean
GROUP BY category
HAVING total_sales > 50000
   AND total_profit < 0;

-- -------------------------------------------------------
-- 7. Business Question 5:
-- How does customer segmentation affect sales and profit contribution?
-- -------------------------------------------------------

SELECT
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data_clean
GROUP BY segment
ORDER BY total_profit DESC;
