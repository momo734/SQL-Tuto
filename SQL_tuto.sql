drop table if exists zepto
create table zepto (
sku_id SERIAL PRIMARY KEY,
name VARCHAR(150) NOT NULL,
category VARCHAR(120),
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);


--DATA EXPLORATION

--count of rows
SELECT COUNT(*) from zepto;

--sample data
SELECT * from zepto
LIMIT 10;

--check it has null value
SELECT * from zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
availableQuantity IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--differnt category
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--product instock vs out-of-stock
SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;

--product names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) desc;

--data cleaning
--products with price = 0
SELECT * FROM zepto
WHERE mrp =0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp=0;

--convert paise to rupaise
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto

--Q1: Find the top best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--Q2: What are the products with High,MRP but Out of Stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = 'True' and mrp > 300
ORDER BY mrp DESC;

--Q3: Calculate Estimated Revenue for each category
SELECT 
    category,
    SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

--Q4:Find all products where MRP is greater than 500 and discount is less than 10%
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

--Q5:Identify the top 5 categories offering the highest average discount percentage
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;


--Q6:Find the price per gram for products abive 100g and sort by best value
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;


--Q7:Group the products into categories like low, medium, bulk
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
     WHEN weightInGms < 5000 THEN 'Medium'
	 ELSE 'Bulk'
	 END AS weight_category
FROM zepto;

--Q8:What is the total inventory weight per category
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;