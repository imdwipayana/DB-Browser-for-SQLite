# LIMIT question
In number 1, the table will be ordered then it will be taken top 10 order. In number 2, it supposed to take the first 10 row of data, then do the order based on those 10 rows. But here the number 2 result is the same with number 1. It means that the data will be ordered no mather what at first then at the end will be taken the top 10. This is a litle bit strange for me because the main query ignore the subquery table. Edward gave me solution as writen in number 3. But I'm still in question why number 1 and number 2 are the same?


## 1. LIMIT 10
```sql
SELECT 
	*
FROM customer
ORDER BY customer_last_name
LIMIT 10;
```
The result of the query above:

![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Problem%20and%20Solution/LIMIT%20question/image/number1.png)


## 2. LIMIT 10 inside subquery
```sql
SELECT
	*
FROM(
	SELECT
		*
	FROM customer
	LIMIT 10
) AS Sub
ORDER BY customer_last_name;
```
The result of this query is the same as the previous query:

![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Problem%20and%20Solution/LIMIT%20question/image/number2.png)

The table in subquery:
```sql
SELECT
	*
FROM customer
LIMIT 10;
```

![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Problem%20and%20Solution/LIMIT%20question/image/number2subquery.png)

## 3. 3. LIMIT 10, Edward's solution by addting ORDER BY inside the subquery
```sql
SELECT
	*
FROM(
	SELECT
		*
	FROM customer
	ORDER BY customer_id
	LIMIT 10
) AS Sub
ORDER BY customer_last_name;
```
The result of this query is the same as the previous query:

![Library_project](https://github.com/imdwipayana/DB-Browser-for-SQLite/blob/main/Problem%20and%20Solution/LIMIT%20question/image/number3.png)
