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
SELECT
    src.*
FROM (
    SELECT
        *,
        row_number() over(partition by id order by created_date desc) as recent
    FROM silver.crm_cust_info
    WHERE id IS NOT NULL
) src WHERE src.recent > 1
;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT * FROM silver.crm_cust_info AS cst WHERE cst.key != trim(cst.key);

-- Data Standardization & Consistency
SELECT DISTINCT
    marital_status
FROM silver.crm_cust_info;