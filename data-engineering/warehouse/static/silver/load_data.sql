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
