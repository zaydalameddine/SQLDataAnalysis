/*understanding the format of the first table examined 'survey'
*/
SELECT *
FROM survey
LIMIT 10;

/*wanting to see how many users make it to the next question
*/
SELECT question, COUNT(DISTINCT user_id)
FROM survey
GROUP BY 1;

/*created a result set to see if the user tried the glasses 
on at home, how many pairs they took, and if they purchased
a pair.
*/
SELECT quizData.user_id, 
	homeTryOnData.user_id IS NOT NULL AS 'is_home_try_on',
	homeTryOnData.number_of_pairs,
	purchaseData.user_id IS NOT NULL AS 'is_purchase'
FROM quizData
LEFT JOIN homeTryOnData
	ON quizData.user_id = homeTryOnData.user_id
LEFT JOIN purchaseData
	ON homeTryOnData.user_id = purchaseData.user_id
ORDER BY quizData.user_id DESC




