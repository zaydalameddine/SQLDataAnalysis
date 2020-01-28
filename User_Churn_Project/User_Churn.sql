/*Querying for the first 100 rows to understand
the layout of the table */
SELECT *
FROM subscriptionsData
LIMIT 100;

/*Determining the range of months of data provided
*/
SELECT MIN(subscription_start), MAX(subscription_start)
FROM subscriptionsData;