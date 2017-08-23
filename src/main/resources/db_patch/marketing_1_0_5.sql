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
CREATE PROCEDURE UpdateMajorTypeAndSkuTableData()
BEGIN
	SET @ret = 0;
	CALL CheckTableExist("major_type", @ret);
	IF @ret = 1 THEN 
		UPDATE `major_type` SET `version` = "7.0" where name = "beer";
		
		UPDATE `goods_sku` SET `order` = 54 where major_type = "beer" and `name` = "boddington1";
		UPDATE `goods_sku` SET `order` = 55 where major_type = "beer" and `name` = "hoegaarden1";
		UPDATE `goods_sku` SET `order` = 56 where major_type = "beer" and `name` = "hoegaarden2";
		UPDATE `goods_sku` SET `order` = 57 where major_type = "beer" and `name` = "hoegaarden3";
		UPDATE `goods_sku` SET `order` = 58 where major_type = "beer" and `name` = "hoegaarden4";
		UPDATE `goods_sku` SET `order` = 59 where major_type = "beer" and `name` = "harbin1";
		UPDATE `goods_sku` SET `order` = 60 where major_type = "beer" and `name` = "harbin2";
		UPDATE `goods_sku` SET `order` = 61 where major_type = "beer" and `name` = "harbin3";
		UPDATE `goods_sku` SET `order` = 62 where major_type = "beer" and `name` = "harbin4";
		UPDATE `goods_sku` SET `order` = 63 where major_type = "beer" and `name` = "harbin5";
		UPDATE `goods_sku` SET `order` = 64 where major_type = "beer" and `name` = "harbin6";
		UPDATE `goods_sku` SET `order` = 65 where major_type = "beer" and `name` = "harbin7";
		UPDATE `goods_sku` SET `order` = 66 where major_type = "beer" and `name` = "harbin8";
		UPDATE `goods_sku` SET `order` = 67 where major_type = "beer" and `name` = "harbin9";
		UPDATE `goods_sku` SET `order` = 68 where major_type = "beer" and `name` = "harbin10";
		UPDATE `goods_sku` SET `order` = 69 where major_type = "beer" and `name` = "harbin11";
		UPDATE `goods_sku` SET `order` = 70 where major_type = "beer" and `name` = "harbin12";
		UPDATE `goods_sku` SET `order` = 71 where major_type = "beer" and `name` = "harbin13";
		UPDATE `goods_sku` SET `order` = 72 where major_type = "beer" and `name` = "harbin14";
		UPDATE `goods_sku` SET `order` = 73 where major_type = "beer" and `name` = "harbin15";
		UPDATE `goods_sku` SET `order` = 74 where major_type = "beer" and `name` = "harbin16";
		UPDATE `goods_sku` SET `order` = 75 where major_type = "beer" and `name` = "harbin17";
		UPDATE `goods_sku` SET `order` = 76 where major_type = "beer" and `name` = "harbin18";
		UPDATE `goods_sku` SET `order` = 77 where major_type = "beer" and `name` = "harbin19";
		UPDATE `goods_sku` SET `order` = 78 where major_type = "beer" and `name` = "harbin20";
		UPDATE `goods_sku` SET `order` = 79 where major_type = "beer" and `name` = "harbin21";
		UPDATE `goods_sku` SET `order` = 80 where major_type = "beer" and `name` = "harbin22";
		UPDATE `goods_sku` SET `order` = 81 where major_type = "beer" and `name` = "harbin23";
		UPDATE `goods_sku` SET `order` = 82 where major_type = "beer" and `name` = "harbin24";
		UPDATE `goods_sku` SET `order` = 83 where major_type = "beer" and `name` = "harbin25";
		UPDATE `goods_sku` SET `order` = 84 where major_type = "beer" and `name` = "harbin26";
		UPDATE `goods_sku` SET `order` = 85 where major_type = "beer" and `name` = "harbin27";
		UPDATE `goods_sku` SET `order` = 86 where major_type = "beer" and `name` = "harbin28";
		UPDATE `goods_sku` SET `order` = 87 where major_type = "beer" and `name` = "harbin29";
		UPDATE `goods_sku` SET `order` = 88 where major_type = "beer" and `name` = "harbin30";
		UPDATE `goods_sku` SET `order` = 89 where major_type = "beer" and `name` = "harbin31";
		UPDATE `goods_sku` SET `order` = 90 where major_type = "beer" and `name` = "harbin32";
		UPDATE `goods_sku` SET `order` = 91 where major_type = "beer" and `name` = "harbin33";
		UPDATE `goods_sku` SET `order` = 92 where major_type = "beer" and `name` = "harbin34";
		UPDATE `goods_sku` SET `order` = 93 where major_type = "beer" and `name` = "harbin35";
		UPDATE `goods_sku` SET `order` = 94 where major_type = "beer" and `name` = "harbin36";
		UPDATE `goods_sku` SET `order` = 95 where major_type = "beer" and `name` = "harbin37";
		UPDATE `goods_sku` SET `order` = 96 where major_type = "beer" and `name` = "harbin38";
		UPDATE `goods_sku` SET `order` = 97 where major_type = "beer" and `name` = "harbin39";
		UPDATE `goods_sku` SET `order` = 98 where major_type = "beer" and `name` = "harbin40";
		UPDATE `goods_sku` SET `order` = 99 where major_type = "beer" and `name` = "harbin41";
		UPDATE `goods_sku` SET `order` = 100 where major_type = "beer" and `name` = "harbin42";
		UPDATE `goods_sku` SET `order` = 101 where major_type = "beer" and `name` = "harbin43";
		UPDATE `goods_sku` SET `order` = 102 where major_type = "beer" and `name` = "harbin44";
		UPDATE `goods_sku` SET `order` = 103 where major_type = "beer" and `name` = "harbin45";
		UPDATE `goods_sku` SET `order` = 104 where major_type = "beer" and `name` = "harbin46";
		UPDATE `goods_sku` SET `order` = 105 where major_type = "beer" and `name` = "harbin47";
		UPDATE `goods_sku` SET `order` = 106 where major_type = "beer" and `name` = "harbin48";
		UPDATE `goods_sku` SET `order` = 107 where major_type = "beer" and `name` = "harbin49";
		UPDATE `goods_sku` SET `order` = 108 where major_type = "beer" and `name` = "harbin50";
		UPDATE `goods_sku` SET `order` = 109 where major_type = "beer" and `name` = "harbin51";
		UPDATE `goods_sku` SET `order` = 110 where major_type = "beer" and `name` = "harbin52";
		UPDATE `goods_sku` SET `order` = 111 where major_type = "beer" and `name` = "harbin53";
		UPDATE `goods_sku` SET `order` = 112 where major_type = "beer" and `name` = "harbin54";
		UPDATE `goods_sku` SET `order` = 113 where major_type = "beer" and `name` = "harbin55";
		UPDATE `goods_sku` SET `order` = 114 where major_type = "beer" and `name` = "harbin56";
		UPDATE `goods_sku` SET `order` = 115 where major_type = "beer" and `name` = "harbin57";
		UPDATE `goods_sku` SET `order` = 116 where major_type = "beer" and `name` = "harbin58";
		UPDATE `goods_sku` SET `order` = 117 where major_type = "beer" and `name` = "harbin59";
		UPDATE `goods_sku` SET `order` = 118 where major_type = "beer" and `name` = "harbin60";
		UPDATE `goods_sku` SET `order` = 119 where major_type = "beer" and `name` = "harbin61";
		UPDATE `goods_sku` SET `order` = 129 where major_type = "beer" and `name` = "corona1";
		UPDATE `goods_sku` SET `order` = 130 where major_type = "beer" and `name` = "corona2";
		UPDATE `goods_sku` SET `order` = 131 where major_type = "beer" and `name` = "corona3";
		UPDATE `goods_sku` SET `order` = 132 where major_type = "beer" and `name` = "corona4";
		
	END IF;
