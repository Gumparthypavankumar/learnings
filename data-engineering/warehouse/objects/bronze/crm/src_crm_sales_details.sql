CREATE TABLE IF NOT EXISTS `src_crm_sales_details`
(
     `ord_num`  VARCHAR(50),
     `prd_key`  VARCHAR(50),
     `cust_id`  INT,
     `order_dt` INT,
     `ship_dt`  INT,
     `due_dt`   INT,
     `sales`    INT,
     `quantity` INT,
     `price`    INT
);
