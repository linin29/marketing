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
DROP PROCEDURE IF EXISTS InsertGoodsSkuDatas;

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
CREATE PROCEDURE InsertGoodsSkuDatas()
BEGIN
	SET @ret = 0;
	CALL CheckTableExist("goods_sku", @ret);
	IF @ret = 1 THEN 
	
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'belvita1', 'belvita1', 102, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'belvita2', 'belvita2', 103, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'belvita3', 'belvita3', 104, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'belvita4', 'belvita4', 105, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'belvita5', 'belvita5', 106, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'belvita6', 'belvita6', 107, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'belvita7', 'belvita7', 108, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'belvita8', 'belvita8', 109, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'belvita9', 'belvita9', 110, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'belvita10', 'belvita10', 111, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'belvita13', 'belvita13', 112, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'belvita14', 'belvita14', 113, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'belvita15', 'belvita15', 114, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific1', 'pacific1', 115, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific2', 'pacific2', 116, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific3', 'pacific3', 117, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific4', 'pacific4', 118, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific5', 'pacific5', 119, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific6', 'pacific6', 120, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific7', 'pacific7', 121, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific8', 'pacific8', 122, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific9', 'pacific9', 123, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific10', 'pacific10', 124, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific11', 'pacific11', 125, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific12', 'pacific12', 126, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific13', 'pacific13', 127, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific14', 'pacific14', 128, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific15', 'pacific15', 129, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific16', 'pacific16', 130, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific17', 'pacific17', 131, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific28', 'pacific28', 132, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific29', 'pacific29', 133, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific30', 'pacific30', 134, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'pacific31', 'pacific31', 135, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc1', 'tuc1', 136, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc2', 'tuc2', 137, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc3', 'tuc3', 138, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc4', 'tuc4', 139, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc5', 'tuc5', 140, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc6', 'tuc6', 141, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc7', 'tuc7', 142, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc8', 'tuc8', 143, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc9', 'tuc9', 144, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc10', 'tuc10', 145, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc11', 'tuc11', 146, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc12', 'tuc12', 147, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc13', 'tuc13', 148, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc14', 'tuc14', 149, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc15', 'tuc15', 150, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc16', 'tuc16', 151, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc17', 'tuc17', 152, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc18', 'tuc18', 153, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc19', 'tuc19', 154, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc20', 'tuc20', 155, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc21', 'tuc21', 156, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc22', 'tuc22', 157, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc23', 'tuc23', 158, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc24', 'tuc24', 159, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc25', 'tuc25', 160, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc26', 'tuc26', 161, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc27', 'tuc27', 162, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc35', 'tuc35', 163, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc36', 'tuc36', 164, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc39', 'tuc39', 165, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc40', 'tuc40', 166, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc41', 'tuc41', 167, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc42', 'tuc42', 168, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc43', 'tuc43', 169, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tuc44', 'tuc44', 170, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'uguan1', 'uguan1', 171, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'uguan2', 'uguan2', 172, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'uguan3', 'uguan3', 173, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'uguan4', 'uguan4', 174, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'uguan5', 'uguan5', 175, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'uguan6', 'uguan6', 176, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'uguan7', 'uguan7', 177, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'uguan8', 'uguan8', 178, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'uguan9', 'uguan9', 179, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'uguan10', 'uguan10', 180, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca1', 'ca1', 181, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca2', 'ca2', 182, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca3', 'ca3', 183, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca4', 'ca4', 184, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca5', 'ca5', 185, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca6', 'ca6', 186, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca7', 'ca7', 187, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca8', 'ca8', 188, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca9', 'ca9', 189, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca10', 'ca10', 190, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca11', 'ca11', 191, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca12', 'ca12', 192, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca13', 'ca13', 193, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca14', 'ca14', 194, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca15', 'ca15', 195, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca16', 'ca16', 196, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca17', 'ca17', 197, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca18', 'ca18', 198, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca19', 'ca19', 199, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca20', 'ca20', 200, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca21', 'ca21', 201, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca22', 'ca22', 202, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca23', 'ca23', 203, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca24', 'ca24', 204, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca25', 'ca25', 205, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca26', 'ca26', 206, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca27', 'ca27', 207, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca28', 'ca28', 208, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca29', 'ca29', 209, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca30', 'ca30', 210, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca31', 'ca31', 211, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca32', 'ca32', 212, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca33', 'ca33', 213, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca34', 'ca34', 214, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca35', 'ca35', 215, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'ca36', 'ca36', 216, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'prince1', 'prince1', 217, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'prince2', 'prince2', 218, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'prince3', 'prince3', 219, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'prince4', 'prince4', 220, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'prince5', 'prince5', 221, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'prince6', 'prince6', 222, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'prince7', 'prince7', 223, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo1', 'oreo1', 224, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo2', 'oreo2', 225, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo3', 'oreo3', 226, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo4', 'oreo4', 227, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo5', 'oreo5', 228, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo6', 'oreo6', 229, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo7', 'oreo7', 230, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo8', 'oreo8', 231, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo9', 'oreo9', 232, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo10', 'oreo10', 233, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo11', 'oreo11', 234, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo12', 'oreo12', 235, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo13', 'oreo13', 236, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo14', 'oreo14', 237, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo15', 'oreo15', 238, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo16', 'oreo16', 239, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo17', 'oreo17', 240, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo18', 'oreo18', 241, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo19', 'oreo19', 242, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo20', 'oreo20', 243, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo21', 'oreo21', 244, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo22', 'oreo22', 245, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo23', 'oreo23', 246, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo24', 'oreo24', 247, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo25', 'oreo25', 248, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo26', 'oreo26', 249, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo27', 'oreo27', 250, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo28', 'oreo28', 251, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo29', 'oreo29', 252, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo30', 'oreo30', 253, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo31', 'oreo31', 254, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo32', 'oreo32', 255, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo33', 'oreo33', 256, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo34', 'oreo34', 257, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo35', 'oreo35', 258, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo36', 'oreo36', 259, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo37', 'oreo37', 260, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo38', 'oreo38', 261, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo39', 'oreo39', 262, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo40', 'oreo40', 263, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo41', 'oreo41', 264, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo42', 'oreo42', 265, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo43', 'oreo43', 266, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo44', 'oreo44', 267, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo45', 'oreo45', 268, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo46', 'oreo46', 269, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo47', 'oreo47', 270, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo48', 'oreo48', 271, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo49', 'oreo49', 272, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo50', 'oreo50', 273, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo51', 'oreo51', 274, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo52', 'oreo52', 275, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo53', 'oreo53', 276, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo54', 'oreo54', 277, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo55', 'oreo55', 278, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo56', 'oreo56', 279, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo57', 'oreo57', 280, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo58', 'oreo58', 281, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo59', 'oreo59', 282, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo60', 'oreo60', 283, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo61', 'oreo61', 284, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo62', 'oreo62', 285, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo63', 'oreo63', 286, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo64', 'oreo64', 287, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo65', 'oreo65', 288, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo66', 'oreo66', 289, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo67', 'oreo67', 290, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo68', 'oreo68', 291, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo69', 'oreo69', 292, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo70', 'oreo70', 293, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo71', 'oreo71', 294, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo72', 'oreo72', 295, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo73', 'oreo73', 296, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo74', 'oreo74', 297, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo75', 'oreo75', 298, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo76', 'oreo76', 299, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo77', 'oreo77', 300, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo78', 'oreo78', 301, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo79', 'oreo79', 302, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo80', 'oreo80', 303, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo81', 'oreo81', 304, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo82', 'oreo82', 305, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo83', 'oreo83', 306, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo84', 'oreo84', 307, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo85', 'oreo85', 308, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo86', 'oreo86', 309, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo87', 'oreo87', 310, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo88', 'oreo88', 311, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo89', 'oreo89', 312, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo90', 'oreo90', 313, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo91', 'oreo91', 314, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo92', 'oreo92', 315, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo93', 'oreo93', 316, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo94', 'oreo94', 317, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo95', 'oreo95', 318, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo96', 'oreo96', 319, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo97', 'oreo97', 320, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo98', 'oreo98', 321, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo99', 'oreo99', 322, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo100', 'oreo100', 323, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo101', 'oreo101', 324, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo102', 'oreo102', 325, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo103', 'oreo103', 326, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo106', 'oreo106', 327, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo107', 'oreo107', 328, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo108', 'oreo108', 329, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo109', 'oreo109', 330, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo110', 'oreo110', 331, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo111', 'oreo111', 332, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo112', 'oreo112', 333, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo113', 'oreo113', 334, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo114', 'oreo114', 335, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo115', 'oreo115', 336, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo116', 'oreo116', 337, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo117', 'oreo117', 338, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo118', 'oreo118', 339, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo119', 'oreo119', 340, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo120', 'oreo120', 341, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo121', 'oreo121', 342, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo122', 'oreo122', 343, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo123', 'oreo123', 344, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo124', 'oreo124', 345, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo125', 'oreo125', 346, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo126', 'oreo126', 347, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo127', 'oreo127', 348, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo128', 'oreo128', 349, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo129', 'oreo129', 350, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo163', 'oreo163', 351, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo164', 'oreo164', 352, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo165', 'oreo165', 353, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo166', 'oreo166', 354, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo173', 'oreo173', 355, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo174', 'oreo174', 356, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo175', 'oreo175', 357, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo176', 'oreo176', 358, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo177', 'oreo177', 359, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo178', 'oreo178', 360, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo179', 'oreo179', 361, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo180', 'oreo180', 362, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'oreo181', 'oreo181', 363, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tiki1', 'tiki1', 364, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tiki2', 'tiki2', 365, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tiki3', 'tiki3', 366, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tiki4', 'tiki4', 367, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tiki5', 'tiki5', 368, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tiki6', 'tiki6', 369, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tiki7', 'tiki7', 370, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tiki8', 'tiki8', 371, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'tiki9', 'tiki9', 372, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'lu1', 'lu1', 373, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'lu2', 'lu2', 374, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'lu3', 'lu3', 375, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'lu4', 'lu4', 376, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'le1', 'le1', 377, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'le2', 'le2', 378, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'fu1', 'fu1', 379, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'fu2', 'fu2', 380, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate21', 'colgate21', 20, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate22', 'colgate22', 21, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate23', 'colgate23', 22, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate24', 'colgate24', 23, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate25', 'colgate25', 24, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate26', 'colgate26', 25, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate27', 'colgate27', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate28', 'colgate28', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate29', 'colgate29', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate30', 'colgate30', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate31', 'colgate31', 30, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate32', 'colgate32', 31, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate33', 'colgate33', 32, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate34', 'colgate34', 33, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate35', 'colgate35', 34, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate36', 'colgate36', 35, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate37', 'colgate37', 36, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate38', 'colgate38', 37, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate39', 'colgate39', 38, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate40', 'colgate40', 39, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate41', 'colgate41', 40, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate42', 'colgate42', 41, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate43', 'colgate43', 42, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate44', 'colgate44', 43, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate45', 'colgate45', 44, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate46', 'colgate46', 45, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate47', 'colgate47', 46, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate48', 'colgate48', 47, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate49', 'colgate49', 48, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate50', 'colgate50', 49, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate51', 'colgate51', 50, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate52', 'colgate52', 51, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate53', 'colgate53', 52, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate54', 'colgate54', 53, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate55', 'colgate55', 54, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate56', 'colgate56', 55, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate57', 'colgate57', 56, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate58', 'colgate58', 57, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate59', 'colgate59', 58, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate60', 'colgate60', 59, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate61', 'colgate61', 60, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate62', 'colgate62', 61, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate63', 'colgate63', 62, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate64', 'colgate64', 63, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate65', 'colgate65', 64, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate66', 'colgate66', 65, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate67', 'colgate67', 66, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate68', 'colgate68', 67, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate69', 'colgate69', 68, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate70', 'colgate70', 69, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate71', 'colgate71', 70, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate72', 'colgate72', 71, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate73', 'colgate73', 72, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate74', 'colgate74', 73, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate75', 'colgate75', 74, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate76', 'colgate76', 75, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate77', 'colgate77', 76, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate78', 'colgate78', 77, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate79', 'colgate79', 78, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate80', 'colgate80', 79, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate81', 'colgate81', 80, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate82', 'colgate82', 81, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'ynby1', 'ynby1', 82, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'ynby2', 'ynby2', 83, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'ynby3', 'ynby3', 84, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'darlie1', 'darlie1', 85, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'darlie2', 'darlie2', 86, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'darlie3', 'darlie3', 87, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'darlie4', 'darlie4', 88, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'systema1', 'systema1', 89, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'systema2', 'systema2', 90, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'systema3', 'systema3', 91, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'systema4', 'systema4', 92, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'crest1', 'crest1', 93, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'crest2', 'crest2', 94, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'crest3', 'crest3', 95, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'crest4', 'crest4', 96, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'sensodyne1', 'sensodyne1', 97, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'sensodyne2', 'sensodyne2', 98, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'sensodyne3', 'sensodyne3', 99, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'sensodyne4', 'sensodyne4', 100, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'others1', 'others1', 101, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'others2', 'others2', 102, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'others3', 'others3', 103, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'others4', 'others4', 104, now());
	END IF;
END//

DELIMITER ;
	
CALL InsertGoodsSkuDatas();

DROP PROCEDURE IF EXISTS CheckTableExist;
DROP PROCEDURE IF EXISTS CheckColumnExist;
DROP PROCEDURE IF EXISTS CheckIndexExist;
DROP PROCEDURE IF EXISTS CheckConstraintExist;
DROP PROCEDURE IF EXISTS CheckPrimaryKeyExist;
DROP PROCEDURE IF EXISTS CheckDataExist;
DROP PROCEDURE IF EXISTS InsertGoodsSkuDatas;
