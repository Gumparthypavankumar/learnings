/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency,
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results
SELECT customer_key,
       count(*) as cnt
FROM gold.dim_customers as cst
GROUP BY cst.customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results
SELECT prd.product_key
FROM gold.dim_products as prd
GROUP BY prd.product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT *
FROM gold.fact_sales as fcs
         LEFT JOIN gold.dim_customers as cst
                   ON cst.customer_key = fcs.customer_key
         LEFT JOIN gold.dim_products as prd
                   ON fcs.product_key = prd.product_key
WHERE prd.product_key IS NULL
   OR cst.customer_key IS NULL;