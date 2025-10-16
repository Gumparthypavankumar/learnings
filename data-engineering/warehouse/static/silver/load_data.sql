/*
===============================================================================
Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This performs the ETL (Extract, Transform, Load) process to
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:
    None.
	  This stored procedure does not accept any parameters or return any values.

Usage Example:

===============================================================================
*/
TRUNCATE TABLE `crm_cust_info`;

INSERT INTO `crm_cust_info`(
    `id`, `key`, `firstname`, `lastname`, `marital_status`,
    `gender`, `created_date`
)
SELECT
    src.id,
    src.key,
    TRIM(src.firstname) as firstname,
    TRIM(src.lastname) as lastname,
    CASE UPPER(TRIM(src.marital_status))
         WHEN 'S' THEN 'Single'
         WHEN 'M' THEN 'Married'
         ELSE 'n/a'
    END as marital_status,
    CASE UPPER(TRIM(src.gender))
         WHEN 'F' THEN 'Female'
         WHEN 'M' THEN 'Male'
         ELSE 'n/a'
    END as gender,
    IFNULL(src.created_date, NULL) as created_date
FROM (
    SELECT
        *,
        row_number() over(partition by id order by created_date desc) as recent
    FROM bronze.src_crm_cust_info
    WHERE id IS NOT NULL
) src WHERE recent = 1;


TRUNCATE `crm_prd_info`;

INSERT INTO `crm_prd_info` (
    `id`, `key`, `category_id`,
    `product_key`, `nm`, `cost`,
    `line`, `start_date`, `end_date`
)
SELECT
    prd.id,
    prd.key,
    replace(substr(prd.key, 1, 5), '-', '_') as category_id,
    substr(prd.key, 7, length(prd.key)) as product_key,
    prd.nm,
    IFNULL(prd.cost, 0) as cost,
    CASE UPPER(TRIM(prd.line))
         WHEN 'M' THEN 'Mountain'
         WHEN 'R' THEN 'Road'
         WHEN 'S' THEN 'Other Sales'
         WHEN 'T' THEN 'Touring'
         ELSE 'n/a'
    END as line,
    prd.start_date,
    LAG(DATE_SUB(start_date, INTERVAL 1 DAY)) OVER(partition by prd.key order by id desc) as end_date
FROM
    bronze.src_crm_prd_info as prd;
