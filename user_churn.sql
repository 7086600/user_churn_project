-- Get familiar with the data
-- #1  Take a look at the first 100 rows of data in the subscriptions table
 SELECT *
 FROM subscriptions
 LIMIT 15;
--  there are 2 different segments: 30 and 87

-- #2 Determine the range of months of data provided. Which months will you be able to calculate churn for?
SELECT STRFTIME('%m', subscription_start) AS 'month', 
  COUNT(*)
FROM subscriptions
GROUP by 1;
-- there are 4 months: dec 2016 to march 2017

-- Calculate churn rate for each segment
-- #3 get started, create a temporary table of months
-- WITH months AS 
-- (SELECT
--   '2017-01-01' AS first_day,
--   '2017-01-31' AS last_day
-- UNION
-- SELECT
--   '2017-02-01' AS first_day,
--   '2017-02-28' AS last_day
-- UNION
-- SELECT
--   '2017-03-01' AS first_day,
--   '2017-03-31' AS last_day)
-- SELECT *
-- FROM months;

-- #4 Create a temporary table, cross_join, from subscriptions and your months
WITH months AS 
(SELECT
  '2017-01-01' AS first_day,
  '2017-01-31' AS last_day
UNION
SELECT
  '2017-02-01' AS first_day,
  '2017-02-28' AS last_day
UNION
SELECT
  '2017-03-01' AS first_day,
  '2017-03-31' AS last_day),
cross_join AS 
(SELECT *
FROM subscriptions
CROSS JOIN months)
SELECT *
FROM cross_join
LIMIT 50;