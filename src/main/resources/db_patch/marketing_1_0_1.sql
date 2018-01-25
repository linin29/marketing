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
		
INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`) VALUES ('nestle4goods', '雀巢', '1.0', now());

INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs1', 'nccs1', 0, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs2', 'nccs2', 1, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs3', 'nccs3', 2, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs4', 'nccs4', 3, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs5', 'nccs5', 4, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs6', 'nccs6', 5, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs7', 'nccs7', 6, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs8', 'nccs8', 7, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs9', 'nccs9', 8, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs10', 'nccs10', 9, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs11', 'nccs11', 10, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs12', 'nccs12', 11, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs13', 'nccs13', 12, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs14', 'nccs14', 13, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs15', 'nccs15', 14, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs16', 'nccs16', 15, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs17', 'nccs17', 16, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs18', 'nccs18', 17, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs19', 'nccs19', 18, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs20', 'nccs20', 19, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs21', 'nccs21', 20, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs22', 'nccs22', 21, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs23', 'nccs23', 22, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs24', 'nccs24', 23, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs25', 'nccs25', 24, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs26', 'nccs26', 25, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs27', 'nccs27', 26, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'youcui1', 'youcui1', 27, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'youcui2', 'youcui2', 28, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'youcui3', 'youcui3', 29, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'youcui4', 'youcui4', 30, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco1', 'nco1', 31, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco2', 'nco2', 32, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco3', 'nco3', 33, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco4', 'nco4', 34, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco5', 'nco5', 35, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco6', 'nco6', 36, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco7', 'nco7', 37, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco8', 'nco8', 38, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco9', 'nco9', 39, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco10', 'nco10', 40, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco11', 'nco11', 41, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco12', 'nco12', 42, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco13', 'nco13', 43, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco14', 'nco14', 44, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco15', 'nco15', 45, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco16', 'nco16', 46, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco17', 'nco17', 47, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco18', 'nco18', 48, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco19', 'nco19', 49, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco20', 'nco20', 50, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco21', 'nco21', 51, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco22', 'nco22', 52, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco23', 'nco23', 53, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco24', 'nco24', 54, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco25', 'nco25', 55, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco26', 'nco26', 56, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco27', 'nco27', 57, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco28', 'nco28', 58, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco29', 'nco29', 59, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco30', 'nco30', 60, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco31', 'nco31', 61, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco32', 'nco32', 62, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco33', 'nco33', 63, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco34', 'nco34', 64, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco35', 'nco35', 65, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco36', 'nco36', 66, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco37', 'nco37', 67, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco38', 'nco38', 68, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco39', 'nco39', 69, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco40', 'nco40', 70, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco41', 'nco41', 71, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco42', 'nco42', 72, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco43', 'nco43', 73, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco44', 'nco44', 74, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco45', 'nco45', 75, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco46', 'nco46', 76, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco47', 'nco47', 77, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco48', 'nco48', 78, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco49', 'nco49', 79, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco50', 'nco50', 80, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco51', 'nco51', 81, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco52', 'nco52', 82, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco53', 'nco53', 83, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco54', 'nco54', 84, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco55', 'nco55', 85, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco56', 'nco56', 86, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco57', 'nco57', 87, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco58', 'nco58', 88, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco59', 'nco59', 89, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco60', 'nco60', 90, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco61', 'nco61', 91, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco62', 'nco62', 92, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco63', 'nco63', 93, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco64', 'nco64', 94, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco65', 'nco65', 95, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco66', 'nco66', 96, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco67', 'nco67', 97, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco68', 'nco68', 98, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco69', 'nco69', 99, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco70', 'nco70', 100, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco71', 'nco71', 101, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco72', 'nco72', 102, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco73', 'nco73', 103, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco74', 'nco74', 104, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco75', 'nco75', 105, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco76', 'nco76', 106, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco77', 'nco77', 107, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco78', 'nco78', 108, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco79', 'nco79', 109, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco80', 'nco80', 110, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco81', 'nco81', 111, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco82', 'nco82', 112, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco83', 'nco83', 113, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco84', 'nco84', 114, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon1', 'ncon1', 115, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon2', 'ncon2', 116, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon3', 'ncon3', 117, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon4', 'ncon4', 118, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon5', 'ncon5', 119, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon6', 'ncon6', 120, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon7', 'ncon7', 121, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon8', 'ncon8', 122, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor1', 'ncor1', 123, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor2', 'ncor2', 124, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor3', 'ncor3', 125, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor4', 'ncor4', 126, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor5', 'ncor5', 127, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor6', 'ncor6', 128, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor7', 'ncor7', 129, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor8', 'ncor8', 130, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor9', 'ncor9', 131, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor10', 'ncor10', 132, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor11', 'ncor11', 133, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor12', 'ncor12', 134, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor13', 'ncor13', 135, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor14', 'ncor14', 136, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor15', 'ncor15', 137, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor16', 'ncor16', 138, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor17', 'ncor17', 139, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor18', 'ncor18', 140, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor19', 'ncor19', 141, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric1', 'nric1', 142, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric2', 'nric2', 143, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric3', 'nric3', 144, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric4', 'nric4', 145, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric5', 'nric5', 146, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric6', 'nric6', 147, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric7', 'nric7', 148, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric8', 'nric8', 149, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric9', 'nric9', 150, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric10', 'nric10', 151, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric11', 'nric11', 152, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric12', 'nric12', 153, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric13', 'nric13', 154, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric14', 'nric14', 155, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric15', 'nric15', 156, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric16', 'nric16', 157, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric17', 'nric17', 158, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric18', 'nric18', 159, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric19', 'nric19', 160, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric20', 'nric20', 161, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric21', 'nric21', 162, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric22', 'nric22', 163, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric23', 'nric23', 164, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber1', 'gerber1', 165, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber2', 'gerber2', 166, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber3', 'gerber3', 167, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber4', 'gerber4', 168, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber5', 'gerber5', 169, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber6', 'gerber6', 170, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber7', 'gerber7', 171, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber8', 'gerber8', 172, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber9', 'gerber9', 173, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber10', 'gerber10', 174, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber11', 'gerber11', 175, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 1', 'Nestle 1', 176, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 2', 'Nestle 2', 177, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 3', 'Nestle 3', 178, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 4', 'Nestle 4', 179, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 5', 'Nestle 5', 180, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 6', 'Nestle 6', 181, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 7', 'Nestle 7', 182, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 8', 'Nestle 8', 183, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 9', 'Nestle 9', 184, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 10', 'Nestle 10', 185, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 11', 'Nestle 11', 186, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 12', 'Nestle 12', 187, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 13', 'Nestle 13', 188, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 14', 'Nestle 14', 189, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 15', 'Nestle 15', 190, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 16', 'Nestle 16', 191, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 17', 'Nestle 17', 192, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 18', 'Nestle 18', 193, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 19', 'Nestle 19', 194, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 20', 'Nestle 20', 195, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 21', 'Nestle 21', 196, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 22', 'Nestle 22', 197, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 23', 'Nestle 23', 198, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 24', 'Nestle 24', 199, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 25', 'Nestle 25', 200, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 26', 'Nestle 26', 201, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 27', 'Nestle 27', 202, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 28', 'Nestle 28', 203, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 29', 'Nestle 29', 204, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 30', 'Nestle 30', 205, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 31', 'Nestle 31', 206, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 32', 'Nestle 32', 207, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 33', 'Nestle 33', 208, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 34', 'Nestle 34', 209, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 35', 'Nestle 35', 210, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 36', 'Nestle 36', 211, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 37', 'Nestle 37', 212, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 38', 'Nestle 38', 213, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 39', 'Nestle 39', 214, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 40', 'Nestle 40', 215, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 41', 'Nestle 41', 216, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 42', 'Nestle 42', 217, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 43', 'Nestle 43', 218, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 44', 'Nestle 44', 219, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 45', 'Nestle 45', 220, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 46', 'Nestle 46', 221, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 47', 'Nestle 47', 222, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 48', 'Nestle 48', 223, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 49', 'Nestle 49', 224, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 50', 'Nestle 50', 225, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 51', 'Nestle 51', 226, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 52', 'Nestle 52', 227, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 53', 'Nestle 53', 228, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 54', 'Nestle 54', 229, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 55', 'Nestle 55', 230, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 56', 'Nestle 56', 231, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 57', 'Nestle 57', 232, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 58', 'Nestle 58', 233, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 59', 'Nestle 59', 234, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 60', 'Nestle 60', 235, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 61', 'Nestle 61', 236, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 62', 'Nestle 62', 237, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 63', 'Nestle 63', 238, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 64', 'Nestle 64', 239, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 65', 'Nestle 65', 240, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 66', 'Nestle 66', 241, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 67', 'Nestle 67', 242, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 68', 'Nestle 68', 243, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 69', 'Nestle 69', 244, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 70', 'Nestle 70', 245, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 71', 'Nestle 71', 246, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 72', 'Nestle 72', 247, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 73', 'Nestle 73', 248, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 74', 'Nestle 74', 249, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 75', 'Nestle 75', 250, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 76', 'Nestle 76', 251, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 77', 'Nestle 77', 252, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 78', 'Nestle 78', 253, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 79', 'Nestle 79', 254, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 80', 'Nestle 80', 255, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 81', 'Nestle 81', 256, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 82', 'Nestle 82', 257, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 83', 'Nestle 83', 258, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 84', 'Nestle 84', 259, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 85', 'Nestle 85', 260, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 86', 'Nestle 86', 261, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 87', 'Nestle 87', 262, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 88', 'Nestle 88', 263, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 89', 'Nestle 89', 264, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 90', 'Nestle 90', 265, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 91', 'Nestle 91', 266, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 92', 'Nestle 92', 267, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 93', 'Nestle 93', 268, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 94', 'Nestle 94', 269, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 95', 'Nestle 95', 270, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 96', 'Nestle 96', 271, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 97', 'Nestle 97', 272, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle 98', 'Nestle 98', 273, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg1', 'nqmg1', 274, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg2', 'nqmg2', 275, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg3', 'nqmg3', 276, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg4', 'nqmg4', 277, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg5', 'nqmg5', 278, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg6', 'nqmg6', 279, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg7', 'nqmg7', 280, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg8', 'nqmg8', 281, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg9', 'nqmg9', 282, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg10', 'nqmg10', 283, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg11', 'nqmg11', 284, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg12', 'nqmg12', 285, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg13', 'nqmg13', 286, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg1box', 'nqmg1box', 287, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg2box', 'nqmg2box', 288, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg3box', 'nqmg3box', 289, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg4box', 'nqmg4box', 290, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg5box', 'nqmg5box', 291, now());
INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg6box', 'nqmg6box', 292, now());

INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (21, 1, now());
INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (21, 2, now());
INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (21, 3, now());
	END IF;
END//

DELIMITER ;
	
CALL UpdateMajorTypeAndSkuTableData();

DROP PROCEDURE IF EXISTS CheckTableExist;
DROP PROCEDURE IF EXISTS CheckColumnExist;
DROP PROCEDURE IF EXISTS CheckIndexExist;
DROP PROCEDURE IF EXISTS CheckConstraintExist;
DROP PROCEDURE IF EXISTS CheckPrimaryKeyExist;
DROP PROCEDURE IF EXISTS CheckDataExist;
DROP PROCEDURE IF EXISTS UpdateMajorTypeAndSkuTableData;
