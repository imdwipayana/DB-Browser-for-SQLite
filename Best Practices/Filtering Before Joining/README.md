# Filtering Before Joining

Create  the first table:
```sql
DROP TABLE IF EXISTS production_status;

CREATE TABLE production_status (
product_id VARCHAR(10) PRIMARY KEY,
production_date DATE,
batch INTEGER,
total_product INTEGER,
status VARCHAR(25)
);

INSERT INTO production_status
VALUES
('P101', '2023-08-17', 1, 100, 'Delivered'),
('P102', '2024-01-01', 2, 200, 'Shipped'),
('P103', '2024-05-11', 3, 300, 'Check Out'),
('P104', '2024-12-31', 4, 400, 'Delivered'),
('P105', '2025-02-21', 5, 500, 'Delivered'),
('P106', '2025-07-30', 6, 600, 'Shipped');

SELECT * FROM production_status;
```
![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Best%20Practices/Filtering%20Before%20Joining/image/production_status.png)

Create  the second table:
```sql
DROP TABLE IF EXISTS sales_product;

CREATE TABLE sales_product (
product_id VARCHAR(10) PRIMARY KEY,
warehouse VARCHAR(50),
total_sales FLOAT
);

INSERT INTO sales_product
VALUES
('P101', 'Edmonton',  200000),
('P102', 'Toronto',   300000),
('P103', 'Regina',    400000),
('P104', 'Saskatoon', 500000),
('P105', 'Vancouver', 600000),
('P106', 'Ottawa',    700000),
('P107', 'Winnippeg', 800000),
('P108', 'Calgary',   900000);

SELECT * FROM sales_product;
```
![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Best%20Practices/Filtering%20Before%20Joining/image/sales_product.png)

### 1. Find out total sales of all product that already delivered
First method: joining first then filtering.
```sql
SELECT
	ps.product_id,
	sp.total_sales
FROM production_status AS ps
INNER JOIN sales_product AS sp
ON ps.product_id = sp.product_id
WHERE ps.status = 'Delivered';
```
![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Best%20Practices/Filtering%20Before%20Joining/image/number_1_method_1.png)

Second method: process of filtering in the middle of joining.
```sql
SELECT
	ps.product_id,
	sp.total_sales
FROM production_status AS ps
INNER JOIN sales_product AS sp
ON ps.product_id = sp.product_id AND ps.status = 'Delivered';
```
![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Best%20Practices/Filtering%20Before%20Joining/image/number_1_method_2.png)

Third method: filtering first with CTE then calles CTE into the main query.
```sql
WITH CTE_filtering_joining as (
	SELECT
		*
	FROM production_status
	WHERE status = 'Delivered'
)

SELECT
	cfj.product_id,
	sp.total_sales
FROM CTE_filtering_joining AS cfj
INNER JOIN sales_product AS sp
ON cfj.product_id = sp.product_id;
```
The result of CTE:

![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Best%20Practices/Filtering%20Before%20Joining/image/number_1_method_3_cte.png)

The final result:

![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Best%20Practices/Filtering%20Before%20Joining/image/number_1_method_3.png)

Note: For small dataset, all 3 methods are applicable. But for large dataset, the third method is the best practice.
