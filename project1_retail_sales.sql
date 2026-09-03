use p1;

SELECT * FROM retail_sales
LIMIT 10 ;

DESCRIBE retail_sales;

select
count(*)
from retail_sales ;

alter table retail_sales
rename column quantiy to quantity ; 

SELECT
    SUM(transactions_id IS NULL) AS transactions_id_nulls,
    SUM(sale_date IS NULL) AS sale_date_nulls,
    SUM(sale_time IS NULL) AS sale_time_nulls,
    SUM(customer_id IS NULL) AS customer_id_nulls,
    SUM(gender IS NULL) AS gender_nulls,
    SUM(age IS NULL) AS age_nulls,
    SUM(category IS NULL) AS category_nulls,
    SUM(quantity IS NULL) AS quantiy_nulls,
    SUM(price_per_unit IS NULL) AS price_per_unit_nulls,
    SUM(cogs IS NULL) AS cogs_nulls,
    SUM(total_sale IS NULL) AS total_sale_nulls
FROM retail_sales;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM retail_sales
WHERE
    transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

SET SQL_SAFE_UPDATES = 1;

SELECT SUM(total_sale) AS total_sales
FROM retail_sales;

SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales;

SELECT DISTINCT category
FROM retail_sales;

select *
from  retail_sales
where sale_date = '2022-11-05' and 
sale_time BETWEEN '10:00:00' AND '22:00:00';

SELECT DISTINCT quantity
FROM retail_sales
order by quantity ;

select *
from retail_sales
where category = 'clothing'
and quantity > 2
and sale_date BETWEEN '2022-11-01' AND '2022-11-30';

select 
category ,
sum(total_sale) as net_sales 
from retail_sales 
group by 1;

select 
round(avg(age),2) as avg_age
from retail_sales
where category = 'beauty';

select * 
from retail_sales
where total_sale > 999 ;

SELECT SUM(total_sale) AS total_sales_above_1000
FROM retail_sales
WHERE total_sale > 999;

select 
category , gender ,
count(transactions_id) as total_transaction 
from retail_sales
group by category , gender 
order by 1;

SELECT 
    year,
    month,
    avg_sale
FROM
(
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS sales_rank
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE sales_rank = 1;

WITH monthly_sales AS (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        SUM(total_sale) AS total_sales
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
),
ranked_months AS (
    SELECT
        year,
        month,
        total_sales,
        RANK() OVER (
            PARTITION BY year
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM monthly_sales
)
SELECT
    year,
    month,
    total_sales
FROM ranked_months
WHERE sales_rank = 1
ORDER BY year; 

WITH monthly_sales AS (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sales,
        SUM(total_sale) AS total_sales
    FROM retail_sales
    GROUP BY
        YEAR(sale_date),
        MONTH(sale_date)
),
ranked_months AS (
    SELECT
        year,
        month,
        avg_sales,
        total_sales,
        RANK() OVER (
            PARTITION BY year
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM monthly_sales
)
SELECT
    year,
    month,
    ROUND(avg_sales, 2) AS average_sales,
    total_sales,
    sales_rank
FROM ranked_months
ORDER BY year, month;

select 
customer_id,
sum(total_sale) as total_sales
from retail_sales
group by 1
order by total_sales desc
limit 5 ;

select 
category,
count(distinct customer_id) as unique_id
from retail_sales
group by 1 ;

SELECT
    CASE
        WHEN HOUR(sale_time) <= 12 THEN 'Morning'
        WHEN HOUR(sale_time) > 12 AND HOUR(sale_time) <= 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS number_of_orders
FROM retail_sales
GROUP BY shift
ORDER BY number_of_orders DESC;

alter table retail_sales 
add column shifts varchar(20);

SET SQL_SAFE_UPDATES = 0;
UPDATE retail_sales
SET shifts =
CASE
    WHEN HOUR(sale_time) <= 12 THEN 'Morning'
    WHEN HOUR(sale_time) > 12 AND HOUR(sale_time) <= 17 THEN 'Afternoon'
    ELSE 'Evening'
END;
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE retail_sales
MODIFY COLUMN sale_date DATE;

alter table retail_sales
modify column sale_time time ;

-- Highest value
SELECT 
MAX(total_sale) 
FROM retail_sales;

-- Lowest value
SELECT 
MIN(total_sale)
FROM retail_sales;

-- Average value
SELECT 
AVG(total_sale)
FROMretail_sales;

-- Total value
SELECT 
SUM(total_sale) 
FROM retail_sales;

select * 
from retail_sales
where total_sale = 2000 ;

-- If you want the top 3 total_sale amounts and how many times each occurred
select 
total_sale ,
count(*) as mumber_of_people
from retail_sales
group by total_sale
order by total_sale desc;

-- Find customers who purchased more than once
select
customer_id ,
count(*) as repeated_customer
from retail_sales
group by customer_id
having count(*) > 1
order by repeated_customer desc;

-- If you want to see all transactions of those repeat customers and how many times 
SELECT *
FROM retail_sales
WHERE customer_id IN (
SELECT customer_id
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(*) > 50
)
ORDER BY customer_id, sale_date;

-- Find the average price_per_unit for each category. also you can find min and max values by replacing avg 
select
category ,
avg(price_per_unit) as average_price
from retail_sales
group by category;

-- Find all transactions where the quantity is between 5 and 10.
select *
from retail_sales
where quantity between 4 and 5 ;

-- If you wanted to know how many transactions have quantity between 5 and 10
select 
count(*) as total_trasaction 
from retail_sales
where quantity between 4 and 5 ;

-- Total quantity of products sold for each category
select
category ,
sum(quantity) as total_quantity
from retail_sales
group by category ;

-- Find the customer who has made the most transactions.
select 
customer_id ,
count(*) as number_of_transaction 
from retail_sales
group by customer_id
order by number_of_transaction desc 
limit 3;

-- Find the total profit for each category
select 
category ,
sum(total_sale - cogs) as total_profit
from retail_sales 
group by category;

-- Find the total sales, total cost, and total profit for each category.
select 
category ,
sum(total_sale) as total_sales ,
sum(cogs) as total_cogs ,
sum(total_sale - cogs) as total_profit 
from retail_sales 
group by category ;

-- Find the top 2 categories based on total quantity sold
select
category ,
sum(quantity) as total_quantity
from retail_sales 
group by category
order by total_quantity desc
limit 2   ;

-- more than 3 transactions
select 
customer_id ,
count(transactions_id) as number_of_purchase
from retail_sales
group by customer_id 
having count(*) > 3 
order by number_of_purchase  desc;

-- find the percentage contribution of each category to the overall sales
select 
category ,
sum(total_sale) as total_sales ,
(sum(total_sale) / (select sum(total_sale) from retail_sales)) * 100 as sales_percentage
from retail_sales
group by category 
order by sales_percentage desc;
