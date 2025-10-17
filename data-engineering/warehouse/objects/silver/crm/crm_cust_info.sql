CREATE TABLE IF NOT EXISTS `crm_cust_info`
(
    `id`               INT,
    `key`              VARCHAR(50),
    `firstname`        VARCHAR(50),
    `lastname`         VARCHAR(50),
    `marital_status`   VARCHAR(50),
    `gender`           VARCHAR(50),
    `created_date`     DATE,
    `dwh_created_date` DATETIME DEFAULT CURRENT_TIMESTAMP()
);
