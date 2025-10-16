CREATE TABLE IF NOT EXISTS `crm_prd_info`
(
     `id`               INT,
     `key`              VARCHAR(50),
     /* Derived Columns */
     `category_id`      VARCHAR(50), -- References erp_px_cat_g1v2
     `product_key`      VARCHAR(50), -- References sales_details
     `nm`               VARCHAR(50),
     `cost`             VARCHAR(50),
     `line`             VARCHAR(50),
     `start_date`       VARCHAR(50),
     `end_date`         VARCHAR(50),
     `dwh_created_date` DATETIME DEFAULT CURRENT_TIMESTAMP()
);
