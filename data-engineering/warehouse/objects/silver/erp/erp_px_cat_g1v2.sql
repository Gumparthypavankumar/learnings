CREATE TABLE IF NOT EXISTS `erp_px_cat_g1v2`
(
     `id`               VARCHAR(50),
     `category`         VARCHAR(50),
     `sub_category`     VARCHAR(50),
     `maintenance`      VARCHAR(50),
     `dwh_created_date` DATETIME DEFAULT CURRENT_TIMESTAMP()
);
