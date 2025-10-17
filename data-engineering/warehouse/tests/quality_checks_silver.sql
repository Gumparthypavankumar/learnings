/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/
-- ======================================================
-- Checking `silver.crm_cust_info`
-- ======================================================
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Results
SELECT src.*
FROM (SELECT *,
             row_number() over (partition by id order by created_date desc) as recent
      FROM silver.crm_cust_info
      WHERE id IS NOT NULL) src
WHERE src.recent > 1
;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT *
FROM silver.crm_cust_info AS cst
WHERE cst.key != trim(cst.key);

-- Data Standardization & Consistency
SELECT DISTINCT marital_status
FROM silver.crm_cust_info;

-- ======================================================
-- Checking `silver.crm_prd_info`
-- ======================================================
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Results

SELECT id
FROM silver.crm_prd_info
GROUP BY id
HAVING COUNT(*) > 1
    or id is NULL
;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT prd.nm
FROM silver.crm_prd_info AS prd
WHERE prd.nm != trim(prd.nm);

-- Check for Nulls or Negative Values in Cost
-- Expectation: No Results
SELECT prd.cost
FROM silver.crm_prd_info AS prd
WHERE prd.cost is NULL
   or prd.cost < 0;

-- Data Standardization & Consistency
SELECT DISTINCT prd.line
FROM silver.crm_prd_info as prd;

-- Check for Invalid Date Orders (Start Date > End Date)
-- Expectation: No Results
SELECT prd.*
FROM silver.crm_prd_info as prd
WHERE prd.start_date > prd.end_date;

/*
An Example:

+------+-----------------+-------------+-------------+-------------------------+------+-------------+------------+------------+
| id   | key             | category_id | product_key | nm                      | cost | line        | start_date | end_date   |
+------+-----------------+-------------+-------------+-------------------------+------+-------------+------------+------------+
|  212 | AC-HE-HL-U509-R | AC_HE       | HL-U509-R   | Sport-100 Helmet- Red   | 12   | Other Sales | 2011-07-01 | 2007-12-28 |
|  213 | AC-HE-HL-U509-R | AC_HE       | HL-U509-R   | Sport-100 Helmet- Red   | 14   | Other Sales | 2012-07-01 | 2008-12-27 |
|  214 | AC-HE-HL-U509-R | AC_HE       | HL-U509-R   | Sport-100 Helmet- Red   | 13   | Other Sales | 2013-07-01 | NULL       |
|                                                                                                                             |
|  215 | AC-HE-HL-U509   | AC_HE       | HL-U509     | Sport-100 Helmet- Black | 12   | Other Sales | 2011-07-01 | 2007-12-28 |
|  216 | AC-HE-HL-U509   | AC_HE       | HL-U509     | Sport-100 Helmet- Black | 14   | Other Sales | 2012-07-01 | 2008-12-27 |
|  217 | AC-HE-HL-U509   | AC_HE       | HL-U509     | Sport-100 Helmet- Black | 13   | Other Sales | 2013-07-01 | NULL       |
+------+-----------------+-------------+-------------+-------------------------+------+-------------+------------+------------+

In this example as you see the end_date conflicts with the next start_date, ideally this means the data is not well formed / it is setup basis to some business context,
any such case you will analyse and formulate the data that is appropriate. For the sake of this example we will simply consider the end_date of current is start_date - 1 of preceding
*/

-- ======================================================
-- Checking `silver.crm_sales_details`
-- ======================================================
-- Check for Invalid Dates
-- Expectation: No Results
SELECT NULLIF(sls.order_dt, 0)
FROM silver.crm_sales_details as sls
WHERE sls.order_dt <= 0
   OR length(sls.order_dt) != 8
   OR sls.order_dt > 20500101
   OR sls.order_dt < 19000101;

-- Check for Invalid Date Orders (Order Date > Shipping / Due Dates)
-- Expectation: No Results

SELECT sls.order_dt,
       sls.ship_dt,
       sls.due_dt
FROM silver.crm_sales_details as sls
WHERE sls.order_dt > sls.ship_dt
   OR sls.order_dt > sls.due_dt;

-- Check Data Consistency: Sales = Quantity * Price
-- Expectations: No Results

SELECT sls.sales,
       sls.quantity,
       sls.price
FROM silver.crm_sales_details as sls
WHERE sls.sales != (sls.quantity * sls.price)
   OR sls.sales IS NULL
   OR sls.price IS NULL
   OR sls.quantity IS NULL
   OR sls.price <= 0
   OR sls.quantity <= 0
   OR sls.sales <= 0
;

-- ======================================================
-- Checking `silver.erp_cust_az12`
-- ======================================================
-- Check customer ids not existing in crm_cust_info
-- Expectation: No Results
SELECT cst.id,
       CASE
           WHEN substr(cst.id, 1, 3) LIKE 'NAS%' THEN substr(cst.id, 4, length(cst.id))
           ELSE cst.id
           END as cst_id,
       cst.birth_date,
       cst.gender
FROM silver.erp_cust_az12 as cst
WHERE CASE
          WHEN substr(cst.id, 1, 3) LIKE 'NAS%' THEN substr(cst.id, 4, length(cst.id))
          ELSE cst.id END NOT IN (SELECT c.key FROM silver.crm_cust_info c);

-- Identify Out-of-Range Dates
-- Expectation: No Results

SELECT cst.birth_date
FROM silver.erp_cust_az12 as cst
WHERE cst.birth_date > current_date();

-- Data Standardization & Consistency
SELECT DISTINCT cst.gender
FROM silver.erp_cust_az12 as cst;

-- ======================================================
-- Checking `silver.erp_loc_a101`
-- ======================================================
-- Data Standardization & Consistency
SELECT DISTINCT loc.country
FROM silver.erp_loc_a101 as loc;

-- ======================================================
-- Checking `silver.erp_px_cat_g1v2`
-- ======================================================
-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE id != TRIM(id)
   OR category != TRIM(category)
   OR sub_category != TRIM(sub_category)
;

-- Data Standardization & Consistency
SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2;
