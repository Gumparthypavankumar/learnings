CREATE TABLE IF NOT EXISTS `crm_sales_details`
(
    `ord_num`          VARCHAR(50),
    `prd_key`          VARCHAR(50),
    `cust_id`          INT,
    `order_dt`         DATE,
    `ship_dt`          DATE,
    `due_dt`           DATE,
    `sales`            INT,
    `quantity`         INT,
    `price`            INT,
    `dwh_created_date` DATETIME DEFAULT CURRENT_TIMESTAMP()
);
