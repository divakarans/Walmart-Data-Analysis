CREATE DATABASE IF NOT EXISTS walmart;

USE walmart;

CREATE TABLE walmart_sales (
    invoice_id VARCHAR(20) PRIMARY KEY,
    branch CHAR(1),
    city VARCHAR(50),
    customer_type VARCHAR(10),
    gender VARCHAR(10),
    product_line VARCHAR(50),
    unit_price DECIMAL(10,2),
    quantity INT,
    tax_5 DECIMAL(10,4),
    total DECIMAL(10,4),
    date DATE,
    time TIME,
    payment VARCHAR(20),
    cogs DECIMAL(10,2),
    gross_margin_percentage DECIMAL(10,6),
    gross_income DECIMAL(10,4),
    rating DECIMAL(3,1)
);

SET GLOBAL local_infile=1;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Walmart Sales Data.csv'
INTO TABLE walmart_sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(invoice_id, branch, city, customer_type, gender, product_line, unit_price, quantity, tax_5, total, date, time, payment, cogs, gross_margin_percentage, gross_income, rating);

-- Query 1: Count distinct cities in the dataset
SELECT COUNT(DISTINCT city) AS distinct_cities FROM walmart_sales;

-- Query 2: List cities and their corresponding branches
SELECT DISTINCT city, branch FROM walmart_sales;

-- Query 3: Count distinct product lines in the dataset
SELECT COUNT(DISTINCT product_line) AS distinct_product_lines FROM walmart_sales;

-- Query 4: Identify the most common payment method
SELECT payment, COUNT(*) AS count FROM walmart_sales 
GROUP BY payment 
ORDER BY count DESC 
LIMIT 1;


-- Query 5: Find the most sold product line
SELECT product_line, SUM(quantity) AS total_sold FROM walmart_sales 
GROUP BY product_line 
ORDER BY total_sold DESC 
LIMIT 1;

-- Query 6: Calculate total revenue by month
SELECT MONTH(date) AS month, SUM(total) AS total_revenue FROM walmart_sales 
GROUP BY month 
ORDER BY month;

-- Query 7: Find the month with the highest Cost of Goods Sold (COGS)
SELECT MONTH(date) AS month, SUM(cogs) AS total_cogs FROM walmart_sales 
GROUP BY month 
ORDER BY total_cogs DESC 
LIMIT 1;

-- Query 8: Find the product line with the highest revenue
SELECT product_line, SUM(total) AS total_revenue FROM walmart_sales 
GROUP BY product_line 
ORDER BY total_revenue DESC 
LIMIT 1;

-- Query 9: Identify the city with the highest revenue
SELECT city, SUM(total) AS total_revenue FROM walmart_sales 
GROUP BY city 
ORDER BY total_revenue DESC 
LIMIT 1;

-- Query 10: Find the product line with the highest VAT
SELECT product_line, SUM(tax_5) AS total_vat FROM walmart_sales 
GROUP BY product_line 
ORDER BY total_vat DESC 
LIMIT 1;

-- Query 11: Categorize product lines based on average sales
SELECT product_line, 
    CASE 
        WHEN SUM(total) > (SELECT AVG(total) FROM walmart_sales) THEN 'Good' 
        ELSE 'Bad' 
    END AS product_category
FROM walmart_sales
GROUP BY product_line;

-- Query 12: Identify branches that sold more than the average products sold
SELECT branch, SUM(quantity) AS total_quantity FROM walmart_sales 
GROUP BY branch 
HAVING total_quantity > (SELECT AVG(quantity) FROM walmart_sales);

-- Query 13: Find the most common product line by gender
SELECT gender, product_line, COUNT(*) AS count FROM walmart_sales 
GROUP BY gender, product_line 
ORDER BY gender, count DESC;

-- Query 14: Calculate the average rating for each product line
SELECT product_line, AVG(rating) AS avg_rating FROM walmart_sales 
GROUP BY product_line;

-- Query 15: Count sales per time of the day on each weekday
SELECT DAYNAME(date) AS weekday, HOUR(time) AS hour, COUNT(*) AS sales_count FROM walmart_sales 
GROUP BY weekday, hour 
ORDER BY weekday, hour;

-- Query 16: Identify the customer type that generates the highest revenue
SELECT customer_type, SUM(total) AS total_revenue FROM walmart_sales 
GROUP BY customer_type 
ORDER BY total_revenue DESC 
LIMIT 1;

-- Query 17: Find the city with the largest VAT percentage
SELECT city, AVG(tax_5 / cogs * 100) AS avg_vat_percentage FROM walmart_sales 
GROUP BY city 
ORDER BY avg_vat_percentage DESC 
LIMIT 1;

-- Query 18: Identify the customer type that pays the most VAT
SELECT customer_type, SUM(tax_5) AS total_vat FROM walmart_sales 
GROUP BY customer_type 
ORDER BY total_vat DESC 
LIMIT 1;

-- Query 19: Count unique customer types
SELECT COUNT(DISTINCT customer_type) AS unique_customer_types FROM walmart_sales;

-- Query 20: Count unique payment methods
SELECT COUNT(DISTINCT payment) AS unique_payment_methods FROM walmart_sales;

-- Query 21: Find the most common customer type
SELECT customer_type, COUNT(*) AS count FROM walmart_sales 
GROUP BY customer_type 
ORDER BY count DESC 
LIMIT 1;

-- Query 22: Identify the customer type that buys the most
SELECT customer_type, SUM(quantity) AS total_quantity FROM walmart_sales 
GROUP BY customer_type 
ORDER BY total_quantity DESC 
LIMIT 1;

-- Query 23: Determine the gender distribution of customers
SELECT gender, COUNT(*) AS count FROM walmart_sales 
GROUP BY gender;

-- Query 24: Find gender distribution per branch
SELECT branch, gender, COUNT(*) AS count FROM walmart_sales 
GROUP BY branch, gender 
ORDER BY branch;

-- Query 25: Identify the time of day when customers give the most ratings
SELECT HOUR(time) AS hour, COUNT(rating) AS rating_count FROM walmart_sales 
GROUP BY hour 
ORDER BY rating_count DESC 
LIMIT 1;

-- Query 26: Find the time of day when customers give most ratings per branch
SELECT branch, HOUR(time) AS hour, COUNT(rating) AS rating_count FROM walmart_sales 
GROUP BY branch, hour 
ORDER BY branch, rating_count DESC;

-- Query 27: Determine which weekday has the best average ratings
SELECT DAYNAME(date) AS weekday, AVG(rating) AS avg_rating FROM walmart_sales 
GROUP BY weekday 
ORDER BY avg_rating DESC 
LIMIT 1;

-- Query 28: Find the best average ratings per branch by weekday
SELECT branch, DAYNAME(date) AS weekday, AVG(rating) AS avg_rating FROM walmart_sales 
GROUP BY branch, weekday 
ORDER BY branch, avg_rating DESC;
