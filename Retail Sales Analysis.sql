SELECT *
FROM Sales;

SELECT 
COUNT(*) AS 'Total Rows'
FROM Sales;

SELECT *
FROM Sales
WHERE transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR 
total_sale IS NULL;


DELETE FROM Sales
WHERE transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR 
total_sale IS NULL;


-- EDA

-- HOW MANY SALES WE HAVE
SELECT 
COUNT(*) AS TOTAL_SALES
FROM Sales;

-- HOW MANY UNIQUE CUSTOMER WE HAVE
SELECT COUNT(DISTINCT(customer_id)) AS TOTAL_CUSTOMER
FROM Sales;


-- HOW MAY UNIQUE CATEGORY WE HAVE
SELECT DISTINCT(category)  FROM Sales; 


-- DATA ANALYSIS
-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * 
FROM Sales
WHERE sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT
	*
FROM Sales
WHERE category = 'clothing'
	AND YEAR(sale_date) = 2022
	AND MONTH(sale_date) = 11
	AND quantiy >=4;


-- Write a SQL query to calculate the total sales (total_sale) for each category.:

SELECT
	category,
	SUM(total_sale) as Net_Sales,
	COUNT(*) as Total_orders
FROM Sales
GROUP BY category;


-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

SELECT 
	AVG(age) as Average_age
FROM Sales
WHERE category = 'Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT 
	COUNT(transactions_id) AS Total_transactions
FROM Sales
WHERE total_sale > 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

SELECT 
	category,
	gender,
	COUNT(transactions_id) AS Total_transactions
FROM Sales
GROUP BY gender,category
ORDER BY category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT *
FROM (
	SELECT
		YEAR(sale_date) as tyear,
		MONTH(sale_date) as tmonth,
		AVG(total_sale) AS AVG_SALES,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) desc ) as rnk
	FROM Sales
	GROUP BY YEAR(sale_date), MONTH(sale_date)
	) as t1
	where rnk = 1;


-- Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT
	TOP 5
	customer_id,
	SUM(total_sale) AS Total_Sales
FROM Sales
GROUP BY customer_id 
ORDER BY Total_Sales desc;

-- Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT
	category,
	COUNT(DISTINCT(customer_id)) as 'cnt_unique_customer'
FROM Sales
GROUP BY category;


-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH HOURLY_SHIFT AS
(
    SELECT *, 
        CASE 
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS Shift
    FROM Sales
)

SELECT 
    Shift,
    COUNT(*) AS Total_Orders
FROM HOURLY_SHIFT
GROUP BY Shift;
