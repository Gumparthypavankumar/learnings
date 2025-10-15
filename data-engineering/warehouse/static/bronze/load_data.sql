/*
Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This script loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `LOAD DATA INFILE` command to load data from csv Files to bronze tables.

WARNING:
    You must enable `secure_file_priv` and ensure the user has the
    `FILE` privilege for this to work.

Notes:
    This script does not use stored procedure, as MySQL does not allow `LOAD DATA INFILE` inside a stored procedure(Error 1314).
    https://dev.mysql.com/doc/refman/8.4/en/stored-program-restrictions.html
*/

-- BEGIN OF BATCH

SET @batch_time_start = NOW();
SELECT "============================================" AS message;
SELECT "Bronze Batch Loading Begin" AS message;
SELECT "============================================" AS message;

SET @start_time = NOW();
SELECT ">> Truncating table: src_crm_cust_info" AS message;

TRUNCATE TABLE `src_crm_cust_info`;
SELECT ">> Inserting data into table: src_crm_cust_info" AS message;
LOAD DATA INFILE '/var/lib/mysql-files/source_crm/cust_info.csv' INTO TABLE `src_crm_cust_info`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@id, `key`, `firstname`, `lastname`, `marital_status`, `gender`, @temp_date) -- Map date field to a variable
SET id = IF(@id = '', NULL, @id),
    created_date = IF(@temp_date = '' OR @temp_date = '0000-00-00', NULL, @temp_date);

SET @end_time = NOW();
SELECT CONCAT("Load Duration for src_crm_cust_info is ", TIMESTAMPDIFF(SECOND, @start_time, @end_time), " seconds") AS message;

SELECT "============================================" AS message;
SET @start_time = NOW();
SELECT ">> Truncating table: src_crm_prd_info" AS message;

TRUNCATE TABLE `src_crm_prd_info`;
SELECT ">> Inserting data into table: src_crm_prd_info" AS message;
LOAD DATA INFILE '/var/lib/mysql-files/source_crm/prd_info.csv' INTO TABLE `src_crm_prd_info`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SET @end_time = NOW();
SELECT CONCAT("Load Duration for src_crm_prd_info is ", TIMESTAMPDIFF(SECOND, @start_time, @end_time), " seconds") AS message;

SELECT "============================================" AS message;
SET @start_time = NOW();
SELECT ">> Truncating table: src_crm_sales_details" AS message;

TRUNCATE TABLE `src_crm_sales_details`;
SELECT ">> Inserting data into table: src_crm_sales_details" AS message;
LOAD DATA INFILE '/var/lib/mysql-files/source_crm/sales_details.csv' INTO TABLE `src_crm_sales_details`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ord_num, prd_key, cust_id, order_dt, ship_dt, due_dt, @sales, quantity, @price)
SET sales = IF(@sales = '', 0, @sales),
    price = IF(@price = '', 0, @price)
;

SET @end_time = NOW();
SELECT CONCAT("Load Duration for src_crm_sales_details is ", TIMESTAMPDIFF(SECOND, @start_time, @end_time), " seconds") AS message;

SELECT "============================================" AS message;
SET @start_time = NOW();
SELECT ">> Truncating table: src_erp_cust_az12" AS message;

TRUNCATE TABLE `src_erp_cust_az12`;
SELECT ">> Inserting data into table: src_erp_cust_az12" AS message;
LOAD DATA INFILE '/var/lib/mysql-files/source_erp/CUST_AZ12.csv' INTO TABLE `src_erp_cust_az12`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(id, birth_date, @gender)
SET gender = IF(@gender = '', '', @gender)
;

SET @end_time = NOW();
SELECT CONCAT("Load Duration for src_erp_cust_az12 is ", TIMESTAMPDIFF(SECOND, @start_time, @end_time), " seconds") AS message;

SELECT "============================================" AS message;
SET @start_time = NOW();
SELECT ">> Truncating table: src_erp_loc_a101" AS message;

TRUNCATE TABLE `src_erp_loc_a101`;
SELECT ">> Inserting data into table: src_erp_loc_a101" AS message;
LOAD DATA INFILE '/var/lib/mysql-files/source_erp/LOC_A101.csv' INTO TABLE `src_erp_loc_a101`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SET @end_time = NOW();
SELECT CONCAT("Load Duration for src_erp_loc_a101 is ", TIMESTAMPDIFF(SECOND, @start_time, @end_time), " seconds") AS message;

SELECT "============================================" AS message;
SET @start_time = NOW();
SELECT ">> Truncating table: src_erp_px_cat_g1v2" AS message;

TRUNCATE TABLE `src_erp_px_cat_g1v2`;
SELECT ">> Inserting data into table: src_erp_px_cat_g1v2" AS message;
LOAD DATA INFILE '/var/lib/mysql-files/source_erp/PX_CAT_G1V2.csv' INTO TABLE `src_erp_px_cat_g1v2`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SET @end_time = NOW();
SELECT CONCAT("Load Duration for src_erp_px_cat_g1v2 is ", TIMESTAMPDIFF(SECOND, @start_time, @end_time), " seconds") AS message;

-- END OF BATCH
SET @batch_time_end = NOW();
SELECT "============================================" AS message;
SELECT CONCAT("Bronze Loading Completed in: ", TIMESTAMPDIFF(SECOND, @batch_time_start, @batch_time_end), ' seconds') AS message;
SELECT "============================================" AS message;
