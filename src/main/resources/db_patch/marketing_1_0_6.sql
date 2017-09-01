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
DROP PROCEDURE IF EXISTS UpdateSkuTableData;

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
		UPDATE `major_type` SET `status` = "deleted" where name = "driedmilk";
		UPDATE `major_type` SET `status` = "deleted" where name = "coffee";
		UPDATE `major_type` SET `version` = "9.0" where name = "beer";
		UPDATE `major_type` SET `version` = "2.0" where name = "chocolate";
		
		INSERT INTO `major_type`(`name`, `description`,`version`, `create_time`) VALUES ('nielsennv', '尼尔森女性护理', '1.0', now());
		INSERT INTO `major_type`(`name`, `description`,`version`, `create_time`) VALUES ('nielsendrink', '尼尔森饮料', '1.0', now());
		INSERT INTO `major_type`(`name`, `description`,`version`, `create_time`) VALUES ('nestlemilk', '雀巢炼奶', '2.0', now());
		INSERT INTO `major_type`(`name`, `description`,`version`, `create_time`) VALUES ('nestlecoffee', '雀巢咖啡', '2.0', now());
		INSERT INTO `major_type`(`name`, `description`,`version`, `create_time`) VALUES ('nestlemilkpowder', '雀巢奶粉', '2.0', now());
		INSERT INTO `major_type`(`name`, `description`,`version`, `create_time`) VALUES ('nestleoatmeal', '雀巢麦片', '2.0', now());
		INSERT INTO `major_type`(`name`, `description`,`version`, `create_time`) VALUES ('nestlericeflour', '雀巢营养品', '2.0', now());
		INSERT INTO `major_type`(`name`, `description`,`version`, `create_time`) VALUES ('nestlesugar', '雀巢糖果', '2.0', now());
		INSERT INTO `major_type`(`name`, `description`,`version`, `create_time`) VALUES ('nestlebiscuit', '雀巢饼干', '2.0', now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsennv', 'femnine1', 'femnine1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsennv', 'femnine2', 'femnine2', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsennv', 'femnine3', 'femnine3', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsennv', 'femnine4', 'femnine4', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsennv', 'femnine5', 'femnine5', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsennv', 'femnine6', 'femnine6', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsennv', 'femnine7', 'femnine7', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsennv', 'femnine8', 'femnine8', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsennv', 'femnine9', 'femnine9', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsennv', 'femnine10', 'femnine10', 9, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsendrink', 'beverage1', 'beverage1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsendrink', 'beverage2', 'beverage2', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsendrink', 'beverage3', 'beverage3', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsendrink', 'beverage4', 'beverage4', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsendrink', 'beverage5', 'beverage5', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsendrink', 'beverage6', 'beverage6', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsendrink', 'beverage7', 'beverage7', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsendrink', 'beverage8', 'beverage8', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsendrink', 'beverage9', 'beverage9', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsendrink', 'beverage10', 'beverage10', 9, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilk', 'ncon1', 'ncon1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilk', 'ncon2', 'ncon2', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilk', 'ncon3', 'ncon3', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilk', 'ncon4', 'ncon4', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilk', 'ncon5', 'ncon5', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilk', 'ncon6', 'ncon6', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilk', 'ncon7', 'ncon7', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilk', 'ncon8', 'ncon8', 7, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco1', 'nco1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco2', 'nco2', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco3', 'nco3', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco4', 'nco4', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco5', 'nco5', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco6', 'nco6', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco7', 'nco7', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco8', 'nco8', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco9', 'nco9', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco10', 'nco10', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco11', 'nco11', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco12', 'nco12', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco13', 'nco13', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco14', 'nco14', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco15', 'nco15', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco16', 'nco16', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco17', 'nco17', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco18', 'nco18', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco19', 'nco19', 18, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco20', 'nco20', 19, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco21', 'nco21', 20, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco22', 'nco22', 21, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco23', 'nco23', 22, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco24', 'nco24', 23, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco25', 'nco25', 24, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco26', 'nco26', 25, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco27', 'nco27', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco28', 'nco28', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco29', 'nco29', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco30', 'nco30', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco31', 'nco31', 30, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco32', 'nco32', 31, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco33', 'nco33', 32, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco34', 'nco34', 33, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco35', 'nco35', 34, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco36', 'nco36', 35, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco37', 'nco37', 36, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco38', 'nco38', 37, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco39', 'nco39', 38, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco40', 'nco40', 39, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco41', 'nco41', 40, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco42', 'nco42', 41, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco43', 'nco43', 42, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco44', 'nco44', 43, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco45', 'nco45', 44, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco46', 'nco46', 45, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco47', 'nco47', 46, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco48', 'nco48', 47, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco49', 'nco49', 48, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco50', 'nco50', 49, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco51', 'nco51', 50, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco52', 'nco52', 51, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco53', 'nco53', 52, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco54', 'nco54', 53, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco55', 'nco55', 54, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco56', 'nco56', 55, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco57', 'nco57', 56, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco58', 'nco58', 57, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco59', 'nco59', 58, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco60', 'nco60', 59, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco61', 'nco61', 60, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco62', 'nco62', 61, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco63', 'nco63', 62, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco64', 'nco64', 63, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco65', 'nco65', 64, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco66', 'nco66', 65, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco67', 'nco67', 66, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco68', 'nco68', 67, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco69', 'nco69', 68, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco70', 'nco70', 69, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco71', 'nco71', 70, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 1', 'Nestle 1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 21', 'Nestle 21', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 2', 'Nestle 2', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 22', 'Nestle 22', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 3', 'Nestle 3', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 23', 'Nestle 23', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 4', 'Nestle 4', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 24', 'Nestle 24', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 5', 'Nestle 5', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 25', 'Nestle 25', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 6', 'Nestle 6', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 26', 'Nestle 26', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 7', 'Nestle 7', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 27', 'Nestle 27', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 8', 'Nestle 8', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 28', 'Nestle 28', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 9', 'Nestle 9', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 29', 'Nestle 29', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 10', 'Nestle 10', 18, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 30', 'Nestle 30', 19, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 11', 'Nestle 11', 20, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 31', 'Nestle 31', 21, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 35', 'Nestle 35', 22, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 36', 'Nestle 36', 23, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 12', 'Nestle 12', 24, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 32', 'Nestle 32', 25, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 13', 'Nestle 13', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 33', 'Nestle 33', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 14', 'Nestle 14', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 34', 'Nestle 34', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 15', 'Nestle 15', 30, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 16', 'Nestle 16', 31, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 17', 'Nestle 17', 32, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 18', 'Nestle 18', 33, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 19', 'Nestle 19', 34, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 37', 'Nestle 37', 35, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 38', 'Nestle 38', 36, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 39', 'Nestle 39', 37, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 40', 'Nestle 40', 38, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 41', 'Nestle 41', 39, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 42', 'Nestle 42', 40, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 43', 'Nestle 43', 41, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 44', 'Nestle 44', 42, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 45', 'Nestle 45', 43, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 46', 'Nestle 46', 44, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 47', 'Nestle 47', 45, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 48', 'Nestle 48', 46, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 49', 'Nestle 49', 47, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 50', 'Nestle 50', 48, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 51', 'Nestle 51', 49, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 52', 'Nestle 52', 50, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 53', 'Nestle 53', 51, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 54', 'Nestle 54', 52, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 55', 'Nestle 55', 53, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 56', 'Nestle 56', 54, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 57', 'Nestle 57', 55, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 58', 'Nestle 58', 56, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 59', 'Nestle 59', 57, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 60', 'Nestle 60', 58, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 61', 'Nestle 61', 59, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 62', 'Nestle 62', 60, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 63', 'Nestle 63', 61, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 64', 'Nestle 64', 62, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 65', 'Nestle 65', 63, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 66', 'Nestle 66', 64, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 67', 'Nestle 67', 65, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 68', 'Nestle 68', 66, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 69', 'Nestle 69', 67, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 70', 'Nestle 70', 68, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 71', 'Nestle 71', 69, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 72', 'Nestle 72', 70, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 73', 'Nestle 73', 71, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 74', 'Nestle 74', 72, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 75', 'Nestle 75', 73, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 76', 'Nestle 76', 74, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 77', 'Nestle 77', 75, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 78', 'Nestle 78', 76, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 79', 'Nestle 79', 77, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 80', 'Nestle 80', 78, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 81', 'Nestle 81', 79, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 82', 'Nestle 82', 80, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 83', 'Nestle 83', 81, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 84', 'Nestle 84', 82, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 85', 'Nestle 85', 83, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 86', 'Nestle 86', 84, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 87', 'Nestle 87', 85, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 88', 'Nestle 88', 86, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 89', 'Nestle 89', 87, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 90', 'Nestle 90', 88, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 91', 'Nestle 91', 89, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 92', 'Nestle 92', 90, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 93', 'Nestle 93', 91, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 94', 'Nestle 94', 92, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 95', 'Nestle 95', 93, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle 96', 'Nestle 96', 94, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor1', 'ncor1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor2', 'ncor2', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor3', 'ncor3', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor4', 'ncor4', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor5', 'ncor5', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor6', 'ncor6', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor7', 'ncor7', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor8', 'ncor8', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor9', 'ncor9', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor10', 'ncor10', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor11', 'ncor11', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor12', 'ncor12', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor13', 'ncor13', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor14', 'ncor14', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor15', 'ncor15', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor16', 'ncor16', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor17', 'ncor17', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor18', 'ncor18', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestleoatmeal', 'ncor19', 'ncor19', 18, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric1', 'nric1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric2', 'nric2', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric3', 'nric3', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric4', 'nric4', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric5', 'nric5', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric6', 'nric6', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric7', 'nric7', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric8', 'nric8', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric9', 'nric9', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric10', 'nric10', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric11', 'nric11', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric12', 'nric12', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric13', 'nric13', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric14', 'nric14', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric15', 'nric15', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric16', 'nric16', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric17', 'nric17', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric18', 'nric18', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric19', 'nric19', 18, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric20', 'nric20', 19, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric21', 'nric21', 20, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric22', 'nric22', 21, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'nric23', 'nric23', 22, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'gerber1', 'gerber1', 23, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'gerber2', 'gerber2', 24, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'gerber3', 'gerber3', 25, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'gerber4', 'gerber4', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'gerber5', 'gerber5', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'gerber6', 'gerber6', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'gerber7', 'gerber7', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'gerber8', 'gerber8', 30, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'gerber9', 'gerber9', 31, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'gerber10', 'gerber10', 32, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlericeflour', 'gerber11', 'gerber11', 33, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg1', 'nqmg1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg2', 'nqmg2', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg3', 'nqmg3', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg4', 'nqmg4', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg5', 'nqmg5', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg6', 'nqmg6', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg7', 'nqmg7', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg8', 'nqmg8', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg9', 'nqmg9', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg10', 'nqmg10', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg11', 'nqmg11', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg12', 'nqmg12', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg1box', 'nqmg1box', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg2box', 'nqmg2box', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg3box', 'nqmg3box', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg4box', 'nqmg4box', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg5box', 'nqmg5box', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg6box', 'nqmg6box', 17, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs1', 'nccs1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs2', 'nccs2', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs3', 'nccs3', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs4', 'nccs4', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs5', 'nccs5', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs6', 'nccs6', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs7', 'nccs7', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs8', 'nccs8', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs9', 'nccs9', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs10', 'nccs10', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs11', 'nccs11', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs12', 'nccs12', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs13', 'nccs13', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs14', 'nccs14', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs15', 'nccs15', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs16', 'nccs16', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs17', 'nccs17', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs18', 'nccs18', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs19', 'nccs19', 18, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs20', 'nccs20', 19, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs21', 'nccs21', 20, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs22', 'nccs22', 21, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs23', 'nccs23', 22, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs24', 'nccs24', 23, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs25', 'nccs25', 24, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs26', 'nccs26', 25, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'youcui1', 'youcui1', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'youcui2', 'youcui2', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'youcui3', 'youcui3', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'youcui4', 'youcui4', 29, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (8, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (8, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (8, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (9, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (9, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (9, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (10, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (10, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (10, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (11, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (11, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (11, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (12, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (12, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (12, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (13, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (13, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (13, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (14, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (14, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (14, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (15, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (15, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (15, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (16, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (16, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (16, 3, now());
	END IF;
END//

DELIMITER //
CREATE PROCEDURE UpdateSkuTableData()
BEGIN
	SET @ret = 0;
	CALL CheckTableExist("goods_sku", @ret);
	IF @ret = 1 THEN 
		UPDATE `goods_sku` SET `description` = "巴斯啤酒500ml听装" where major_type = "beer" and `name` = "bass1";
		UPDATE `goods_sku` SET `description` = "budweiser1" where major_type = "beer" and `name` = "budweiser1";
		UPDATE `goods_sku` SET `description` = "百威11度473ML1X24铝瓶箱装" where major_type = "beer" and `name` = "budweiser2";
		UPDATE `goods_sku` SET `description` = "budweiser3" where major_type = "beer" and `name` = "budweiser3";
		UPDATE `goods_sku` SET `description` = "百威9.7度355ML铝瓶" where major_type = "beer" and `name` = "budweiser4";
		UPDATE `goods_sku` SET `description` = "百威11度473ML铝瓶" where major_type = "beer" and `name` = "budweiser5";
		UPDATE `goods_sku` SET `description` = "budweiser6" where major_type = "beer" and `name` = "budweiser6";
		UPDATE `goods_sku` SET `description` = "百威9.7度460ML1X12瓶装箱装" where major_type = "beer" and `name` = "budweiser7";
		UPDATE `goods_sku` SET `description` = "百威纯生8度500ML1X12瓶装箱装" where major_type = "beer" and `name` = "budweiser8";
		UPDATE `goods_sku` SET `description` = "百威纯生8度500ML1X3瓶装三连包" where major_type = "beer" and `name` = "budweiser9";
		UPDATE `goods_sku` SET `description` = "百威9.7度600ML1X3瓶装三连包" where major_type = "beer" and `name` = "budweiser10";
		UPDATE `goods_sku` SET `description` = "百威9.7度600ML1X6瓶装箱装" where major_type = "beer" and `name` = "budweiser11";
		UPDATE `goods_sku` SET `description` = "百威9.7度600ML1X12瓶装箱装" where major_type = "beer" and `name` = "budweiser12";
		UPDATE `goods_sku` SET `description` = "百威9.7度330ML瓶装" where major_type = "beer" and `name` = "budweiser13";
		UPDATE `goods_sku` SET `description` = "百威9.7度460ML瓶装" where major_type = "beer" and `name` = "budweiser14";
		UPDATE `goods_sku` SET `description` = "百威9.7度600ML瓶装" where major_type = "beer" and `name` = "budweiser15";
		UPDATE `goods_sku` SET `description` = "百威纯生8度330ML瓶装" where major_type = "beer" and `name` = "budweiser16";
		UPDATE `goods_sku` SET `description` = "百威纯生8度500ML瓶装" where major_type = "beer" and `name` = "budweiser17";
		UPDATE `goods_sku` SET `description` = "百威9.7度330ML1X24听装箱装" where major_type = "beer" and `name` = "budweiser18";
		UPDATE `goods_sku` SET `description` = "百威9.7度500ML1X18听装箱装" where major_type = "beer" and `name` = "budweiser19";
		UPDATE `goods_sku` SET `description` = "百威9.7度330ML1X24听装箱装" where major_type = "beer" and `name` = "budweiser20";
		UPDATE `goods_sku` SET `description` = "百威9.7度500ml1X12听装礼盒" where major_type = "beer" and `name` = "budweiser21";
		UPDATE `goods_sku` SET `description` = "百威纯生8度330ML1X24听纸箱装" where major_type = "beer" and `name` = "budweiser22";
		UPDATE `goods_sku` SET `description` = "百威9.7度330ML4X6听装整箱" where major_type = "beer" and `name` = "budweiser23";
		UPDATE `goods_sku` SET `description` = "百威纯生8度330ML4X6听装整箱" where major_type = "beer" and `name` = "budweiser24";
		UPDATE `goods_sku` SET `description` = "百威9.7度500ML3X6听装整箱" where major_type = "beer" and `name` = "budweiser25";
		UPDATE `goods_sku` SET `description` = "百威9.7度330ML1X6听装六连包" where major_type = "beer" and `name` = "budweiser26";
		UPDATE `goods_sku` SET `description` = "百威纯生8度330ML1X6听装六连包" where major_type = "beer" and `name` = "budweiser27";
		UPDATE `goods_sku` SET `description` = "百威9.7度500ml1X3听装三连包" where major_type = "beer" and `name` = "budweiser28";
		UPDATE `goods_sku` SET `description` = "百威纯生8度330ML听装" where major_type = "beer" and `name` = "budweiser29";
		UPDATE `goods_sku` SET `description` = "百威9.7度330ML听装" where major_type = "beer" and `name` = "budweiser30";
		UPDATE `goods_sku` SET `description` = "百威9.7度500ml听装" where major_type = "beer" and `name` = "budweiser31";
		UPDATE `goods_sku` SET `description` = "budweiser32" where major_type = "beer" and `name` = "budweiser32";
		UPDATE `goods_sku` SET `description` = "百威11度473ML铝瓶" where major_type = "beer" and `name` = "budweiser33";
		UPDATE `goods_sku` SET `description` = "百威11度473ML1X6铝瓶箱装" where major_type = "beer" and `name` = "budweiser34";
		UPDATE `goods_sku` SET `description` = "百威9.7度355ML铝瓶" where major_type = "beer" and `name` = "budweiser35";
		UPDATE `goods_sku` SET `description` = "budweiser36" where major_type = "beer" and `name` = "budweiser36";
		UPDATE `goods_sku` SET `description` = "百威9.7度600ML1X6瓶装箱装" where major_type = "beer" and `name` = "budweiser37";
		UPDATE `goods_sku` SET `description` = "百威9.7度600ML1X12瓶装箱装" where major_type = "beer" and `name` = "budweiser38";
		UPDATE `goods_sku` SET `description` = "百威9.7度460ML瓶装" where major_type = "beer" and `name` = "budweiser39";
		UPDATE `goods_sku` SET `description` = "百威9.7度600ML瓶装" where major_type = "beer" and `name` = "budweiser40";
		UPDATE `goods_sku` SET `description` = "百威9.7度330ML1X24听装箱装" where major_type = "beer" and `name` = "budweiser41";
		UPDATE `goods_sku` SET `description` = "百威9.7度500ML1X18听装箱装" where major_type = "beer" and `name` = "budweiser42";
		UPDATE `goods_sku` SET `description` = "百威9.7度500ML3X6听装整箱" where major_type = "beer" and `name` = "budweiser43";
		UPDATE `goods_sku` SET `description` = "百威9.7度330ML1X6听装六连包" where major_type = "beer" and `name` = "budweiser44";
		UPDATE `goods_sku` SET `description` = "百威纯生8度330ML1X6听装六连包" where major_type = "beer" and `name` = "budweiser45";
		UPDATE `goods_sku` SET `description` = "百威9.7度500ml1X3听装三连包" where major_type = "beer" and `name` = "budweiser46";
		UPDATE `goods_sku` SET `description` = "百威9.7度330ML听装" where major_type = "beer" and `name` = "budweiser47";
		UPDATE `goods_sku` SET `description` = "百威9.7度500ml听装" where major_type = "beer" and `name` = "budweiser48";
		UPDATE `goods_sku` SET `description` = "百威9.7度355ML1X24铝瓶箱装" where major_type = "beer" and `name` = "budweiser49";
		UPDATE `goods_sku` SET `description` = "百威9.7度600ML1X3瓶装三连包" where major_type = "beer" and `name` = "budweiser50";
		UPDATE `goods_sku` SET `description` = "百威9.7度330ML1X24瓶装箱装" where major_type = "beer" and `name` = "budweiser51";
		UPDATE `goods_sku` SET `description` = "百威9.7度330ML4X6听装整箱" where major_type = "beer" and `name` = "budweiser52";
		UPDATE `goods_sku` SET `description` = "百威9.7度460ML1X12瓶装箱装" where major_type = "beer" and `name` = "budweiser53";
		UPDATE `goods_sku` SET `description` = "宝汀顿啤酒500ml听装" where major_type = "beer" and `name` = "boddington1";
		UPDATE `goods_sku` SET `description` = "福佳白11.7度330ML1X24瓶装箱装" where major_type = "beer" and `name` = "hoegaarden1";
		UPDATE `goods_sku` SET `description` = "福佳白11.7度500ML1X24听装箱装" where major_type = "beer" and `name` = "hoegaarden2";
		UPDATE `goods_sku` SET `description` = "福佳白11.7度330ML瓶装" where major_type = "beer" and `name` = "hoegaarden3";
		UPDATE `goods_sku` SET `description` = "福佳白11.7度500ML听装" where major_type = "beer" and `name` = "hoegaarden4";
		UPDATE `goods_sku` SET `description` = "哈尔滨特制小超鲜10度330ML1X24瓶装箱装" where major_type = "beer" and `name` = "harbin1";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰爽9度330ML1X24瓶装箱装" where major_type = "beer" and `name` = "harbin2";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯淡爽7度500ML1X12瓶装箱装" where major_type = "beer" and `name` = "harbin3";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度600ML1X12瓶装箱装" where major_type = "beer" and `name` = "harbin4";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰爽9度580ML1X12纸箱瓶装" where major_type = "beer" and `name` = "harbin5";
		UPDATE `goods_sku` SET `description` = "哈尔滨清爽11度580ML1X12瓶装箱装" where major_type = "beer" and `name` = "harbin6";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度600ML1X3瓶装三连包" where major_type = "beer" and `name` = "harbin7";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度600ML1X6瓶装箱装" where major_type = "beer" and `name` = "harbin8";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度500ML1X3瓶装三连包" where major_type = "beer" and `name` = "harbin9";
		UPDATE `goods_sku` SET `description` = "harbin10" where major_type = "beer" and `name` = "harbin10";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度330ML1X24听装箱装" where major_type = "beer" and `name` = "harbin11";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度500ML1x18听装箱装" where major_type = "beer" and `name` = "harbin12";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度330ML1X6听装六连包" where major_type = "beer" and `name` = "harbin13";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度330ML4X6听装整箱" where major_type = "beer" and `name` = "harbin14";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度330ML听装1X24箱装" where major_type = "beer" and `name` = "harbin15";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度500ML1X18听装箱装" where major_type = "beer" and `name` = "harbin16";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度500ML3X6听装整箱" where major_type = "beer" and `name` = "harbin17";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度500ml1X3听装三连包" where major_type = "beer" and `name` = "harbin18";
		UPDATE `goods_sku` SET `description` = "哈尔滨清爽330ml1X6听装六连包" where major_type = "beer" and `name` = "harbin19";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度330ml1X6听装六连包" where major_type = "beer" and `name` = "harbin20";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰爽9度330ML1X6听装六连包" where major_type = "beer" and `name` = "harbin21";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度500ML1X3听装三连包" where major_type = "beer" and `name` = "harbin22";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度330ml4X6听装整箱" where major_type = "beer" and `name` = "harbin23";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰爽9度330ML4X6听装整箱" where major_type = "beer" and `name` = "harbin24";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度500ML6X3听装整箱" where major_type = "beer" and `name` = "harbin25";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度330ML听装" where major_type = "beer" and `name` = "harbin26";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度500ML听装" where major_type = "beer" and `name` = "harbin27";
		UPDATE `goods_sku` SET `description` = "哈尔滨特制超干330ml听装" where major_type = "beer" and `name` = "harbin28";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度330ML听装" where major_type = "beer" and `name` = "harbin29";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰爽9度330ML听装" where major_type = "beer" and `name` = "harbin30";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度500ML听装" where major_type = "beer" and `name` = "harbin31";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯330ML瓶装" where major_type = "beer" and `name` = "harbin32";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯淡爽7度500ML瓶装" where major_type = "beer" and `name` = "harbin33";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度600ML瓶装" where major_type = "beer" and `name` = "harbin34";
		UPDATE `goods_sku` SET `description` = "哈尔滨纯生500ML瓶装" where major_type = "beer" and `name` = "harbin35";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度500ML瓶装" where major_type = "beer" and `name` = "harbin36";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰爽9度330ML瓶装" where major_type = "beer" and `name` = "harbin37";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰爽9度580ML瓶装" where major_type = "beer" and `name` = "harbin38";
		UPDATE `goods_sku` SET `description` = "哈尔滨特制小超鲜10度330ML" where major_type = "beer" and `name` = "harbin39";
		UPDATE `goods_sku` SET `description` = "哈尔滨小特鲜10度330ml" where major_type = "beer" and `name` = "harbin40";
		UPDATE `goods_sku` SET `description` = "哈尔滨清爽11度580ML瓶装" where major_type = "beer" and `name` = "harbin41";
		UPDATE `goods_sku` SET `description` = "哈尔滨特制超干500ml瓶装" where major_type = "beer" and `name` = "harbin42";
		UPDATE `goods_sku` SET `description` = "哈尔滨小棒纯生500ml瓶装" where major_type = "beer" and `name` = "harbin43";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度330ml1X6听装六连包HIPANDA" where major_type = "beer" and `name` = "harbin44";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度600ML1X12瓶装箱装" where major_type = "beer" and `name` = "harbin45";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度600ML1X3瓶装三连包" where major_type = "beer" and `name` = "harbin46";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度600ML1X6瓶装箱装" where major_type = "beer" and `name` = "harbin47";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度330ML1X6听装六连包" where major_type = "beer" and `name` = "harbin48";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度330ML4X6听装整箱" where major_type = "beer" and `name` = "harbin49";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度500ML3X6听装整箱" where major_type = "beer" and `name` = "harbin50";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度500ml1X3听装三连包" where major_type = "beer" and `name` = "harbin51";
		UPDATE `goods_sku` SET `description` = "哈尔滨清爽330ml1X6听装六连包" where major_type = "beer" and `name` = "harbin52";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度330ml1X6听装六连包" where major_type = "beer" and `name` = "harbin53";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰爽9度330ML1X6听装六连包" where major_type = "beer" and `name` = "harbin54";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度500ML1X3听装三连包" where major_type = "beer" and `name` = "harbin55";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度330ML听装" where major_type = "beer" and `name` = "harbin56";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度500ML听装" where major_type = "beer" and `name` = "harbin57";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度330ML听装" where major_type = "beer" and `name` = "harbin58";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰爽9度330ML听装" where major_type = "beer" and `name` = "harbin59";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度500ML听装" where major_type = "beer" and `name` = "harbin60";
		UPDATE `goods_sku` SET `description` = "哈尔滨特制小超鲜10度330ML" where major_type = "beer" and `name` = "harbin61";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰爽9度330ML4X6听装整箱" where major_type = "beer" and `name` = "harbin62";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度500ML6X3听装整箱" where major_type = "beer" and `name` = "harbin63";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度500*12ML瓶装纸箱" where major_type = "beer" and `name` = "harbin64";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度330ML1X24听装箱装" where major_type = "beer" and `name` = "harbin65";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度330ML听装1X24箱装" where major_type = "beer" and `name` = "harbin66";
		UPDATE `goods_sku` SET `description` = "哈尔滨小麦王10度500ML1X18听装箱装" where major_type = "beer" and `name` = "harbin67";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰纯9.1度330ml4X6听装整箱" where major_type = "beer" and `name` = "harbin68";
		UPDATE `goods_sku` SET `description` = "哈尔滨冰爽9度580ML瓶装" where major_type = "beer" and `name` = "harbin69";
		UPDATE `goods_sku` SET `description` = "harbin70" where major_type = "beer" and `name` = "harbin70";
		UPDATE `goods_sku` SET `description` = "科罗娜11.3度330ML1X6瓶装" where major_type = "beer" and `name` = "corona1";
		UPDATE `goods_sku` SET `description` = "科罗妮她207ML1X6瓶装" where major_type = "beer" and `name` = "corona2";
		UPDATE `goods_sku` SET `description` = "科罗娜11.3度330ML4X6瓶装箱装" where major_type = "beer" and `name` = "corona3";
		UPDATE `goods_sku` SET `description` = "科罗娜11.3度330ML瓶装" where major_type = "beer" and `name` = "corona4";
		
	END IF;
END//

DELIMITER ;
	
CALL InsertMajorTypeAndSkuTableData();
CALL UpdateSkuTableData();

DROP PROCEDURE IF EXISTS CheckTableExist;
DROP PROCEDURE IF EXISTS CheckColumnExist;
DROP PROCEDURE IF EXISTS CheckIndexExist;
DROP PROCEDURE IF EXISTS CheckConstraintExist;
DROP PROCEDURE IF EXISTS CheckPrimaryKeyExist;
DROP PROCEDURE IF EXISTS CheckDataExist;
DROP PROCEDURE IF EXISTS InsertMajorTypeAndSkuTableData;
DROP PROCEDURE IF EXISTS UpdateSkuTableData;
