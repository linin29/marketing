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
DROP PROCEDURE IF EXISTS InsertMajorTypeAndSkuTableData;

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
CREATE PROCEDURE InsertMajorTypeAndSkuTableData()
BEGIN
	SET @ret = 0;
	CALL CheckTableExist("major_type", @ret);
	IF @ret = 1 THEN 
		UPDATE `major_type` SET `version` = "5.0" where name = "nestlecoffee";
		UPDATE `major_type` SET `status` = "deleted" where name = "nestlemilk";
		UPDATE `major_type` SET `status` = "deleted" where name = "nestlemilkpowder";
		UPDATE `major_type` SET `status` = "deleted" where name = "nestleoatmeal";
		UPDATE `major_type` SET `status` = "deleted" where name = "nestlericeflour";
		UPDATE `major_type` SET `status` = "deleted" where name = "nestlesugar";
		UPDATE `major_type` SET `status` = "deleted" where name = "nestlebiscuit";
		
		INSERT INTO `major_type`(`name`, `description`,`version`, `create_time`) VALUES ('nestlenutrition', '雀巢营养品', '1.0', now());
		INSERT INTO `major_type`(`name`, `description`,`version`, `create_time`) VALUES ('nestleconfectionery', '雀巢糕点糖果', '1.0', now());
		INSERT INTO `major_type`(`name`, `description`,`version`, `create_time`) VALUES ('nestledairy', '雀巢奶制品', '1.0', now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric1', 'nric1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric2', 'nric2', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric3', 'nric3', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric4', 'nric4', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric5', 'nric5', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric6', 'nric6', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric7', 'nric7', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric8', 'nric8', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric9', 'nric9', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric10', 'nric10', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric11', 'nric11', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric12', 'nric12', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric13', 'nric13', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric14', 'nric14', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric15', 'nric15', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric16', 'nric16', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric17', 'nric17', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric18', 'nric18', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric19', 'nric19', 18, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric20', 'nric20', 19, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric21', 'nric21', 20, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric22', 'nric22', 21, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'nric23', 'nric23', 22, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'gerber1', 'gerber1', 23, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'gerber2', 'gerber2', 24, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'gerber3', 'gerber3', 25, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'gerber4', 'gerber4', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'gerber5', 'gerber5', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'gerber6', 'gerber6', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'gerber7', 'gerber7', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'gerber8', 'gerber8', 30, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'gerber9', 'gerber9', 31, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'gerber10', 'gerber10', 32, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'gerber11', 'gerber11', 33, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 45', 'Nestle 45', 34, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 46', 'Nestle 46', 35, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 47', 'Nestle 47', 36, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 48', 'Nestle 48', 37, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 49', 'Nestle 49', 38, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 50', 'Nestle 50', 39, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 51', 'Nestle 51', 40, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 52', 'Nestle 52', 41, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 53', 'Nestle 53', 42, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 54', 'Nestle 54', 43, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 55', 'Nestle 55', 44, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 56', 'Nestle 56', 45, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 57', 'Nestle 57', 46, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 58', 'Nestle 58', 47, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 59', 'Nestle 59', 48, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 60', 'Nestle 60', 49, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 61', 'Nestle 61', 50, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 62', 'Nestle 62', 51, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 63', 'Nestle 63', 52, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 64', 'Nestle 64', 53, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 65', 'Nestle 65', 54, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 66', 'Nestle 66', 55, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 67', 'Nestle 67', 56, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 68', 'Nestle 68', 57, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 69', 'Nestle 69', 58, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 70', 'Nestle 70', 59, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 71', 'Nestle 71', 60, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 72', 'Nestle 72', 61, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 73', 'Nestle 73', 62, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 74', 'Nestle 74', 63, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 75', 'Nestle 75', 64, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 76', 'Nestle 76', 65, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 77', 'Nestle 77', 66, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 78', 'Nestle 78', 67, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 79', 'Nestle 79', 68, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 80', 'Nestle 80', 69, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 81', 'Nestle 81', 70, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 82', 'Nestle 82', 71, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 83', 'Nestle 83', 72, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 84', 'Nestle 84', 73, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 85', 'Nestle 85', 74, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 86', 'Nestle 86', 75, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 87', 'Nestle 87', 76, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 88', 'Nestle 88', 77, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 89', 'Nestle 89', 78, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 90', 'Nestle 90', 79, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle 91', 'Nestle 91', 80, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs1', 'nccs1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs2', 'nccs2', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs3', 'nccs3', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs4', 'nccs4', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs5', 'nccs5', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs6', 'nccs6', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs7', 'nccs7', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs8', 'nccs8', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs9', 'nccs9', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs10', 'nccs10', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs11', 'nccs11', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs12', 'nccs12', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs13', 'nccs13', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs14', 'nccs14', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs15', 'nccs15', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs16', 'nccs16', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs17', 'nccs17', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs18', 'nccs18', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs19', 'nccs19', 18, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs20', 'nccs20', 19, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs21', 'nccs21', 20, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs22', 'nccs22', 21, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs23', 'nccs23', 22, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs24', 'nccs24', 23, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs25', 'nccs25', 24, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs26', 'nccs26', 25, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nccs27', 'nccs27', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'youcui1', 'youcui1', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'youcui2', 'youcui2', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'youcui3', 'youcui3', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'youcui4', 'youcui4', 30, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg1', 'nqmg1', 31, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg2', 'nqmg2', 32, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg3', 'nqmg3', 33, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg4', 'nqmg4', 34, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg5', 'nqmg5', 35, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg6', 'nqmg6', 36, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg7', 'nqmg7', 37, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg8', 'nqmg8', 38, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg9', 'nqmg9', 39, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg10', 'nqmg10', 40, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg11', 'nqmg11', 41, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg12', 'nqmg12', 42, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg13', 'nqmg13', 43, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg1box', 'nqmg1box', 44, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg2box', 'nqmg2box', 45, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg3box', 'nqmg3box', 46, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg4box', 'nqmg4box', 47, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg5box', 'nqmg5box', 48, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleconfectionery', 'nqmg6box', 'nqmg6box', 49, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor1', 'ncor1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor2', 'ncor2', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor3', 'ncor3', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor4', 'ncor4', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor5', 'ncor5', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor6', 'ncor6', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor7', 'ncor7', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor8', 'ncor8', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor9', 'ncor9', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor10', 'ncor10', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor11', 'ncor11', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor12', 'ncor12', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor13', 'ncor13', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor14', 'ncor14', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor15', 'ncor15', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor16', 'ncor16', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor17', 'ncor17', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor18', 'ncor18', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncor19', 'ncor19', 18, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncon1', 'ncon1', 19, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncon2', 'ncon2', 20, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncon3', 'ncon3', 21, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncon4', 'ncon4', 22, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncon5', 'ncon5', 23, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncon6', 'ncon6', 24, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncon7', 'ncon7', 25, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'ncon8', 'ncon8', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 1', 'Nestle 1', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 21', 'Nestle 21', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 2', 'Nestle 2', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 22', 'Nestle 22', 30, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 3', 'Nestle 3', 31, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 23', 'Nestle 23', 32, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 4', 'Nestle 4', 33, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 24', 'Nestle 24', 34, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 5', 'Nestle 5', 35, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 25', 'Nestle 25', 36, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 6', 'Nestle 6', 37, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 26', 'Nestle 26', 38, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 7', 'Nestle 7', 39, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 27', 'Nestle 27', 40, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 8', 'Nestle 8', 41, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 28', 'Nestle 28', 42, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 9', 'Nestle 9', 43, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 29', 'Nestle 29', 44, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 10', 'Nestle 10', 45, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 30', 'Nestle 30', 46, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 11', 'Nestle 11', 47, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 31', 'Nestle 31', 48, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 35', 'Nestle 35', 49, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 36', 'Nestle 36', 50, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 12', 'Nestle 12', 51, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 32', 'Nestle 32', 52, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 13', 'Nestle 13', 53, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 33', 'Nestle 33', 54, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 14', 'Nestle 14', 55, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 34', 'Nestle 34', 56, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 15', 'Nestle 15', 57, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 16', 'Nestle 16', 58, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 17', 'Nestle 17', 59, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 18', 'Nestle 18', 60, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 19', 'Nestle 19', 61, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 20', 'Nestle 20', 62, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 37', 'Nestle 37', 63, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 38', 'Nestle 38', 64, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 39', 'Nestle 39', 65, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 40', 'Nestle 40', 66, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 41', 'Nestle 41', 67, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 42', 'Nestle 42', 68, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 43', 'Nestle 43', 69, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 44', 'Nestle 44', 70, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 92', 'Nestle 92', 71, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 93', 'Nestle 93', 72, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 94', 'Nestle 94', 73, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 95', 'Nestle 95', 74, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 96', 'Nestle 96', 75, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 97', 'Nestle 97', 76, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle 98', 'Nestle 98', 77, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (17, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (17, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (17, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (18, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (18, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (18, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (19, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (19, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (19, 3, now());
	END IF;
END//

DELIMITER ;
	
CALL InsertMajorTypeAndSkuTableData();

DROP PROCEDURE IF EXISTS CheckTableExist;
DROP PROCEDURE IF EXISTS CheckColumnExist;
DROP PROCEDURE IF EXISTS CheckIndexExist;
DROP PROCEDURE IF EXISTS CheckConstraintExist;
DROP PROCEDURE IF EXISTS CheckPrimaryKeyExist;
DROP PROCEDURE IF EXISTS CheckDataExist;
DROP PROCEDURE IF EXISTS InsertMajorTypeAndSkuTableData;
