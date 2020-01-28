
/*Querying for the first 100 rows to understand
the layout of the table */
/*
SELECT *
FROM subscriptionsData
LIMIT 100;
*/

/*Determining the range of months of data provided
*/
/*
SELECT MIN(subscription_start), MAX(subscription_start)
FROM subscriptionsData;
*/

/*There are two segments in this data that will
be compared based on their churn rates. Below
I will be doing just that
*/

/*creating a temporary table months to use as 
reference throughout query
*/


WITH months AS 
(
  SELECT 
    '2017-01-01' AS first_day, 
    '2017-01-31' AS last_day 
  UNION 
  SELECT 
    '2017-02-01' AS first_day, 
    '2017-02-28' AS last_day 
  UNION 
  SELECT 
    '2017-03-01' AS first_day, 
    '2017-03-31' AS last_day
),

/* joining together months and subscriptionsData
for further manipulation
*/

cross_join AS 
(
  SELECT *
  FROM subscriptionsData
  CROSS JOIN months
),

/* creating a table that will contain data
checking if a user is active or not with
being active at the beginning of the month
considered as active. This will also be split
between segements
*/


status AS 
(
SELECT id, first_day AS month,
	CASE
		WHEN (segment = 87) 
			AND (subscription_start < first_day)
			AND	(subscription_end > first_day
			OR subscription_end IS NULL)
			THEN 1
		ELSE 0
	END AS is_active_87,

	CASE
		WHEN (segment = 30) 
			AND (subscription_start < first_day)
			AND	(subscription_end > first_day
			OR subscription_end IS NULL)
			THEN 1
		ELSE 0
	END AS is_active_30,

/*There will also be another coloumn in this
table to check if the user has cancelled
their subscription
*/

	CASE
		WHEN (segment = 87) 
			AND (subscription_end BETWEEN first_day
				AND last_day)
			THEN 1
		ELSE 0
	END AS is_canceled_87,
	
	CASE
		WHEN (segment = 30) 
			AND (subscription_end BETWEEN first_day
				AND last_day)
			THEN 1
		ELSE 0
	END AS is_canceled_30
FROM cross_join
),

/*Data is manipulated to find the sum of users falling under
category per month
*/
status_aggregate AS 
(
SELECT month,
    SUM(is_active_87) AS sum_active_87, 
    SUM(is_active_30) AS sum_active_30,
	SUM(is_canceled_87) AS sum_canceled_87, 
    SUM(is_canceled_30) AS sum_canceled_30
  FROM status
  GROUP by month
)

/*finally the churn rate is calculated! (Rounded for simplicity)
*/
SELECT
  month, 
  ROUND((1.0 * sum_canceled_87/sum_active_87),2) AS churn_rate_87,
  ROUND((1.0 * sum_canceled_30/sum_active_30),2) AS churn_rate_30
FROM status_aggregate;












