SET FOREIGN_KEY_CHECKS=0;
SET names utf8;

CREATE DATABASE IF NOT EXISTS marketing;
USE marketing;

DROP PROCEDURE IF EXISTS CheckTableExist;
DROP PROCEDURE IF EXISTS CheckColumnExist;
DROP PROCEDURE IF EXISTS CheckIndexExist;
DROP PROCEDURE IF EXISTS CheckConstraintExist;
DROP PROCEDURE IF EXISTS CheckPrimaryKeyExist;
DROP PROCEDURE IF EXISTS CheckDataExist;
DROP PROCEDURE IF EXISTS AddNewTables;
DROP PROCEDURE IF EXISTS addNewColumn;

DELIMITER //
CREATE PROCEDURE CheckTableExist(IN p_tablename varchar(64), OUT ret int)
BEGIN
	SELECT p_tablename;
    SET ret = 0;
    SELECT COUNT(*) INTO @cnt FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = p_tablename AND TABLE_SCHEMA=database();
    IF @cnt >0 THEN
        SET ret = 1;
    END IF;
END//

DELIMITER //
CREATE PROCEDURE CheckColumnExist(IN p_tablename varchar(64), IN p_columnname varchar(64), OUT ret int)
BEGIN
	SELECT p_tablename;
    SET ret = 0;
    SELECT COUNT(*) INTO @cnt FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = p_tablename AND COLUMN_NAME = p_columnname AND TABLE_SCHEMA=database();
    IF @cnt >0 THEN
        SET ret = 1;
    END IF;
END//

DELIMITER //
CREATE PROCEDURE CheckIndexExist(IN p_tablename varchar(64), IN p_indexname varchar(64), OUT ret int)
BEGIN
	SELECT p_tablename;
    SET ret = 0;
    SELECT COUNT(*) INTO @cnt FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_NAME = p_tablename AND INDEX_NAME = p_indexname AND TABLE_SCHEMA=database();
    IF @cnt >0 THEN
        SET ret = 1;
    END IF;
END//

DELIMITER //
CREATE PROCEDURE CheckConstraintExist(IN p_tablename varchar(64), IN p_constraintname varchar(64), OUT ret int)
BEGIN
	SELECT p_tablename;
    SET ret = 0;
    SELECT COUNT(*) INTO @cnt FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME = p_tablename AND CONSTRAINT_NAME = p_constraintname AND TABLE_SCHEMA=database();
    IF @cnt >0 then
        SET ret = 1;
    END IF;
END//

DELIMITER //
CREATE PROCEDURE CheckDataExist(IN p_tablename varchar(64), IN str_condition varchar(64), OUT ret int)
BEGIN
	SELECT p_tablename;
	SET ret = 0;
	SET @STMT :=CONCAT("SELECT COUNT(*) INTO @cnt from  ", p_tablename, " where ", str_condition);
	PREPARE STMT FROM @STMT;
	EXECUTE STMT;
	IF @cnt >0 THEN
		SET ret = 1;
	END IF;
END//

DELIMITER //
CREATE PROCEDURE CheckPrimaryKeyExist(IN p_tablename varchar(64), OUT ret int)
BEGIN
	SELECT p_tablename;
	SET ret = 0;
	SELECT COUNT(*) INTO @cnt from INFORMATION_SCHEMA.KEY_COLUMN_USAGE where TABLE_NAME = p_tablename AND TABLE_SCHEMA=database();
	IF @cnt >0 then
    	SET ret = 1;
	END IF;
END//

