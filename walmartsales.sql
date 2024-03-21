CREATE DATABASE walmartsales;
USE walmartsales;
CREATE TABLE sales(
Invoice_ID VARCHAR(30) NOT NULL PRIMARY KEY,
Branch VARCHAR(10) ,
City VARCHAR(30),
Customer_type	VARCHAR(30),
Gender VARCHAR(30),
Product_line VARCHAR(100),
Unit_price DECIMAL(10,2),
Quantity INT,
VAT FLOAT,	
Total DECIMAL(12,4),
Date DATETIME,	
Time TIME,	
Payment_cogs VARCHAR(15),
COGS DECIMAL(10,2),	
gross_margin_pct FLOAT,
gross_income DECIMAL(12,4),	
Rating FLOAT
);

 ------------------------------------FEATURE ENGINEERING-----------------------------------------------------------------
#Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening. 
#This will help answer the question on which part of the day most sales are made
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

select time, time_of_day from sales
-----------------------------------------------------------------------------
#ADD NEW COLUMN DAY_NAME
SELECT date,
	   DAYNAME(date) AS day_name
 FROM sales;
 
 ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
 
 UPDATE sales 
 SET day_name=DAYNAME(date);
 -------------------------------------------------------------------------------
 # ADD NEW COLUMN MONTH_NAME
 SELECT date,
        MONTHNAME(date)
from sales;
 
 ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
 
UPDATE sales 
set month_name=MONTHNAME(date);
----------------------------------------------------------------------------------
------------------------ EXPLORATORY DATA ANALYSIS ---------------------------
 #1 How many unique cities does the data have?
 SELECT distinct city from sales;
 
 #2 In which city is each branch?
 SELECT distinct city,branch from sales;
 
 #3 How many unique product lines does the data have?
 SELECT COUNT(DISTINCT product_line) FROM sales;
 

#4 what is the most selling product line?
SELECT product_line,
COUNT(product_line) AS CNT FROM sales 
GROUP BY product_line
ORDER BY CNT DESC;

#5 What is the total revenue by month?
SELECT month_name AS MONTH, SUM(TOTAL) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

#6 Create a stored procedure that retrieves all the details of a sale based on the provided invoice ID. 
DELIMITER //
CREATE PROCEDURE GetSalesDetailsbyInvoiceID(IN invoiceID VARCHAR(30))
BEGIN
SELECT * FROM walmartsales.sales
WHERE Invoice_ID=invoiceID;
END//
DELIMITER ;

CALL GetSalesDetailsbyInvoiceID('102-77-2261');



# 7 Create a stored procedure that takes two parameters, branch_name and gender, and returns a summary of sales transactions for the specified branch and gender.
DELIMITER // 
CREATE PROCEDURE GetDetailsByBranchandgender (IN branch_name Varchar(20), IN gender varchar(10))
BEGIN
SELECT * FROM sales
WHERE Branch=branch_name AND Gender=gender;
END //
DELIMITER ;

CALL GetDetailsByBranchandgender('A', 'Female');


#8-- What product line had the largest revenue?
SELECT
	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

#9-- What is the city with the largest revenue?
#SELECT FORMAT(Total, 2) AS formatted_total FROM sales;
SELECT
	branch,
	city,
    SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;

#10 Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

#11 What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

#12 How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM sales;

#13 How many unique payment methods does the data have?
SELECT
	DISTINCT payment_cogs
FROM sales;

#14  Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;

#15 What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

#16 Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

#17 Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

#18 Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;












  
 
 
 