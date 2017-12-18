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
		UPDATE `major_type` SET `status` = "deleted" where name = "nestlecoffee";
		UPDATE `major_type` SET `status` = "deleted" where name = "nestlenutrition";
		UPDATE `major_type` SET `status` = "deleted" where name = "nestleconfectionery";
		UPDATE `major_type` SET `status` = "deleted" where name = "nestledairy";
		
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`) VALUES ('nestle4goods', '雀巢', '1.0', now());

		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor1', 'ncor1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor2', 'ncor2', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor3', 'ncor3', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor4', 'ncor4', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor5', 'ncor5', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor6', 'ncor6', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor7', 'ncor7', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor8', 'ncor8', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor9', 'ncor9', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor10', 'ncor10', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor11', 'ncor11', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor12', 'ncor12', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor13', 'ncor13', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor14', 'ncor14', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor15', 'ncor15', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor16', 'ncor16', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor17', 'ncor17', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor18', 'ncor18', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncor19', 'ncor19', 18, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon1', 'ncon1', 19, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon2', 'ncon2', 20, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon3', 'ncon3', 21, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon4', 'ncon4', 22, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon5', 'ncon5', 23, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon6', 'ncon6', 24, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon7', 'ncon7', 25, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'ncon8', 'ncon8', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle1', 'Nestle1', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle21', 'Nestle21', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle2', 'Nestle2', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle22', 'Nestle22', 30, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle3', 'Nestle3', 31, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle23', 'Nestle23', 32, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle4', 'Nestle4', 33, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle24', 'Nestle24', 34, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle5', 'Nestle5', 35, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle25', 'Nestle25', 36, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle6', 'Nestle6', 37, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle26', 'Nestle26', 38, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle7', 'Nestle7', 39, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle27', 'Nestle27', 40, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle8', 'Nestle8', 41, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle28', 'Nestle28', 42, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle9', 'Nestle9', 43, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle29', 'Nestle29', 44, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle10', 'Nestle10', 45, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle30', 'Nestle30', 46, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle11', 'Nestle11', 47, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle31', 'Nestle31', 48, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle35', 'Nestle35', 49, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle36', 'Nestle36', 50, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle12', 'Nestle12', 51, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle32', 'Nestle32', 52, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle13', 'Nestle13', 53, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle33', 'Nestle33', 54, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle14', 'Nestle14', 55, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle34', 'Nestle34', 56, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle15', 'Nestle15', 57, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle16', 'Nestle16', 58, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle17', 'Nestle17', 59, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle18', 'Nestle18', 60, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle19', 'Nestle19', 61, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle20', 'Nestle20', 62, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle37', 'Nestle37', 63, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle38', 'Nestle38', 64, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle39', 'Nestle39', 65, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle40', 'Nestle40', 66, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle41', 'Nestle41', 67, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle42', 'Nestle42', 68, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle43', 'Nestle43', 69, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle44', 'Nestle44', 70, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle92', 'Nestle92', 71, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle93', 'Nestle93', 72, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle94', 'Nestle94', 73, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle95', 'Nestle95', 74, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle96', 'Nestle96', 75, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle97', 'Nestle97', 76, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle98', 'Nestle98', 77, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric1', 'nric1', 78, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric2', 'nric2', 79, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric3', 'nric3', 80, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric4', 'nric4', 81, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric5', 'nric5', 82, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric6', 'nric6', 83, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric7', 'nric7', 84, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric8', 'nric8', 85, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric9', 'nric9', 86, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric10', 'nric10', 87, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric11', 'nric11', 88, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric12', 'nric12', 89, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric13', 'nric13', 90, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric14', 'nric14', 91, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric15', 'nric15', 92, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric16', 'nric16', 93, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric17', 'nric17', 94, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric18', 'nric18', 95, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric19', 'nric19', 96, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric20', 'nric20', 97, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric21', 'nric21', 98, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric22', 'nric22', 99, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nric23', 'nric23', 100, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber1', 'gerber1', 101, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber2', 'gerber2', 102, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber3', 'gerber3', 103, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber4', 'gerber4', 104, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber5', 'gerber5', 105, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber6', 'gerber6', 106, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber7', 'gerber7', 107, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber8', 'gerber8', 108, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber9', 'gerber9', 109, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber10', 'gerber10', 110, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'gerber11', 'gerber11', 111, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle45', 'Nestle45', 112, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle46', 'Nestle46', 113, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle47', 'Nestle47', 114, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle48', 'Nestle48', 115, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle49', 'Nestle49', 116, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle50', 'Nestle50', 117, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle51', 'Nestle51', 118, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle52', 'Nestle52', 119, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle53', 'Nestle53', 120, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle54', 'Nestle54', 121, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle55', 'Nestle55', 122, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle56', 'Nestle56', 123, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle57', 'Nestle57', 124, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle58', 'Nestle58', 125, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle59', 'Nestle59', 126, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle60', 'Nestle60', 127, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle61', 'Nestle61', 128, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle62', 'Nestle62', 129, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle63', 'Nestle63', 130, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle64', 'Nestle64', 131, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle65', 'Nestle65', 132, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle66', 'Nestle66', 133, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle67', 'Nestle67', 134, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle68', 'Nestle68', 135, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle69', 'Nestle69', 136, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle70', 'Nestle70', 137, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle71', 'Nestle71', 138, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle72', 'Nestle72', 139, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle73', 'Nestle73', 140, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle74', 'Nestle74', 141, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle75', 'Nestle75', 142, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle76', 'Nestle76', 143, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle77', 'Nestle77', 144, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle78', 'Nestle78', 145, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle79', 'Nestle79', 146, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle80', 'Nestle80', 147, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle81', 'Nestle81', 148, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle82', 'Nestle82', 149, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle83', 'Nestle83', 150, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle84', 'Nestle84', 151, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle85', 'Nestle85', 152, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle86', 'Nestle86', 153, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle87', 'Nestle87', 154, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle88', 'Nestle88', 155, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle89', 'Nestle89', 156, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle90', 'Nestle90', 157, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'Nestle91', 'Nestle91', 158, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs1', 'nccs1', 159, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs2', 'nccs2', 160, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs3', 'nccs3', 161, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs4', 'nccs4', 162, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs5', 'nccs5', 163, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs6', 'nccs6', 164, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs7', 'nccs7', 165, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs8', 'nccs8', 166, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs9', 'nccs9', 167, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs10', 'nccs10', 168, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs11', 'nccs11', 169, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs12', 'nccs12', 170, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs13', 'nccs13', 171, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs14', 'nccs14', 172, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs15', 'nccs15', 173, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs16', 'nccs16', 174, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs17', 'nccs17', 175, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs18', 'nccs18', 176, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs19', 'nccs19', 177, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs20', 'nccs20', 178, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs21', 'nccs21', 179, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs22', 'nccs22', 180, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs23', 'nccs23', 181, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs24', 'nccs24', 182, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs25', 'nccs25', 183, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs26', 'nccs26', 184, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nccs27', 'nccs27', 185, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'youcui1', 'youcui1', 186, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'youcui2', 'youcui2', 187, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'youcui3', 'youcui3', 188, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'youcui4', 'youcui4', 189, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg1', 'nqmg1', 190, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg2', 'nqmg2', 191, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg3', 'nqmg3', 192, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg4', 'nqmg4', 193, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg5', 'nqmg5', 194, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg6', 'nqmg6', 195, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg7', 'nqmg7', 196, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg8', 'nqmg8', 197, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg9', 'nqmg9', 198, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg10', 'nqmg10', 199, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg11', 'nqmg11', 200, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg12', 'nqmg12', 201, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg13', 'nqmg13', 202, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg1box', 'nqmg1box', 203, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg2box', 'nqmg2box', 204, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg3box', 'nqmg3box', 205, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg4box', 'nqmg4box', 206, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg5box', 'nqmg5box', 207, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nqmg6box', 'nqmg6box', 208, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco1', 'nco1', 209, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco2', 'nco2', 210, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco3', 'nco3', 211, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco4', 'nco4', 212, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco5', 'nco5', 213, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco6', 'nco6', 214, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco7', 'nco7', 215, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco8', 'nco8', 216, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco9', 'nco9', 217, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco10', 'nco10', 218, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco11', 'nco11', 219, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco12', 'nco12', 220, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco13', 'nco13', 221, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco14', 'nco14', 222, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco15', 'nco15', 223, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco16', 'nco16', 224, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco17', 'nco17', 225, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco18', 'nco18', 226, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco19', 'nco19', 227, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco20', 'nco20', 228, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco21', 'nco21', 229, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco22', 'nco22', 230, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco23', 'nco23', 231, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco24', 'nco24', 232, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco25', 'nco25', 233, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco26', 'nco26', 234, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco27', 'nco27', 235, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco28', 'nco28', 236, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco29', 'nco29', 237, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco30', 'nco30', 238, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco31', 'nco31', 239, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco32', 'nco32', 240, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco33', 'nco33', 241, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco34', 'nco34', 242, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco35', 'nco35', 243, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco36', 'nco36', 244, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco37', 'nco37', 245, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco38', 'nco38', 246, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco39', 'nco39', 247, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco40', 'nco40', 248, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco41', 'nco41', 249, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco42', 'nco42', 250, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco43', 'nco43', 251, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco44', 'nco44', 252, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco45', 'nco45', 253, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco46', 'nco46', 254, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco47', 'nco47', 255, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco48', 'nco48', 256, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco49', 'nco49', 257, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco50', 'nco50', 258, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco51', 'nco51', 259, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco52', 'nco52', 260, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco53', 'nco53', 261, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco54', 'nco54', 262, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco55', 'nco55', 263, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco56', 'nco56', 264, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco57', 'nco57', 265, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco58', 'nco58', 266, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco59', 'nco59', 267, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco60', 'nco60', 268, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco61', 'nco61', 269, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco62', 'nco62', 270, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco63', 'nco63', 271, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco64', 'nco64', 272, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco65', 'nco65', 273, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco66', 'nco66', 274, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco67', 'nco67', 275, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco68', 'nco68', 276, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco69', 'nco69', 277, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco70', 'nco70', 278, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco71', 'nco71', 279, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco72', 'nco72', 280, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco73', 'nco73', 281, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco74', 'nco74', 282, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco75', 'nco75', 283, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco76', 'nco76', 284, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco77', 'nco77', 285, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco78', 'nco78', 286, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco79', 'nco79', 287, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco80', 'nco80', 288, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco81', 'nco81', 289, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco82', 'nco82', 290, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco83', 'nco83', 291, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestle4goods', 'nco84', 'nco84', 292, now());
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
