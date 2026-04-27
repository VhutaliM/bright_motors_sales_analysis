select * from `workspace`.`default`.`car_sales` limit 200;

-- Syntax to see the datatypes of all the columns
DESCRIBE TABLE car_sales;

-- Syntax to count the number of rows in the table
SELECT COUNT(*) AS total_rows
FROM car_sales;

-- 2. Check missing values for all columns
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

