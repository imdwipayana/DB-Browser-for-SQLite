--=================================================================================
-- DROP book_data_sold table if it exists
--=================================================================================
DROP TABLE IF EXISTS book_data_sold;

--=================================================================================
-- CREATE book_data_sold table 
--=================================================================================
CREATE TABLE book_data_sold(
book_id VARCHAR(10) PRIMARY KEY,
book_title VARCHAR(50),
genre VARCHAR(25),
in_stock INTEGER,
number_sold INTEGER,
pages INTEGER,
price FLOAT
);

--=================================================================================
-- INSERT book_data_sold table value
--=================================================================================
INSERT INTO book_data_sold
VALUES 
('M101', 'The Who',            'Mystery',  15, 75,  315, 100),
('T201', 'Back to Zero',       'Thriller', 20, 50,  295, 400),
('C301', 'Kill Billy',         'Crime',    25, 100, 415, 50),
('T202', 'What If',            'Thriller', 5,  50,  394, 500),
('C302', 'The Killer',         'Crime',    40, 75,  452, 100),
('M102', 'Unwanted',           'Mystery',  35, 100, 512, 200),
('M103', 'Right or Wrong',     'Mystery',  15, 50,  314, 300),
('C303', 'Stolen Soul',        'Crime',    20, 25,  399, 150),
('T203', 'The Broken Promise', 'Thriller', 25, 25,  418, 600),
('C304', 'The Culprit',        'Crime',    35, 100, 550, 200);

--=================================================================================
-- Call the book_data table
--=================================================================================
SELECT * FROM book_data_sold;

--=================================================================================
-- 1. FIND the book total sales of all books.
--=================================================================================
-- First method: using subquery. 
---- First step: calculate the total sales of each book by multiplying number_sold column with price.
SELECT
	*,
	number_sold*price AS sales
FROM book_data_sold;
---- Second step: using SUM() for column sales to find out the total sales.
SELECT
	SUM(sales) AS total_sales
FROM (SELECT
	     *,
	     number_sold*price AS sales
      FROM book_data_sold
);

-- Second method: using Common Table Expression (CTE)
WITH CTE_sales AS (
	SELECT
		*,
		number_sold*price AS sales
	FROM book_data_sold
)

SELECT
	SUM(sales) AS total_sales
FROM CTE_sales;

-- Third method: using VIEWS
DROP VIEW IF EXISTS VIEW_sales;
CREATE VIEW VIEW_sales AS 
	SELECT
		*,
		number_sold*price AS sales
	FROM book_data_sold;

SELECT
	SUM(sales) AS total_sales
FROM VIEW_sales;
--=================================================================================
-- 2. with VIEW, find all the most expensive book for each genre
--=================================================================================
DROP VIEW IF EXISTS VIEW_expensive_genre;
CREATE VIEW VIEW_expensive_genre AS 
	SELECT
		*,
		RANK() OVER(PARTITION BY genre ORDER BY price DESC) AS price_category
	FROM book_data_sold;

SELECT
	*
FROM VIEW_expensive_genre
WHERE price_category = 1;

--=================================================================================
-- 3. Create a new category based on the price. The book that higher than the average price is expensive. Menwhile, if it is less than the average then it is cheap.
--=================================================================================
DROP VIEW IF EXISTS VIEW_book_average;
CREATE VIEW VIEW_book_average AS
	SELECT 
		*,
		AVG(price) OVER() AS price_average
	FROM book_data_sold;

SELECT
	*,
	CASE
		WHEN price < price_average THEN 'cheap'
		ELSE 'expensive'
	END AS price_category
FROM VIEW_book_average
ORDER BY price;

--=================================================================================
-- 4. Compare the previous result when we use NTILE() instead.
--=================================================================================
DROP VIEW IF EXISTS VIEW_group_ntile;
CREATE VIEW VIEW_group_ntile AS 
	SELECT
		*,
		NTILE(2) OVER(ORDER BY price) AS two_group
	FROM book_data_sold;

SELECT 
	*,
	CASE
		WHEN two_group = 1 THEN 'cheap'
		ELSE 'expensive'
	END AS price_category
FROM VIEW_group_ntile;
--=================================================================================
-- 5. Find top three selling book based on price category.
--=================================================================================
DROP VIEW IF EXISTS VIEW_book_average;
CREATE VIEW VIEW_book_average AS 
	SELECT 
		*,
		AVG(price) OVER() AS price_average
	FROM book_data_sold;

	
DROP VIEW IF EXISTS VIEW_price_catgory;	
CREATE VIEW VIEW_price_category AS 
	SELECT
		*,
		CASE
			WHEN price < price_average THEN 'cheap'
			ELSE 'expensive'
		END as price_category
	FROM VIEW_book_average
	ORDER BY price;

DROP VIEW IF EXISTS VIEW_rank_number_sold;
CREATE VIEW VIEW_rank_number_sold AS 
	SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY price_category ORDER BY number_sold DESC) AS rank_number_sold
	FROM VIEW_price_category;

SELECT
	*
FROM VIEW_rank_number_sold
WHERE rank_number_sold <=3;

--=================================================================================
-- 6. Find all the book which sales is in top 40%
--=================================================================================
DROP VIEW IF EXISTS VIEW_sales;
CREATE VIEW VIEW_sales AS
	SELECT
		*,
		number_sold*price AS sales
	FROM book_data_sold;

DROP VIEW IF EXISTS VIEW_sales_dist;
CREATE VIEW VIEW_sales_dist AS 
	SELECT 
		*,
		CUME_DIST() OVER(ORDER BY sales DESC) AS sales_dist
	FROM VIEW_sales;

SELECT
	*,
	CONCAT(sales_dist*100,'%') AS top_sales_dist_percentage
FROM VIEW_sales_dist
WHERE sales_dist <= 0.4;

