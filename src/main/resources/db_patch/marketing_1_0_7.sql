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
DROP PROCEDURE IF EXISTS UpdateMajorTypeAndSkuTableData;
DROP PROCEDURE IF EXISTS CreateTrainingTable;

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
CREATE PROCEDURE UpdateMajorTypeAndSkuTableData()
BEGIN
	SET @ret = 0;
	CALL CheckTableExist("major_type", @ret);
	IF @ret = 1 THEN 
		UPDATE `major_type` SET `version` = "4.0" where name = "nestlemilk";
		UPDATE `major_type` SET `version` = "5.0" where name = "nestlecoffee";
		UPDATE `major_type` SET `version` = "5.0" where name = "nestlemilkpowder";
		UPDATE `major_type` SET `version` = "4.0" where name = "nestleoatmeal";
		UPDATE `major_type` SET `version` = "4.0" where name = "nestlericeflour";
		UPDATE `major_type` SET `version` = "4.0" where name = "nestlesugar";
		UPDATE `major_type` SET `version` = "4.0" where name = "nestlebiscuit";
		
		UPDATE `goods_sku` SET `order` = 13 where major_type = "nestlesugar" and `name` = "nqmg1box";
		UPDATE `goods_sku` SET `order` = 14 where major_type = "nestlesugar" and `name` = "nqmg2box";
		UPDATE `goods_sku` SET `order` = 15 where major_type = "nestlesugar" and `name` = "nqmg3box";
		UPDATE `goods_sku` SET `order` = 16 where major_type = "nestlesugar" and `name` = "nqmg4box";
		UPDATE `goods_sku` SET `order` = 17 where major_type = "nestlesugar" and `name` = "nqmg5box";
		UPDATE `goods_sku` SET `order` = 18 where major_type = "nestlesugar" and `name` = "nqmg6box";
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 97', 'Nestle 97', 96, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 98', 'Nestle 98', 97, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg13', 'nqmg13', 12, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco79', 'nco79', 78, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco80', 'nco80', 79, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco81', 'nco81', 80, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco82', 'nco82', 81, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco83', 'nco83', 82, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco84', 'nco84', 83, now());
		
		INSERT INTO `privilege`(`parent_id`, `item_name`, `item_value`, `description`, `display_order`, `create_time`) VALUES (NULL, '文件上传', '/fileUpload', '文件上传一级菜单', 5, now());
		INSERT INTO `role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (5, 1, 5, now());
		
		INSERT INTO `role`(`name`, `description`, `create_time`) VALUES ('user', '普通用户', now());
		
		INSERT INTO `role_privilege_mapping`(`role_id`, `privilege_id`, `create_time`) VALUES (2, 1, now());
        INSERT INTO `role_privilege_mapping`(`role_id`, `privilege_id`, `create_time`) VALUES (2, 2, now());
        INSERT INTO `role_privilege_mapping`(`role_id`, `privilege_id`, `create_time`) VALUES (2, 3, now());
	END IF;
END//

DELIMITER //
CREATE PROCEDURE CreateTrainingTable()
BEGIN
	SET @ret = 0;
	CALL CheckTableExist("training_data", @ret);
	IF @ret = 0 THEN
		CREATE TABLE IF NOT EXISTS `training_data` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `major_type` varchar(50) NOT NULL,
		  `image_path` varchar(256) NOT NULL,
		  `file_path` varchar(256) NOT NULL,
		  `flag` tinyint NOT NULL DEFAULT 0,
		  PRIMARY KEY (`id`),
		  KEY `major_type_training_data_idx` (`major_type`),
		  KEY `flag_training_data_idx` (`flag`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		
		CREATE TABLE IF NOT EXISTS `training_statistics` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `major_type` varchar(50) NOT NULL,
		  `count` int(11) DEFAULT 0,
		  PRIMARY KEY (`id`),
		  KEY `major_type_training_statistics_idx` (`major_type`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	END IF;
END//

DELIMITER ;
	
CALL UpdateMajorTypeAndSkuTableData();
CALL CreateTrainingTable();

DROP PROCEDURE IF EXISTS CheckTableExist;
DROP PROCEDURE IF EXISTS CheckColumnExist;
DROP PROCEDURE IF EXISTS CheckIndexExist;
DROP PROCEDURE IF EXISTS CheckConstraintExist;
DROP PROCEDURE IF EXISTS CheckPrimaryKeyExist;
DROP PROCEDURE IF EXISTS CheckDataExist;
DROP PROCEDURE IF EXISTS UpdateMajorTypeAndSkuTableData;
DROP PROCEDURE IF EXISTS CreateTrainingTable;
