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

-- #5 Create a temporary table, status
-- months temp table
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
-- cross_join table
cross_join AS 
(SELECT *
FROM subscriptions
CROSS JOIN months),
-- status temp table
status AS 
(SELECT id, STRFTIME('%m', first_day) AS 'month',
  CASE
    WHEN (subscription_start < first_day)
      AND (segment = 87
        AND subscription_end > first_day
            OR subscription_end IS NULL) THEN 1
    ELSE 0    
  END AS 'is_active_87',
  CASE
    WHEN (subscription_start < first_day)
      AND (segment = 30
        AND subscription_end > first_day
            OR subscription_end IS NULL) THEN 1
    ELSE 0    
  END AS 'is_active_30'
FROM cross_join)

SELECT *
FROM status
LIMIT 50;

-- #6 Add an is_canceled_87 and an is_canceled_30 column to the status temporary table
-- months temp table
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
-- cross_join table
cross_join AS 
(SELECT *
FROM subscriptions
CROSS JOIN months),
-- status temp table
status AS 
(SELECT id, STRFTIME('%m', first_day) AS 'month',
  -- add column is_active_87 by CASE
  CASE
    WHEN (subscription_start < first_day)
      AND (segment = 87
        AND subscription_end > first_day
            OR subscription_end IS NULL) THEN 1
    ELSE 0    
  END AS 'is_active_87',
  -- add column is_active_30 by CASE
  CASE
    WHEN (subscription_start < first_day)
      AND (segment = 30
        AND subscription_end > first_day
            OR subscription_end IS NULL) THEN 1
    ELSE 0    
  END AS 'is_active_30',
  -- add column is_canceled_87 by CASE
  CASE
    WHEN (segment = 87) 
      AND (subscription_end BETWEEN first_day AND last_day)
        THEN 1
    ELSE 0
  END AS 'is_canceled_87',
  -- add column is_canceled_30 by CASE
  CASE
    WHEN (segment = 30) 
      AND (subscription_end BETWEEN first_day AND last_day)
        THEN 1
    ELSE 0
  END AS 'is_canceled_30'
FROM cross_join)

SELECT *
FROM status
LIMIT 50;

-- #7 Create a status_aggregate temporary table
-- months temp table
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
-- cross_join table
cross_join AS 
(SELECT *
FROM subscriptions
CROSS JOIN months),
-- status temp table
status AS 
(SELECT id, STRFTIME('%m', first_day) AS 'month',
  -- add column is_active_87 by CASE
  CASE
    WHEN (subscription_start < first_day)
      AND (segment = 87
        AND subscription_end > first_day
            OR subscription_end IS NULL) THEN 1
    ELSE 0    
  END AS 'is_active_87',
  -- add column is_active_30 by CASE
  CASE
    WHEN (subscription_start < first_day)
      AND (segment = 30
        AND subscription_end > first_day
            OR subscription_end IS NULL) THEN 1
    ELSE 0    
  END AS 'is_active_30',
  -- add column is_canceled_87 by CASE
  CASE
    WHEN (segment = 87) 
      AND (subscription_end BETWEEN first_day AND last_day)
        THEN 1
    ELSE 0
  END AS 'is_canceled_87',
  -- add column is_canceled_30 by CASE
  CASE
    WHEN (segment = 30) 
      AND (subscription_end BETWEEN first_day AND last_day)
        THEN 1
    ELSE 0
  END AS 'is_canceled_30'
FROM cross_join),

status_aggregate AS 
(SELECT month,
    SUM(is_active_87) AS 'sum_active_87', 
    SUM(is_active_30) AS 'sum_active_30', 
    SUM(is_canceled_87) AS 'sum_canceled_87', 
    SUM(is_canceled_30) AS 'sum_canceled_30'
FROM status
GROUP BY 1)

SELECT *
FROM status_aggregate
LIMIT 50;

-- #8 Calculate the churn rates for the two segments over the three month period
-- months temp table
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
-- cross_join table
cross_join AS 
(SELECT *
FROM subscriptions
CROSS JOIN months),
-- status temp table
status AS 
(SELECT id, STRFTIME('%m', first_day) AS 'month',
  -- add column is_active_87 by CASE
  CASE
    WHEN (subscription_start < first_day)
      AND (segment = 87
        AND subscription_end > first_day
            OR subscription_end IS NULL) THEN 1
    ELSE 0    
  END AS 'is_active_87',
  -- add column is_active_30 by CASE
  CASE
    WHEN (subscription_start < first_day)
      AND (segment = 30
        AND subscription_end > first_day
            OR subscription_end IS NULL) THEN 1
    ELSE 0    
  END AS 'is_active_30',
  -- add column is_canceled_87 by CASE
  CASE
    WHEN (segment = 87) 
      AND (subscription_end BETWEEN first_day AND last_day)
        THEN 1
    ELSE 0
  END AS 'is_canceled_87',
  -- add column is_canceled_30 by CASE
  CASE
    WHEN (segment = 30) 
      AND (subscription_end BETWEEN first_day AND last_day)
        THEN 1
    ELSE 0
  END AS 'is_canceled_30'
FROM cross_join),
-- status_aggregate temp table
status_aggregate AS 
(SELECT month,
  SUM(is_active_87) AS 'sum_active_87', 
  SUM(is_active_30) AS 'sum_active_30', 
  SUM(is_canceled_87) AS 'sum_canceled_87', 
  SUM(is_canceled_30) AS 'sum_canceled_30'
FROM status
GROUP BY 1)
-- final query
SELECT *,
  ROUND(1.0 * sum_canceled_87 / sum_active_87, 3) AS 'churn_rate_87',
  ROUND(1.0 * sum_canceled_30 / sum_active_30, 3) AS 'churn_rate_30'
FROM status_aggregate
LIMIT 50;