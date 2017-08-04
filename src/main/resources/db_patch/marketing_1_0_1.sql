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
DROP PROCEDURE IF EXISTS AlterTable;
DROP PROCEDURE IF EXISTS CreateAdminPrivileges;
DROP PROCEDURE IF EXISTS AlterServiceTable;
DROP PROCEDURE IF EXISTS AddData;

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
CREATE PROCEDURE AlterTable()
BEGIN
	SET @ret = 0;
	CALL CheckTableExist("task", @ret);
	IF @ret = 1 THEN 
		ALTER TABLE task ADD COLUMN `host` VARCHAR(50) DEFAULT NULL;
		ALTER TABLE task ADD COLUMN `need_stitch` INT(11) DEFAULT '1' COMMENT '是否去重,默认为去重';
		ALTER TABLE task ADD COLUMN `goods_info` text;
	END IF;
END//

DELIMITER //
CREATE PROCEDURE AlterServiceTable()
BEGIN
	SET @ret = 0;
	CALL CheckTableExist("admin_service_apply", @ret);
	IF @ret = 1 THEN 
		ALTER TABLE admin_service_apply ADD COLUMN `username` VARCHAR(128) NOT NULL;
		ALTER TABLE admin_service_apply ADD COLUMN `email` VARCHAR(128) NOT NULL;
		ALTER TABLE admin_service_apply ADD COLUMN `reject_reason` VARCHAR(256) NOT NULL;
	END IF;
END//



DELIMITER //
CREATE PROCEDURE AddData()
BEGIN
	SET @ret = 0;
	CALL CheckTableExist("privilege", @ret);
	IF @ret = 1 THEN 
		INSERT INTO `privilege` (`id`, `parent_id`, `item_name`, `item_value`, `description`, `display_order`, `create_time`) VALUES ('3', NULL, '数据导出', '/export', '数据导出一级菜单', '3', now());
		INSERT INTO `role_privilege_mapping` (`id`, `role_id`, `privilege_id`, `create_time`) VALUES ('3', '1', '3', now());
	END IF;
END//


DELIMITER //
CREATE PROCEDURE CreateAdminPrivileges()
BEGIN
	SET @ret = 0;
	CALL CheckDataExist("admin_privilege", "id=1", @ret);
	IF @ret = 0 THEN
		INSERT INTO `admin_privilege`(`id`, `parent_id`, `item_name`, `item_value`, `description`, `display_order`, `create_time`) VALUES (1, NULL, '服务申请', '/admin/service/apply', '服务申请一级菜单', 1, now());
        INSERT INTO `admin_privilege`(`id`, `parent_id`, `item_name`, `item_value`, `description`, `display_order`, `create_time`) VALUES (2, NULL, '服务管理', '/admin/service/manage', '服务管理一级菜单', 2, now());
        INSERT INTO `admin_privilege`(`id`, `parent_id`, `item_name`, `item_value`, `description`, `display_order`, `create_time`) VALUES (3, NULL, '主类型配置', '/admin/majortype', '主类型配置一级菜单', 3, now());
        INSERT INTO `admin_privilege`(`id`, `parent_id`, `item_name`, `item_value`, `description`, `display_order`, `create_time`) VALUES (4, NULL, 'SKU配置', '/admin/sku', 'SKU配置一级菜单', 4, now());
        INSERT INTO `admin_privilege`(`id`, `parent_id`, `item_name`, `item_value`, `description`, `display_order`, `create_time`) VALUES (5, NULL, '用户管理', '/admin/user', '用户管理一级菜单', 5, now());
        INSERT INTO `admin_privilege`(`id`, `parent_id`, `item_name`, `item_value`, `description`, `display_order`, `create_time`) VALUES (6, NULL, '调用统计', '/admin/calling', '调用统计一级菜单', 6, now());

        INSERT INTO `admin_user`(`id`, `username`,`password`, `email`, `name`, `create_time`) VALUES (1, 'admin', '5e13b0e702535b199b9063e60eaf5a909514d9ee25c3242f7ae8d362c945d25b000000142e10f370266e33794eb4dca6bf067e6c13cdced803e54f2e78ca15e2e9492bfb', 'jifeng@tunicorn.cn', '后台管理员', now());
        INSERT INTO `admin_user`(`id`, `username`,`password`, `email`, `name`, `create_time`) VALUES (2, 'applyAdmin', '5e13b0e702535b199b9063e60eaf5a909514d9ee25c3242f7ae8d362c945d25b000000142e10f370266e33794eb4dca6bf067e6c13cdced803e54f2e78ca15e2e9492bfb', 'jifeng@tunicorn.cn', '服务申请管理员', now());

        INSERT INTO `admin_role`(`id`, `name`, `description`, `create_time`) VALUES (1, 'admin', '后台管理员', now());
        INSERT INTO `admin_role`(`id`, `name`, `description`, `create_time`) VALUES (2, 'applyAdmin', '服务申请管理员', now());
        INSERT INTO `admin_user_role_mapping`(`id`, `user_id`,`role_id`, `create_time`) VALUES (1, 1, 1, now());
        INSERT INTO `admin_user_role_mapping`(`id`, `user_id`,`role_id`, `create_time`) VALUES (2, 2, 2, now());
        
        INSERT INTO `admin_role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (1, 2, 1, now());
        INSERT INTO `admin_role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (2, 1, 2, now());
        INSERT INTO `admin_role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (3, 1, 3, now());
        INSERT INTO `admin_role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (4, 1, 4, now());
        INSERT INTO `admin_role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (5, 1, 5, now());
        INSERT INTO `admin_role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (6, 1, 6, now());
	END IF;
END//


DELIMITER ;
	
CALL AlterTable();
CALL CreateAdminPrivileges();
CALL AlterServiceTable();
CALL AddData();

DROP PROCEDURE IF EXISTS CheckTableExist;
DROP PROCEDURE IF EXISTS CheckColumnExist;
DROP PROCEDURE IF EXISTS CheckIndexExist;
DROP PROCEDURE IF EXISTS CheckConstraintExist;
DROP PROCEDURE IF EXISTS CheckPrimaryKeyExist;
DROP PROCEDURE IF EXISTS CheckDataExist;
DROP PROCEDURE IF EXISTS AlterTable;
DROP PROCEDURE IF EXISTS CreateAdminPrivileges;
DROP PROCEDURE IF EXISTS AlterServiceTable;
DROP PROCEDURE IF EXISTS AddData;