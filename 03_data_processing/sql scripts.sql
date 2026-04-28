select * from `workspace`.`default`.`car_sales` limit 200;

-- Syntax to see the datatypes of all the columns
DESCRIBE TABLE car_sales;

-- Syntax to count the number of rows in the table
SELECT COUNT(*) AS total_rows
FROM car_sales;

-- Check missing values for all columns
SELECT
  COUNT(*) - COUNT(year) AS missing_year,
  COUNT(*) - COUNT(make) AS missing_make,
  COUNT(*) - COUNT(model) AS missing_model,
  COUNT(*) - COUNT(trim) AS missing_trim,
  COUNT(*) - COUNT(body) AS missing_body,
  COUNT(*) - COUNT(transmission) AS missing_transmission,
  COUNT(*) - COUNT(vin) AS missing_vin,
  COUNT(*) - COUNT(state) AS missing_state,
  COUNT(*) - COUNT(condition) AS missing_condition,
  COUNT(*) - COUNT(odometer) AS missing_odometer,
  COUNT(*) - COUNT(color) AS missing_color,
  COUNT(*) - COUNT(interior) AS missing_interior,
  COUNT(*) - COUNT(seller) AS missing_seller,
  COUNT(*) - COUNT(mmr) AS missing_mmr,
  COUNT(*) - COUNT(sellingprice) AS missing_sellingprice,
  COUNT(*) - COUNT(saledate) AS missing_saledate
FROM car_sales;

-- Check duplicates
SELECT
  vin,
  saledate,
  sellingprice,
  COUNT(*) AS duplicate_count
FROM car_sales
GROUP BY vin, saledate, sellingprice
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- Create cleaned car sales table
CREATE OR REPLACE TABLE car_sales_cleaned AS

WITH cleaned_dates AS (
  SELECT
    *,
    TO_TIMESTAMP(SUBSTRING(saledate, 5), 'MMM dd yyyy HH:mm:ss') AS sale_datetime
  FROM car_sales
)

SELECT
  CAST(year AS INT) AS car_year,

  INITCAP(TRIM(make)) AS make,
  INITCAP(TRIM(model)) AS model,
  INITCAP(TRIM(trim)) AS trim,
  INITCAP(TRIM(body)) AS body,
  INITCAP(TRIM(transmission)) AS transmission,

  LOWER(TRIM(vin)) AS vin,
  UPPER(TRIM(state)) AS state,

  CAST(condition AS INT) AS condition_score,
  CAST(odometer AS INT) AS odometer,

  INITCAP(TRIM(color)) AS exterior_color,

  COALESCE(
    NULLIF(INITCAP(TRIM(REGEXP_REPLACE(interior, '[^\\x00-\\x7F]', ''))), ''),
    'Unknown'
  ) AS interior_color,

  INITCAP(TRIM(seller)) AS seller,

  CAST(mmr AS DOUBLE) AS market_value_mmr,
  CAST(sellingprice AS DOUBLE) AS selling_price,

  sale_datetime,

  1 AS units_sold,
  CAST(sellingprice AS DOUBLE) AS total_revenue,

  CAST(sellingprice AS DOUBLE) - CAST(mmr AS DOUBLE) AS price_difference,

  ROUND(
    ((CAST(sellingprice AS DOUBLE) - CAST(mmr AS DOUBLE)) / CAST(mmr AS DOUBLE)) * 100,
    2
  ) AS price_difference_percentage,

  YEAR(sale_datetime) - CAST(year AS INT) AS car_age_at_sale,

  YEAR(sale_datetime) AS sale_year,
  MONTH(sale_datetime) AS sale_month_number,
  DATE_FORMAT(sale_datetime, 'MMMM') AS sale_month_name,
  QUARTER(sale_datetime) AS sale_quarter,
  DATE_FORMAT(sale_datetime, 'EEEE') AS sale_day_name,

  CASE
    WHEN CAST(odometer AS INT) < 30000 THEN '1. Low Mileage'
    WHEN CAST(odometer AS INT) BETWEEN 30000 AND 80000 THEN '2. Medium Mileage'
    WHEN CAST(odometer AS INT) > 80000 THEN '3. High Mileage'
    ELSE 'Unknown'
  END AS mileage_category,

  CASE
    WHEN CAST(sellingprice AS DOUBLE) < 10000 THEN '1. Budget Cars'
    WHEN CAST(sellingprice AS DOUBLE) BETWEEN 10000 AND 25000 THEN '2. Mid-Range Cars'
    WHEN CAST(sellingprice AS DOUBLE) > 25000 THEN '3. Premium Cars'
    ELSE 'Unknown'
  END AS price_category,

  CASE
    WHEN CAST(sellingprice AS DOUBLE) > CAST(mmr AS DOUBLE) THEN '1. Sold Above Market Value'
    WHEN CAST(sellingprice AS DOUBLE) = CAST(mmr AS DOUBLE) THEN '2. Sold At Market Value'
    WHEN CAST(sellingprice AS DOUBLE) < CAST(mmr AS DOUBLE) THEN '3. Sold Below Market Value'
    ELSE 'Unknown'
  END AS price_performance,

  CASE
    WHEN CAST(condition AS INT) >= 40 THEN '1. Excellent Condition'
    WHEN CAST(condition AS INT) BETWEEN 30 AND 39 THEN '2. Good Condition'
    WHEN CAST(condition AS INT) BETWEEN 20 AND 29 THEN '3. Fair Condition'
    WHEN CAST(condition AS INT) < 20 THEN '4. Poor Condition'
    ELSE 'Unknown'
  END AS condition_category

FROM cleaned_dates
WHERE sellingprice IS NOT NULL
  AND mmr IS NOT NULL
  AND year IS NOT NULL
  AND make IS NOT NULL
  AND model IS NOT NULL
  AND sale_datetime IS NOT NULL;

-- Checking columns
SELECT *
FROM car_sales_cleaned
LIMIT 500;

-- Check bad interior values:
SELECT DISTINCT interior_color
FROM car_sales_cleaned
ORDER BY interior_color;

-- Find the top 10 car makes by total revenue
SELECT
  make,
  COUNT(*) AS total_cars_sold,
  ROUND(SUM(total_revenue), 2) AS total_revenue,
  ROUND(AVG(selling_price), 2) AS average_selling_price
FROM car_sales_cleaned
GROUP BY make
ORDER BY total_revenue DESC
LIMIT 10;

-- Find the top 10 car models by revenue
SELECT
  make,
  model,
  COUNT(*) AS total_cars_sold,
  ROUND(SUM(total_revenue), 2) AS total_revenue,
  ROUND(AVG(selling_price), 2) AS average_selling_price
FROM car_sales_cleaned
GROUP BY make, model
ORDER BY total_revenue DESC
LIMIT 10;

