/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/
SELECT "============================================";
SELECT "Gold Layer Processing Begin";
SELECT "============================================";
SET @start_batch_time = NOW();
-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
SELECT ">> Dropping view: dim_customers";
DROP VIEW IF EXISTS `dim_customers`;
SELECT ">> Creating view: dim_customers";
CREATE VIEW `dim_customers` AS
SELECT row_number() over (order by cst.id) as customer_key,
       cst.id                              as customer_id,
       cst.key                             as customer_number,
       cst.firstname                       as first_name,
       cst.lastname                        as last_name,
       la.country                          as country,
       cst.marital_status                  as marital_status,
       CASE
           WHEN cst.gender != 'n/a' THEN cst.gender
           ELSE COALESCE(ca.gender, 'n/a')
           END                             AS gender,
       ca.birth_date                       as birth_date,
       cst.created_date                    as created_date
FROM silver.crm_cust_info as cst
         LEFT JOIN silver.erp_cust_az12 as ca
                   ON cst.key = ca.id
         LEFT JOIN silver.erp_loc_a101 as la
                   ON cst.key = la.cid
;
SELECT "============================================";

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
SELECT ">> Dropping view: dim_products";
DROP VIEW IF EXISTS `dim_products`;
SELECT ">> Creating view: dim_products";
CREATE VIEW `dim_products` AS
SELECT row_number() over (order by prd.start_date, prd.product_key) as product_key,
       prd.id                                                       AS product_id,
       prd.product_key                                              AS product_number,
       prd.nm                                                       AS product_name,
       prd.category_id                                              AS category_id,
       pc.category                                                  AS category,
       pc.sub_category                                              AS subcategory,
       pc.maintenance                                               AS maintenance,
       prd.cost                                                     AS cost,
       prd.line                                                     AS product_line,
       prd.start_date                                               AS start_date
FROM silver.crm_prd_info as prd
         LEFT JOIN silver.erp_px_cat_g1v2 as pc
                   ON pc.id = prd.category_id
WHERE prd.end_date IS NULL -- Filter out all historical data
;
SELECT "============================================";

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
SELECT ">> Dropping view: fact_sales";
DROP VIEW IF EXISTS `fact_sales`;
SELECT ">> Creating view: fact_sales";
CREATE VIEW `fact_sales` AS
SELECT sls.ord_num      as order_number,
       prd.product_key  as product_key,
       cst.customer_key as customer_key,
       sls.order_dt     AS order_date,
       sls.ship_dt      AS shipping_date,
       sls.due_dt       AS due_date,
       sls.sales        AS sales_amount,
       sls.quantity     AS quantity,
       sls.price        AS price
FROM silver.crm_sales_details as sls
         LEFT JOIN gold.dim_products as prd
                   ON sls.prd_key = prd.product_number
         LEFT JOIN gold.dim_customers as cst
                   ON sls.cust_id = cst.customer_id
;
SET @batch_end_time = NOW();
SELECT "============================================";
SELECT CONCAT("Gold Layer Completed in ", TIMESTAMPDIFF(SECOND, @start_batch_time, @batch_end_time), " seconds");
SELECT "============================================";