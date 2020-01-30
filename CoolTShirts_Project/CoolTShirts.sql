/*want to understand how many distinct campaigns the company has
running, the number of sources they have, and how they are
related*/
SELECT COUNT (DISTINCT utm_campaign)
FROM pageVistsData;

SELECT COUNT (DISTINCT utm_source)
FROM pageVistsData;

SELECT DISTINCT utm_campaign, utm_source
FROM pageVistsData
ORDER BY utm_source;

/* want to find what pages are on the wesbiste
*/
SELECT DISTINCT page_name
FROM pageVistsData;

/*want to find how many first touches each campaign is 
responsible for in order to see which is most effective
*/
WITH first_touch AS 
(
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM pageVistsData
    GROUP BY user_id
),
ft_attr AS 
(
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN pageVistsData pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source,
       ft_attr.utm_campaign,
       COUNT(*)
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/*want to find out how many last touched each campaign is
responsible in order to see which was most effective
*/
WITH last_touch AS 
(
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM pageVistsData
    GROUP BY user_id
),
lt_attr AS 
(
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN pageVistsData pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/*want to know how many visitors make a purchase
*/
SELECT DISTINCT page_name, COUNT (page_name)
FROM pageVistsData
GROUP BY page_name
ORDER BY page_name DESC;

/*how many last touches on the purchase page is
each campaign responsible for
*/
SELECT utm_campaign, 
	COUNT (DISTINCT user_id) AS '#_of_touches'
FROM pageVistsData
WHERE page_name = '4 - purchase'
GROUP BY utm_campaign
ORDER BY #_of_touches DESC;

/*the company can now look at the top campaigns and where
the most amount of user are going. This can be used to
understand where to allocate funds

