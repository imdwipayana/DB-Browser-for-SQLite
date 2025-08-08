--========================================================
-- 1. LIMIT 10
--========================================================
SELECT 
	*
FROM customer
ORDER BY customer_last_name
LIMIT 10;


--========================================================
-- 2. LIMIT 10 as subquery
--========================================================
SELECT
	*
FROM(
	SELECT
		*
	FROM customer
	LIMIT 10
) AS Sub
ORDER BY customer_last_name

--Subquery result:
SELECT
	*
FROM customer
LIMIT 10


--================================================================
-- 3. LIMIT 10, Edward's solution by addting ORDER BY inside query
--================================================================
SELECT
	*
FROM(
	SELECT
		*
	FROM customer
	ORDER BY customer_id
	LIMIT 10
) AS Sub
ORDER BY customer_last_name