END//

DELIMITER //
CREATE PROCEDURE InsertMajorTypeAndSkuTableData()
BEGIN
	SET @ret = 0;
	CALL CheckTableExist("goods_sku", @ret);
	IF @ret = 1 THEN 

		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser49', 'budweiser49', 49, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser50', 'budweiser50', 50, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser51', 'budweiser51', 51, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser52', 'budweiser52', 52, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser53', 'budweiser53', 53, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin62', 'harbin62', 120, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin63', 'harbin63', 121, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin64', 'harbin64', 122, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin65', 'harbin65', 123, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin66', 'harbin66', 124, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin67', 'harbin67', 125, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin68', 'harbin68', 126, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin69', 'harbin69', 127, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin70', 'harbin70', 128, now());

	END IF;
END//
DELIMITER ;
	
CALL UpdateMajorTypeAndSkuTableData();
CALL InsertMajorTypeAndSkuTableData();

DROP PROCEDURE IF EXISTS CheckTableExist;
DROP PROCEDURE IF EXISTS CheckColumnExist;
DROP PROCEDURE IF EXISTS CheckIndexExist;
DROP PROCEDURE IF EXISTS CheckConstraintExist;
DROP PROCEDURE IF EXISTS CheckPrimaryKeyExist;
DROP PROCEDURE IF EXISTS CheckDataExist;
DROP PROCEDURE IF EXISTS UpdateMajorTypeAndSkuTableData;
DROP PROCEDURE IF EXISTS InsertMajorTypeAndSkuTableData;
