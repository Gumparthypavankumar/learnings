# Data Warehouse and Analytics Project

## The project is a motivation from [Data with Barra](https://www.youtube.com/watch?v=9GVqKuTVANE&list=PLNcg_FV9n7qaUWeyUkPfiVtMbKlrfMqA8)

This project demonstrates a comprehensive data warehousing solution. Tt highlights industry best practices in data engineering and analytics

## 🏗️ Data Architecture

The data architecture for this project follows [Medallion Architecture](https://www.databricks.com/glossary/medallion-architecture):

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into MySQL Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

---

## 📖Project Overview

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

🎯 This repository is a shared resource built for MySQL which was originally only supporting Microsoft SQL server

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using MySQL to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

## 📂 Repository Structure
```
data-warehouse-project/
├
├── datasets                            # Raw datasets used for the project (ERP and CRM data)
│ ├── source_crm
│ └── source_erp
├── objects                             # The SQL Tables (DDL)
│ └── bronze
│     ├── ...
│     └── init.sql
│ └── silver
│     ├── ...
│     └── init.sql
│ └── gold
│     ├── ...
│     └── init.sql
├── static                              # The DML Scripts
│ └── bronze
│ └── silver
│ └── gold
├── README.md                           # Project Overview
├── .gitignore                          # Files and directories to be ignored by Git
├── create_db.lst                       # The file descriptor that lists all the objects, static scripts to be included in final script
├── create_db.sh                        # The script that merges all the sql files and create a single executable script
└── schema.sql                          # The Database Schema Files
```

## PreRequisites
1. [MySQL](https://dev.mysql.com/downloads/)
2. Configure MySQL server to allow `secure_file_priv` to execute the `LOAD DATA` command

```shell
cat <<EOF > /etc/mysql/my.cnf
# In your /etc/mysql/my.cnf input following
[mysqld]
secure_file_priv=/var/lib/mysql-files/
EOF
sudo systemctl restart mysql # Or equivalent
```

## Setting up Locally
```shell
sh ./create_db.sh
mysql -h <hostname> -u <user> --password=<password> < core_data_final.sql
```
---

## Credits
This project is driven in motivation to learn data warehousing from [Data with Barra](https://www.youtube.com/watch?v=9GVqKuTVANE&list=PLNcg_FV9n7qaUWeyUkPfiVtMbKlrfMqA8) 