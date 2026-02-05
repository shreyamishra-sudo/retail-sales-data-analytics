create database retail_analytics;
use retail_analytics;

CREATE TABLE sales_data (
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

-- Sales and profit by categor
SELECT 
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY category
ORDER BY total_sales DESC;

-- Top 10 cities by total sales
SELECT 
    city,
    ROUND(SUM(sales), 2) AS total_sales
FROM sales_data
GROUP BY city
ORDER BY total_sales DESC
LIMIT 10;

-- Profitability check: loss-making orders
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

-- Impact of discount on profit
SELECT 
    discount,
    COUNT(*) AS total_orders,
    ROUND(AVG(profit), 2) AS avg_profit
FROM sales_data
GROUP BY discount
ORDER BY discount;

-- Best and worst sub-categories by profit
SELECT 
    sub_category,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY sub_category
ORDER BY total_profit DESC;

-- Customer segment analysis
SELECT 
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY segment;

-- High-sales but low-profit red flags
SELECT 
    category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM sales_data
GROUP BY category
HAVING total_sales > 50000 AND total_profit < 0;








