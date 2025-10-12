CREATE TABLE IF NOT EXISTS `erp_cust_az12`
(
     `id`               VARCHAR(50),
     `birth_date`       DATE,
     `gender`           VARCHAR(50),
     `dwh_created_date` DATETIME DEFAULT CURRENT_TIMESTAMP()
);
