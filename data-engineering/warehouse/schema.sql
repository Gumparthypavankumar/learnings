/*
==============================================================
Create Schemas
==============================================================
Script Purpose:
    This script recreates the schemas 'bronze', 'silver', 'gold' representing three layers in our data warehouse architecture of medallion architecture.

WARNING:
    Running this script will drop the entire schemas if exists.
    All data in the schemas will be permanently deleted. Proceed with caution and ensure you have proper backups before running this script
*/

DROP SCHEMA IF EXISTS `bronze`;
DROP SCHEMA IF EXISTS `silver`;
DROP SCHEMA IF EXISTS `gold`;

CREATE SCHEMA `bronze`;
CREATE SCHEMA `silver`;
CREATE SCHEMA `gold`;

