# Avoid Function in WHERE Clause

Create  table:
```sql
DROP TABLE IF EXISTS function_where;

CREATE TABLE function_where (
product_id VARCHAR(10) PRIMARY KEY,
production_date DATE,
batch INTEGER,
total_product INTEGER,
status VARCHAR(25)
);

INSERT INTO function_where
VALUES
('P101', '2023-08-17', 1, 100, 'Delivered'),
('Q102', '2024-01-01', 2, 200, 'Shipped'),
('R103', '2024-05-11', 3, 300, 'Check Out'),
('P104', '2024-12-31', 4, 400, 'Delivered'),
('P105', '2025-02-21', 5, 500, 'Delivered'),
('Q106', '2025-07-30', 6, 600, 'Shipped');

SELECT * FROM function_where
```
![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Best%20Practices/Avoid%20Function%20in%20WHERE%20Clause/image/function_where.png)

### 1. Check the status of all product that product_id is starting with P.
First method:
```sql
SELECT
	product_id,
	status
FROM function_where
WHERE SUBSTRING(product_id,1,1) = 'P';
```
![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Best%20Practices/Avoid%20Function%20in%20WHERE%20Clause/image/number_1.png)

Second method::
```sql
SELECT
	product_id,
	status
FROM function_where
WHERE product_id LIKE 'P%';
```
![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Best%20Practices/Avoid%20Function%20in%20WHERE%20Clause/image/number_1_method_2.png)

Note: LIKE is an operator, not a function.
The second method is the best practice

### 2. Find out all products that have been delivered
First method:
```sql
SELECT 
	*
FROM function_where
WHERE UPPER(status) = 'DELIVERED';
```

![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Best%20Practices/Avoid%20Function%20in%20WHERE%20Clause/image/number_2_method_1.png)

Second method:
```sql
SELECT 
	*
FROM function_where
WHERE status = 'Delivered';
```

![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Best%20Practices/Avoid%20Function%20in%20WHERE%20Clause/image/number_2_method_2.png)

The second method is the best practice

### 3. Find all product that manufactured in 2024
First method:
```sql
SELECT
	*
FROM function_where
WHERE STRFTIME('%Y', production_date) = '2024';
```

![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Best%20Practices/Avoid%20Function%20in%20WHERE%20Clause/image/number_3_method_1.png)

Second method:
```sql
SELECT
	*
FROM function_where
WHERE production_date BETWEEN '2024-01-01' AND '2024-12-31';
```

And here is the final result:
![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Best%20Practices/Avoid%20Function%20in%20WHERE%20Clause/image/number_3_method_2.png)

The second method is the best practice.

By filtering the first table, then the row size of the table is decreasing. It will make the join process faster. The first attempt is not efficient because the data that we don't want will do the JOIN process then filtered through WHERE. You get the feeling.