DELIMITER //
CREATE PROCEDURE AddNewTables()
BEGIN
	SET @ret = 0;
	CALL CheckTableExist("project", @ret);
	IF @ret = 0 THEN
		CREATE TABLE IF NOT EXISTS `project` (
		  `id` varchar(40) NOT NULL,
		  `name` varchar(40) NOT NULL unique,
		  `address` varchar(255) NOT NULL,
	      `mobile` varchar(20) NOT NULL,
		  `contacts` varchar(128) NOT NULL,
		  `type` enum('free','paid','official') NOT NULL DEFAULT 'official',
		  `store_number` int(10) default NULL,
		  `call_number` int(10) default NULL,
		  `image_number` int(10) default NULL,
		  `threshhold` float(3,2) default NULL,
		  `create_time` datetime DEFAULT NULL,
		  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		  `status` enum('active','deleted','inactive') NOT NULL DEFAULT 'active',
		  PRIMARY KEY (`id`),
		  KEY `status_project_fk_idx` (`status`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		
		CREATE TABLE IF NOT EXISTS `store` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `code` varchar(40) NOT NULL,
		  `project_id` varchar(40) NOT NULL,
		  PRIMARY KEY (`id`),
		  KEY `code_store_fk_idx` (`code`),
		  KEY `project_store_fk_idx` (`project_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		
		CREATE TABLE IF NOT EXISTS `project_reminder_update` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `project_id` varchar(40) NOT NULL,
		  `reminder_day` date NOT NULL,
		  `flag` enum('0','1') NOT NULL DEFAULT '0',
		  PRIMARY KEY (`id`),
		  KEY `project_reminder_fk_idx` (`project_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		
	END IF;
END//

DELIMITER //
CREATE PROCEDURE addNewColumn()
BEGIN
	SET @ret = 0;
	CALL CheckColumnExist("admin_service_apply", "start_time", @ret);
	IF @ret = 0 THEN
		alter table `admin_service_apply` Add column `project_id` varchar(40) DEFAULT NULL AFTER `creator_id`;
		alter table `admin_service_apply` Add column `start_time` datetime DEFAULT NULL AFTER `project_id`;
		alter table `admin_service_apply` Add column `end_time` datetime DEFAULT NULL AFTER `start_time`;
		alter table `admin_service_apply` Add column `contracted_value` float DEFAULT NULL AFTER `end_time`;
		alter table `admin_service_apply` Add column `contracted_no`  varchar(20) DEFAULT NULL AFTER `contracted_value`;
		
		alter table `admin_service_apply` drop column `app_business_name`;
		alter table `admin_service_apply` drop column `app_business_address`;
		alter table `admin_service_apply` drop column `app_business_mobile`;
		alter table `admin_service_apply` drop column `app_business_contacts`;
		alter table `admin_service_apply` drop column `max_call_number`;
		
		alter table `task` Add column `project_id` varchar(40) DEFAULT NULL AFTER `user_id`;
		
		alter table `api_calling_count` Add column `project_id` varchar(40) DEFAULT NULL AFTER `user_name`;
		alter table `api_calling_count` Add column `store_code` varchar(40) DEFAULT NULL AFTER `project_id`;
		alter table `api_calling_count` Add column `major_type` varchar(20) DEFAULT NULL AFTER `store_code`;
		
		ALTER TABLE `admin_service_apply` ADD INDEX project_service_apply_fk_idx (`project_id`);
		
		ALTER TABLE `task` ADD INDEX project_task_fk_idx (`project_id`);
		
		ALTER TABLE `api_calling_count` ADD INDEX project_api_calling_fk_idx (`project_id`);
		ALTER TABLE `api_calling_count` ADD INDEX store_api_calling_fk_idx (`store_code`);
		ALTER TABLE `api_calling_count` ADD INDEX major_api_calling_fk_idx (`major_type`);
		
	END IF;
END//

DELIMITER ;
	
CALL AddNewTables();
CALL addNewColumn();

DROP PROCEDURE IF EXISTS CheckTableExist;
DROP PROCEDURE IF EXISTS CheckColumnExist;
DROP PROCEDURE IF EXISTS CheckIndexExist;
DROP PROCEDURE IF EXISTS CheckConstraintExist;
DROP PROCEDURE IF EXISTS CheckPrimaryKeyExist;
DROP PROCEDURE IF EXISTS CheckDataExist;
DROP PROCEDURE IF EXISTS AddNewTables;
DROP PROCEDURE IF EXISTS addNewColumn;
