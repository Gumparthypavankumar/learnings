/*
===========================================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===========================================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:
    None.
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL load_silver();
===========================================================================================
*/

DROP PROCEDURE IF EXISTS `load_silver`;

DELIMITER $$

CREATE PROCEDURE load_silver()
BEGIN
    DECLARE state, error_msg VARCHAR(255);
    DECLARE batch_start_time, batch_end_time, start_time, end_time TIMESTAMP;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                @state = RETURNED_SQLSTATE,
                @error_msg = MESSAGE_TEXT;
            SELECT '============================================';
            SELECT CONCAT("Error Occurred with state: ", @state, " and message: ", @error_msg);
            SELECT '============================================';
        END;
    SET @batch_start_time = now();
    SELECT '============================================';
    SELECT 'Silver Batch Loading Begin';
    SELECT '============================================';
    SET @start_time = now();
    SELECT '>> Truncating table: crm_cust_info';
    TRUNCATE TABLE `crm_cust_info`;
    SELECT '>> Inserting data into table: crm_cust_info';
    INSERT INTO `crm_cust_info`(`id`, `key`, `firstname`, `lastname`, `marital_status`,
                                `gender`, `created_date`)
    SELECT src.id,
           src.key,
           TRIM(src.firstname)            as firstname,
           TRIM(src.lastname)             as lastname,
           CASE UPPER(TRIM(src.marital_status))
               WHEN 'S' THEN 'Single'
               WHEN 'M' THEN 'Married'
               ELSE 'n/a'
               END                        as marital_status,
           CASE UPPER(TRIM(src.gender))
               WHEN 'F' THEN 'Female'
               WHEN 'M' THEN 'Male'
               ELSE 'n/a'
               END                        as gender,
           IFNULL(src.created_date, NULL) as created_date
    FROM (SELECT *,
                 row_number() over (partition by id order by created_date desc) as recent
          FROM bronze.src_crm_cust_info
          WHERE id IS NOT NULL) src
    WHERE recent = 1;
    SET @end_time = now();
    SELECT CONCAT('Load Duration for crm_cust_info is ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' SECONDS');

    SELECT '============================================';
    SET @start_time = now();
    SELECT '>> Truncating table: crm_prd_info';
    SELECT '>> Inserting data into table: crm_prd_info';
    TRUNCATE `crm_prd_info`;

    INSERT INTO `crm_prd_info` (`id`, `category_id`,
                                `product_key`, `nm`, `cost`,
                                `line`, `start_date`, `end_date`)
    SELECT prd.id,
           replace(substr(prd.key, 1, 5), '-', '_')                                               as category_id,
           substr(prd.key, 7, length(prd.key))                                                    as product_key,
           prd.nm,
           IFNULL(prd.cost, 0)                                                                    as cost,
           CASE UPPER(TRIM(prd.line))
               WHEN 'M' THEN 'Mountain'
               WHEN 'R' THEN 'Road'
               WHEN 'S' THEN 'Other Sales'
               WHEN 'T' THEN 'Touring'
               ELSE 'n/a'
               END                                                                                as line,
           prd.start_date,
           LAG(DATE_SUB(start_date, INTERVAL 1 DAY)) OVER (partition by prd.key order by id desc) as end_date
    FROM bronze.src_crm_prd_info as prd;
    SET @end_time = now();
    SELECT CONCAT('Load Duration for crm_prd_info is ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' SECONDS');
    /*
        Notes:
            Following rules are Applied:
                1. If sales is negative, zero or null, derive it using quantity and price
                2. If price is zero or null, calculate it using sales and quantity
                3. If price is negative, convert it to a positive value
    */
    SELECT '============================================';
    SET @start_time = now();
    SELECT '>> Truncating table: crm_sales_details';
    SELECT '>> Inserting data into table: crm_sales_details';
    TRUNCATE `crm_sales_details`;

    INSERT INTO `crm_sales_details` (`ord_num`, `prd_key`, `cust_id`,
                                     `order_dt`, `ship_dt`, `due_dt`,
                                     `sales`, `quantity`, `price`)
    SELECT sls.ord_num,
           sls.prd_key,
           sls.cust_id,
           CASE
               WHEN sls.order_dt = 0 OR length(sls.order_dt) != 8 THEN NULL
               ELSE CAST(CAST(sls.order_dt AS CHAR) AS DATE)
               END as order_dt,
           CASE
               WHEN sls.ship_dt = 0 OR length(sls.ship_dt) != 8 THEN NULL
               ELSE CAST(CAST(sls.ship_dt AS CHAR) AS DATE)
               END as ship_dt,
           CASE
               WHEN sls.due_dt = 0 OR length(sls.due_dt) != 8 THEN NULL
               ELSE CAST(CAST(sls.due_dt AS CHAR) AS DATE)
               END as due_dt,
           CASE
               WHEN sls.sales IS NULL OR sls.sales <= 0 OR sls.sales != sls.quantity * ABS(sls.price)
                   THEN sls.quantity * ABS(sls.price)
               ELSE sls.sales
               END as sales,
           quantity,
           CASE
               WHEN sls.price IS NULL OR sls.price <= 0
                   THEN sls.sales / NULLIF(sls.quantity, 0)
               ELSE sls.price
               END as price
    FROM bronze.src_crm_sales_details as sls;
    SET @end_time = now();
    SELECT CONCAT('Load Duration for crm_sales_details is ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' SECONDS');

    SELECT '============================================';
    SET @start_time = now();
    SELECT '>> Truncating table: erp_cust_az12';
    SELECT '>> Inserting data into table: erp_cust_az12';
    TRUNCATE `erp_cust_az12`;

    INSERT INTO `erp_cust_az12` (`id`, `birth_date`, `gender`)
    SELECT CASE
               WHEN cst.id LIKE 'NAS%' THEN substr(cst.id, 4, length(cst.id))
               ELSE cst.id
               END as cst_id,
           CASE
               WHEN cst.birth_date > current_date() THEN NULL
               ELSE cst.birth_date
               END as birth_date,
           CASE
               WHEN UPPER(TRIM(cst.gender)) IN ('M', 'Male') THEN 'Male'
               WHEN UPPER(TRIM(cst.gender)) IN ('F', 'Female') THEN 'Female'
               ELSE 'n/a'
               END as gender
    FROM bronze.src_erp_cust_az12 as cst;
    SET @end_time = now();
    SELECT CONCAT('Load Duration for erp_cust_az12 is ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' SECONDS');

    SELECT '============================================';
    SET @start_time = now();
    SELECT '>> Truncating table: erp_loc_a101';
    SELECT '>> Inserting data into table: erp_loc_a101';
    TRUNCATE `erp_loc_a101`;

    INSERT INTO `erp_loc_a101` (`cid`,
                                `country`)
    SELECT replace(cid, '-', '') as cid,
           CASE
               WHEN UPPER(TRIM(country)) = 'DE' THEN 'GERMANY'
               WHEN UPPER(TRIM(country)) IN ('US', 'USA') THEN 'United States'
               WHEN UPPER(TRIM(country)) = '' OR country IS NULL THEN 'n/a'
               ELSE TRIM(country)
               END               as country
    FROM bronze.src_erp_loc_a101;
    SET @end_time = now();
    SELECT CONCAT('Load Duration for erp_loc_a101 is ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' SECONDS');

    SELECT '============================================';
    SET @start_time = now();
    SELECT '>> Truncating table: erp_px_cat_g1v2';
    SELECT '>> Inserting data into table: erp_px_cat_g1v2';
    TRUNCATE `erp_px_cat_g1v2`;

    INSERT INTO `erp_px_cat_g1v2` (`id`, `category`, `sub_category`, `maintenance`)
    SELECT id,
           category,
           sub_category,
           maintenance
    FROM bronze.src_erp_px_cat_g1v2;
    SET @end_time = now();
    SELECT CONCAT('Load Duration for erp_px_cat_g1v2 is ', TIMESTAMPDIFF(SECOND, @start_time, @end_time), ' SECONDS');
    SET @batch_end_time = now();
    SELECT '============================================';
    SELECT CONCAT("Silver Loading Completed in : ", TIMESTAMPDIFF(SECOND, @batch_start_time, @batch_end_time), ' SECONDS');
    SELECT '============================================';
END $$

DELIMITER ;

CALL load_silver();
