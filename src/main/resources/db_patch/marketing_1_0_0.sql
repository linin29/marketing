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
DROP PROCEDURE IF EXISTS CreateMarketingTables;
DROP PROCEDURE IF EXISTS CreateInitialUser;
DROP PROCEDURE IF EXISTS CreatePrivileges;
DROP PROCEDURE IF EXISTS CreateAdminPrivileges;
DROP PROCEDURE IF EXISTS CreateApplication;
DROP PROCEDURE IF EXISTS CreateGoodsSku;

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
CREATE PROCEDURE CreateMarketingTables()
BEGIN
	SET @ret = 0;
	CALL CheckTableExist("user", @ret);
	IF @ret = 0 THEN
		CREATE TABLE IF NOT EXISTS `user` (
		  `id` varchar(40) NOT NULL,
		  `username` varchar(128) NOT NULL unique,
		  `password` varchar(256) NOT NULL,
		  `email` varchar(128) NOT NULL,
		  `name` varchar(256) DEFAULT NULL,
		  `create_time` datetime DEFAULT NULL,
		  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		  `status` enum('active','deleted','inactive') NOT NULL DEFAULT 'active',
		  PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;

		CREATE TABLE IF NOT EXISTS `user_ext` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `user_id` varchar(40) NOT NULL,
		  `item_name` varchar(256) NOT NULL,
		  `item_value` varchar(256) DEFAULT NULL,
		  `create_time` datetime DEFAULT NULL,
		  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		  `status` enum('active','deleted','inactive') NOT NULL DEFAULT 'active',
		  PRIMARY KEY (`id`),
		  KEY `user_user_ext_fk_idx` (`user_id`)
		) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

		CREATE TABLE IF NOT EXISTS `application` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `name` varchar(256) DEFAULT NULL,
		  `description` varchar(512) DEFAULT NULL,
		  `user_id` varchar(40) DEFAULT NULL,
		  `app_key` varchar(256) NOT NULL,
		  `app_secret` varchar(256) NOT NULL,
		  `privacy` enum('private','protected','public') DEFAULT 'private',
		  `create_time` datetime DEFAULT NULL,
		  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		  `status` enum('active','deleted','inactive') NOT NULL DEFAULT 'active',
		  PRIMARY KEY (`id`),
		  KEY `user_application_fk_idx` (`user_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;

		CREATE TABLE IF NOT EXISTS `api_calling_count` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `api_method` varchar(255) NOT NULL,
		  `api_name` varchar(255) NOT NULL,
		  `calling_day` date NOT NULL,
		  `user_name` varchar(255) NOT NULL,
		  `calling_times` int(11) DEFAULT 0,
		  `create_time` datetime DEFAULT NULL,
		  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		  `status` enum('active','deleted','inactive') DEFAULT 'active',
		  PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;

		CREATE TABLE IF NOT EXISTS `api_calling_detail` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `api_method` varchar(255) NOT NULL,
		  `api_name` varchar(255) NOT NULL,
		  `user_name` varchar(255) NOT NULL,
		  `calling_status` varchar(255) DEFAULT NULL,
		  `pictures` int(11) DEFAULT 0,
		  `create_time` datetime DEFAULT NULL,
		  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		  `status` enum('active','deleted','inactive') DEFAULT 'active',
		  PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;

		CREATE TABLE IF NOT EXISTS `task` (
		  `id` varchar(40) NOT NULL,
		  `name` varchar(255) NOT NULL,
		  `task_status` varchar(255) DEFAULT NULL,
		  `user_id` varchar(40) NOT NULL,
		  `create_time` datetime DEFAULT NULL,
		  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		  `status` enum('active','deleted','inactive') DEFAULT 'active',
		  `stitch_image_path` varchar(255) DEFAULT NULL,
          `result` text,
          `rows` varchar(100) DEFAULT NULL,
          `major_type` varchar(20) DEFAULT NULL,
		  `host` varchar(50) DEFAULT NULL,
		  `need_stitch` int(11) DEFAULT '1' COMMENT '是否去重,默认为去重',
		  PRIMARY KEY (`id`),
		  KEY `user_task_fk_idx` (`user_id`),
		  KEY `idx_task_name` (`name`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;

		CREATE TABLE IF NOT EXISTS `task_images` (
		  `id` varchar(40) NOT NULL,
		  `name` varchar(255) NOT NULL,
		  `task_id` varchar(40) NOT NULL,
		  `user_id` varchar(40) NOT NULL,
		  `order_no` int(11) DEFAULT 0,
		  `image_path` varchar(255) DEFAULT NULL,
		  `full_path` varchar(255) DEFAULT NULL,
		  `create_time` datetime DEFAULT NULL,
		  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		  `status` enum('active','deleted','inactive') DEFAULT 'active',
		  PRIMARY KEY (`id`),
		  KEY `user_task_fk_idx` (`user_id`),
		  KEY `task_image_fk_idx` (`task_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		
		CREATE TABLE IF NOT EXISTS `token` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `app_id` int(11) NOT NULL,
		  `user_id` varchar(40) NOT NULL,
		  `client_id` varchar(256) NOT NULL,
		  `access_token` varchar(256) NOT NULL,
		  `expires_time` bigint(11) DEFAULT NULL,
		  `create_time` datetime DEFAULT NULL,
		  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		  `status` enum('active','deleted','inactive') NOT NULL DEFAULT 'active',
		  PRIMARY KEY (`id`),
		  KEY `token_fk_idx` (`access_token`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
      
      CREATE TABLE IF NOT EXISTS `privilege` (
       `id` int(11) NOT NULL AUTO_INCREMENT,
       `parent_id` int(11) DEFAULT NULL,
       `item_name` varchar(128) NOT NULL COMMENT 'for menu type, its value is menu name',
       `item_value` varchar(256) DEFAULT NULL COMMENT 'for menu type, its value is menu url',
       `description` varchar(512) DEFAULT NULL,
       `display_order` int(11) DEFAULT NULL,
       `create_time` datetime DEFAULT NULL,
       `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
       `status` enum('active','deleted','inactive') NOT NULL DEFAULT 'active',
       PRIMARY KEY (`id`)
     ) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
     
     CREATE TABLE IF NOT EXISTS `role` (
		`id` INT(11) NOT NULL AUTO_INCREMENT,
		`name` VARCHAR(128) NOT NULL,
		`description` VARCHAR(512) DEFAULT NULL,
		`create_time` DATETIME DEFAULT NULL,
		`last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		`status` ENUM('active','deleted','inactive') NOT NULL DEFAULT 'active',
		PRIMARY KEY (`id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;

	CREATE TABLE IF NOT EXISTS `role_privilege_mapping` (
		`id` INT(11) NOT NULL AUTO_INCREMENT,
		`role_id` INT(11) NOT NULL,
		`privilege_id` INT(11) NOT NULL,
		`create_time` DATETIME DEFAULT NULL,
		`last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		`status` ENUM('active','deleted','inactive') NOT NULL DEFAULT 'active',
		PRIMARY KEY (`id`),
		INDEX `role_role_privilege_mapping_fk_idx` (`role_id` ASC),
		INDEX `privilege_role_privilege_mapping_fk_idx` (`privilege_id` ASC)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;

	CREATE TABLE IF NOT EXISTS `user_role_mapping` (
		`id` INT(11) NOT NULL AUTO_INCREMENT,
		`user_id` varchar(40) NOT NULL,
		`role_id` INT(11) NOT NULL,
		`create_time` DATETIME DEFAULT NULL,
		`last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		`status` ENUM('active','deleted','inactive') NOT NULL DEFAULT 'active',
		PRIMARY KEY (`id`),
		INDEX `user_user_role_mapping_fk_idx` (`user_id` ASC),
		INDEX `role_user_role_mapping_fk_idx` (`role_id` ASC)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	
	CREATE TABLE IF NOT EXISTS `major_type` (
	    `id` INT(11) NOT NULL AUTO_INCREMENT,
		`name` VARCHAR(128) NOT NULL,
		`description` VARCHAR(512) DEFAULT NULL,
		`create_time` DATETIME DEFAULT NULL,
		`last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		`status` ENUM('active','deleted','inactive') NOT NULL DEFAULT 'active',
		PRIMARY KEY (`id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	
	CREATE TABLE IF NOT EXISTS `goods_sku` (
	    `id` INT(11) NOT NULL AUTO_INCREMENT,
		`major_type` VARCHAR(128) NOT NULL,
		`name` VARCHAR(128) NOT NULL unique,
		`description` VARCHAR(512) DEFAULT NULL,
		`order` INT(11) NOT NULL,
		`is_show` TINYINT(1) DEFAULT '1',
		`create_time` DATETIME DEFAULT NULL,
		`last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		`status` ENUM('active','deleted','inactive') NOT NULL DEFAULT 'active',
		PRIMARY KEY (`id`),
		KEY `idx_major_type` (`major_type`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	
	CREATE TABLE IF NOT EXISTS `admin_user` (
		`id` INT(11) NOT NULL AUTO_INCREMENT,
		`username` varchar(128) NOT NULL unique,
		`password` varchar(256) NOT NULL,
		`email` varchar(128) NOT NULL,
		`name` varchar(256) DEFAULT NULL,
		`create_time` datetime DEFAULT NULL,
		`last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		`status` enum('active','deleted','inactive') NOT NULL DEFAULT 'active',
		PRIMARY KEY (`id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	
     CREATE TABLE IF NOT EXISTS `admin_role` (
		`id` INT(11) NOT NULL AUTO_INCREMENT,
		`name` VARCHAR(128) NOT NULL,
		`description` VARCHAR(512) DEFAULT NULL,
		`create_time` DATETIME DEFAULT NULL,
		`last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		`status` ENUM('active','deleted','inactive') NOT NULL DEFAULT 'active',
		PRIMARY KEY (`id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	
	CREATE TABLE IF NOT EXISTS `admin_privilege` (
       `id` int(11) NOT NULL AUTO_INCREMENT,
       `parent_id` int(11) DEFAULT NULL,
       `item_name` varchar(128) NOT NULL COMMENT 'for menu type, its value is menu name',
       `item_value` varchar(256) DEFAULT NULL COMMENT 'for menu type, its value is menu url',
       `description` varchar(512) DEFAULT NULL,
       `display_order` int(11) DEFAULT NULL,
       `create_time` datetime DEFAULT NULL,
       `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
       `status` enum('active','deleted','inactive') NOT NULL DEFAULT 'active',
       PRIMARY KEY (`id`)
     ) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

	CREATE TABLE IF NOT EXISTS `admin_role_privilege_mapping` (
		`id` INT(11) NOT NULL AUTO_INCREMENT,
		`role_id` INT(11) NOT NULL,
		`privilege_id` INT(11) NOT NULL,
		`create_time` DATETIME DEFAULT NULL,
		`last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		`status` ENUM('active','deleted','inactive') NOT NULL DEFAULT 'active',
		PRIMARY KEY (`id`),
		INDEX `admin_role_admin_role_privilege_mapping_fk_idx` (`role_id` ASC),
		INDEX `admin_privilege_role_privilege_mapping_fk_idx` (`privilege_id` ASC)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;

	CREATE TABLE IF NOT EXISTS `admin_user_role_mapping` (
		`id` INT(11) NOT NULL AUTO_INCREMENT,
		`user_id` varchar(40) NOT NULL,
		`role_id` INT(11) NOT NULL,
		`create_time` DATETIME DEFAULT NULL,
		`last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		`status` ENUM('active','deleted','inactive') NOT NULL DEFAULT 'active',
		PRIMARY KEY (`id`),
		INDEX `admin_user_admin_user_role_mapping_fk_idx` (`user_id` ASC),
		INDEX `admin_role_admin_user_role_mapping_fk_idx` (`role_id` ASC)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	
	CREATE TABLE IF NOT EXISTS `admin_service_apply` (
		`id` INT(11) NOT NULL AUTO_INCREMENT,
		`user_id` INT(11) NOT NULL,
		`app_business_name` varchar(128) NOT NULL,
		`app_business_address` varchar(256) NOT NULL,
		`app_business_mobile` varchar(20) NOT NULL,
		`app_business_contacts` varchar(128) NOT NULL,
		`max_call_number` INT(20) NOT NULL,
		`creator_id` INT(11) NOT NULL,
		`create_time` DATETIME DEFAULT NULL,
		`apply_status` ENUM('created','opened','rejected') NOT NULL DEFAULT 'created',
		`last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		`status` ENUM('active','deleted','inactive') NOT NULL DEFAULT 'active',
		PRIMARY KEY (`id`),
		INDEX `application_business_name_idx` (`app_business_name`),
		INDEX `apply_status_idx` (`apply_status`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	
	CREATE TABLE IF NOT EXISTS `admin_service_apply_asset` (
		`id` INT(11) NOT NULL AUTO_INCREMENT,
		`service_apply_id` INT(11) NOT NULL,
		`display_name` varchar(512) NOT NULL,
		`file_path` varchar(512) NOT NULL,
        `file_ext` varchar(64) DEFAULT NULL,
        `file_size` int(11) DEFAULT NULL,
		`create_time` DATETIME DEFAULT NULL,
		`last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		`status` ENUM('active','deleted','inactive') NOT NULL DEFAULT 'active',
		PRIMARY KEY (`id`),
		INDEX `service_apply_id_idx` (`service_apply_id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	
	CREATE TABLE IF NOT EXISTS `major_type_application_mapping` (
		`id` INT(11) NOT NULL AUTO_INCREMENT,
		`major_type_id` INT(11) NOT NULL,
		`app_id` INT(11) NOT NULL,
		`create_time` DATETIME DEFAULT NULL,
		`last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		`status` ENUM('active','deleted','inactive') NOT NULL DEFAULT 'active',
		PRIMARY KEY (`id`),
		INDEX `major_type_id_idx` (`major_type_id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	
	CREATE TABLE IF NOT EXISTS `admin_major_type_service_apply_mapping` (
		`id` INT(11) NOT NULL AUTO_INCREMENT,
		`major_type_id` INT(11) NOT NULL,
		`service_apply_id` INT(11) NOT NULL,
		`create_time` DATETIME DEFAULT NULL,
		`last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		`status` ENUM('active','deleted','inactive') NOT NULL DEFAULT 'active',
		PRIMARY KEY (`id`),
		INDEX `major_type_id_idx` (`major_type_id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	
	END IF;
END//


DELIMITER //
CREATE PROCEDURE CreateInitialUser()
BEGIN
	SET @ret = 0;
	CALL CheckDataExist("user", "id=1", @ret);
	IF @ret = 0 THEN
		INSERT INTO `user`(`id`, `username`, `password`, `email`, `name`, `create_time`) VALUES ('577cb78b8d88b50b106ab973', 'tunicorn', 'd63aea1ae55798e293830943bdb22f2b3b604b45c8a85a9e3760a720f785958100000010f48be0b88f5970292ea26afd6fdf6f34880a1f1d5ca0c71057f47e486d5d81e9', 'tiannuo@tunicorn.cn', '管理员', now());
		INSERT INTO `user`(`id`, `username`, `password`, `email`, `name`, `create_time`) VALUES ('588574ecd0c7a62ad39e875d', 'tiannuoapi', '6a132cd9092571762e6b9632f93ff3eba290da09abf0bfdba2b12e55068a0ec5000000116367855e82e5e5d21e0b11fee1d2ec6720f3ea6ef65a32e0fa1c5db31ec5e173', 'tiannuo@tunicorn.cn', 'api', now());
		INSERT INTO `user`(`id`, `username`, `password`, `email`, `name`, `create_time`) VALUES ('58452689f8f6a9482c5151b2', 'tiannuo', '6a132cd9092571762e6b9632f93ff3eba290da09abf0bfdba2b12e55068a0ec5000000116367855e82e5e5d21e0b11fee1d2ec6720f3ea6ef65a32e0fa1c5db31ec5e173', 'tiannuo@tunicorn.cn', 'tiannuo', now());

		INSERT INTO `user_role_mapping`(`id`, `user_id`, `role_id`, `create_time`) VALUES (1, '577cb78b8d88b50b106ab973', 1, now());
		INSERT INTO `user_role_mapping`(`id`, `user_id`, `role_id`, `create_time`) VALUES (2, '588574ecd0c7a62ad39e875d', 1, now());
		INSERT INTO `user_role_mapping`(`id`, `user_id`, `role_id`, `create_time`) VALUES (3, '58452689f8f6a9482c5151b2', 1, now());
	END IF;
END//

DELIMITER //
CREATE PROCEDURE CreatePrivileges()
BEGIN
	SET @ret = 0;
	CALL CheckDataExist("privilege", "id=1", @ret);
	IF @ret = 0 THEN
		INSERT INTO `privilege`(`id`, `parent_id`, `item_name`, `item_value`, `description`, `display_order`, `create_time`) VALUES (1, NULL, '任务列表', '/task', '任务列表一级菜单', 1, now());
        INSERT INTO `privilege`(`id`, `parent_id`, `item_name`, `item_value`, `description`, `display_order`, `create_time`) VALUES (2, NULL, '调用统计', '/calling', '调用统计一级菜单', 2, now());
        
        INSERT INTO `role`(`id`, `name`, `description`, `create_time`) VALUES (1, 'admin', '管理员', now());
        
        INSERT INTO `role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (1, 1, 1, now());
        INSERT INTO `role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (2, 1, 2, now());
	END IF;
END//

DELIMITER //
CREATE PROCEDURE CreateApplication()
BEGIN
	SET @ret = 0;
	CALL CheckDataExist("application", "id=1", @ret);
	IF @ret = 0 THEN
		INSERT INTO `application`(`id`, `name`, `description`, `user_id`, `app_key`, `app_secret`, `privacy`, `create_time`) VALUES (1, 'tiannuo', '天诺应用', '588574ecd0c7a62ad39e875d', '4d3a2650-b54b-11e6-bdf3-13d45f19d90a','a3a70e4e-e490-402f-8d5e-f31d92be6ad8', 'public', now());
		INSERT INTO `application`(`id`, `name`, `description`, `user_id`, `app_key`, `app_secret`, `privacy`, `create_time`) VALUES ('2', 'tiannuo2', 'tiannuo', '588574ecd0c7a62ad39e875d', '0502aef0-b54d-11e6-bdf3-13d45f19d90a', 'b7b74802-0622-4cf2-91b4-c4d26e8c8766', 'public', now());
	END IF;
END//

DELIMITER //
CREATE PROCEDURE CreateGoodsSku()
BEGIN
	SET @ret = 0;
	CALL CheckDataExist("major_type", "id=1", @ret);
	IF @ret = 0 THEN
		INSERT INTO `major_type`(`id`, `name`, `description`, `create_time`) VALUES (1, 'coffee', '咖啡', now());
		INSERT INTO `major_type`(`id`, `name`, `description`, `create_time`) VALUES (2, 'chocolate', '巧克力', now());
		INSERT INTO `major_type`(`id`, `name`, `description`, `create_time`) VALUES (3, 'beer', '啤酒', now());
		INSERT INTO `major_type`(`id`, `name`, `description`, `create_time`) VALUES (4, 'driedmilk', '奶粉', now());
		INSERT INTO `major_type`(`id`, `name`, `description`, `create_time`) VALUES (5, 'cookie', '饼干', now());
		
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (1, 'driedmilk', 'NESTLE Senior mainstream milk powder 400g pouch', '雀巢中老年营养奶粉400g', 0, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`,`create_time`) VALUES (2, 'driedmilk', 'NESTLE YinYang JianXin Senior mainstream Hi-Cal fish oil milk powder 800g tin', '雀巢怡养健心中老年高钙营养奶粉鱼油配方800g', 1, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (3, 'driedmilk', 'NESTLE YiYang JianXin Senior mainstream Hi-Cal fish oil milk powder 400g pouch', '雀巢怡养健心中老年高钙营养奶粉鱼油配方400g', 2, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (4, 'driedmilk', 'NESTLE YIYANG PRTCTSM-Aged&SrMPwdr 850g tin', '雀巢奶粉怡养益护因子高钙无蔗糖中老年奶粉850g', 3, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (5, 'driedmilk', 'NESPRAY Student milk powder 400g pouch', '雀巢中小学生儿童营养奶粉钙铁锌400g袋装', 4, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (6, 'driedmilk', 'NESPRAY Student milk powder 1000g tin', '雀巢中小学生儿童营养配方奶粉钙铁锌1000g听装', 5, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (7, 'driedmilk', 'Nestle ClclckAngeHiCaHiFe milk powder 400g pouch', '雀巢安骼高钙高铁成人奶粉400g', 6, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (8, 'driedmilk', 'Nestle ClclckAngeHiCaHiFe milk powder 800g tin', '雀巢安骼高钙高铁奶粉800g听装', 7, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (9, 'driedmilk', 'NESTLE Hi-Cal Nutrition milk powder 16*25g pouch', '雀巢高钙营养奶粉 成人奶粉 16x25g 袋装', 8, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (10, 'driedmilk', 'NESTLE Hi-Cal Nutrition milk powder 850g Tin', '雀巢高钙营养奶粉 成人奶粉 850g 听装', 9, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (11, 'driedmilk', 'NESPRAY FCMP 400g pouch', '雀巢全脂奶粉400g', 10, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (12, 'driedmilk', 'NESPRAY FCMP  900g tin', '雀巢成人奶粉全脂奶粉900g听装', 11, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (13, 'driedmilk', 'NESTLE Family Nutrition Sweet milk powder 300g pouch', '雀巢全家营养甜奶粉300克袋装', 12, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (14, 'driedmilk', 'NESTLE YiYang Jianxin Gold2in1 Senior mainstream Hi-cal mik powder 800g tin', '雀巢怡养金装健心2合1中老年高钙营养奶粉800g', 13, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (15, 'driedmilk', 'Gift Package 1', '礼盒装1', 14, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (16, 'driedmilk', 'Gift Package 2', '礼盒装2', 15, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (17, 'driedmilk', 'Gift Package 3', '礼盒装3', 16, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `is_show`, `create_time`) VALUES (18, 'driedmilk', 'Nestle Others', '雀巢其他奶粉', 17, 0, now());
		
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (19, 'beer', 'Budweiser 600ML Bottle', 'Budweiser 600ML Bottle', 0, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (20, 'beer', 'Budweiser Beer 330ML Can', 'Budweiser Beer 330ML Can', 1, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (21, 'beer', 'Budweiser Beer 500ML Can', 'Budweiser Beer 500ML Can', 2, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (22, 'beer', 'Harbin Wheat 330ML Can', 'Harbin Wheat 330ML Can', 3, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (23, 'beer', 'Harbin ICE 500ML Can', 'Harbin ICE 500ML Can', 4, now());
		
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (24, 'coffee', 'NesCafe', 'NesCafe', 0, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (25, 'coffee', 'Maxwell', 'Maxwell', 1, now());
		
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (26, 'chocolate', 'BRK New 125g BLUE', 'BRK New 125g BLUE', 0, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (27, 'chocolate', 'BRK New 125g PFC', 'BRK New 125g PFC', 1, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (28, 'chocolate', 'BRK New Others', 'BRK New Others', 2, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (29, 'chocolate', 'Hello kitty black', 'Hello kitty black', 3, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (30, 'chocolate', 'Hello kitty blue', 'Hello kitty blue', 4, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (31, 'chocolate', 'Hello kitty red', 'Hello kitty red', 5, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (32, 'chocolate', 'HSY Bar 210g Almond', 'HSY Bar 210g Almond', 6, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (33, 'chocolate', 'HSY Bar 210g CNC', 'HSY Bar 210g CNC', 7, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (34, 'chocolate', 'HSY Bar 210g CNCH', 'HSY Bar 210g CNCH', 8, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (35, 'chocolate', 'HSY Bar 210g Dark', 'HSY Bar 210g Dark', 9, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (36, 'chocolate', 'HSY Bar 210g Milk', 'HSY Bar 210g Milk', 10, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (37, 'chocolate', 'HSY Bar 40g CNC', 'HSY Bar 40g CNC', 11, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (38, 'chocolate', 'HSY Bar 40g CNCH', 'HSY Bar 40g CNCH', 12, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (39, 'chocolate', 'HSY Bar 40g Dark', 'HSY Bar 40g Dark', 13, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (40, 'chocolate', 'HSY Bar 40g Milk', 'HSY Bar 40g Milk', 14, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (41, 'chocolate', 'HSY Drops 60g Almond', 'HSY Drops 60g Almond', 15, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (42, 'chocolate', 'HSY Drops 60g CNC', 'HSY Drops 60g CNC', 16, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (43, 'chocolate', 'HSY Drops 60g Milk', 'HSY Drops 60g Milk', 17, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (44, 'chocolate', 'HSY Drops 140g Almond', 'HSY Drops 140g Almond', 18, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (45, 'chocolate', 'HSY Drops 140g CNC', 'HSY Drops 140g CNC', 19, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (46, 'chocolate', 'HSY Drops 140g Milk', 'HSY Drops 140g Milk', 20, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (47, 'chocolate', 'Kisses 146g CNC', 'Kisses 146g CNC', 21, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (48, 'chocolate', 'Kisses 146g Dark', 'Kisses 146g Dark', 22, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (49, 'chocolate', 'Kisses 146g Dark Almond', 'Kisses 146g Dark Almond', 23, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (50, 'chocolate', 'Kisses 146g Dark Hazel', 'Kisses 146g Dark Hazel', 24, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (51, 'chocolate', 'Kisses 146g Milk', 'Kisses 146g Milk', 25, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (52, 'chocolate', 'HSY Gift Package', 'HSY Gift Package', 26, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (53, 'chocolate', 'HSY others', 'HSY others', 27, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (54, 'chocolate', 'Ferrero Rocher', 'Ferrero Rocher', 28, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (55, 'chocolate', 'Ferrero Rocher Kinder', 'Ferrero Rocher Kinder', 29, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (56, 'chocolate', 'MARS Crispy', 'MARS Crispy', 30, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (57, 'chocolate', 'MARS Dove', 'MARS Dove', 31, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (58, 'chocolate', 'MARS SNICKERS', 'MARS SNICKERS', 32, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (59, 'chocolate', "MARS M&M'S'", "MARS M&M'S'", 33, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (60, 'chocolate', 'Mondelez Milka', 'Mondelez Milka', 34, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (61, 'chocolate', 'BRK New 30g BLUE', 'BRK New 30g BLUE', 35, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (62, 'chocolate', 'BRK New 30g PFC', 'BRK New 30g PFC', 36, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (63, 'chocolate', 'Kisses 82g CNC', 'Kisses 82g CNC', 37, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (64, 'chocolate', 'Kisses 36g CNC', 'Kisses 36g CNC', 38, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (65, 'chocolate', 'Kisses 82g Dark', 'Kisses 82g Dark', 39, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (66, 'chocolate', 'Kisses 36g Dark', 'Kisses 36g Dark', 40, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (67, 'chocolate', 'Kisses 82g Dark Almond', 'Kisses 82g Dark Almond', 41, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (68, 'chocolate', 'Kisses 36g Dark Almond', 'Kisses 36g Dark Almond', 42, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (69, 'chocolate', 'Kisses 82g Dark Hazel', 'Kisses 82g Dark Hazel', 43, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (70, 'chocolate', 'Kisses 36g Dark Hazel', 'Kisses 36g Dark Hazel', 44, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (71, 'chocolate', 'Kisses 82g Milk', 'Kisses 82g Milk', 45, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (72, 'chocolate', 'Kisses 36g Milk', 'Kisses 36g Milk', 46, now());
		
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (73, 'cookie', 'Belvita Breakfast Bing 150g*24 M&C', 'Belvita Breakfast Bing 150g*24 M&C', 0, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (74, 'cookie', 'Belvita Breakfast Bing 300g*12 M&C', 'Belvita Breakfast Bing 300g*12 M&C', 1, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (75, 'cookie', 'Belvita Breakfast Bing 150g*24 N&H', 'Belvita Breakfast Bing 150g*24 N&H', 2, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (76, 'cookie', 'Belvita Breakfast Bing 300g*12 N&H', 'Belvita Breakfast Bing 300g*12 N&H', 3, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (77, 'cookie', 'Belvita Breakfast Bing 150g*24 MB', 'Belvita Breakfast Bing 150g*24 MB', 4, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (78, 'cookie', 'Belvita Breakfast Bing 300g*12 MB', 'Belvita Breakfast Bing 300g*12 MB', 5, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (79, 'cookie', 'BelVita Others', 'BelVita Others', 6, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (80, 'cookie', 'CA! Chunky Cookie 72g*24 Original flavor', 'CA! Chunky Cookie 72g*24 Original flavor', 7, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (81, 'cookie', 'CA! Chunky Cookie 216g*12 Original flavor', 'CA! Chunky Cookie 216g*12 Original flavor', 8, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (82, 'cookie', 'CA! Chunky Cookie 216g*12 Coffee', 'CA! Chunky Cookie 216g*12 Coffee', 9, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (83, 'cookie', 'CA! Chewy 80g*24 Original Cho', 'CA! Chewy 80g*24 Original Cho', 10, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (84, 'cookie', 'CA! Chewy 240g*12 Raisin', 'CA! Chewy 240g*12 Raisin', 11, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (85, 'cookie', 'CA! Chewy 240g*12 Original Cho', 'CA! Chewy 240g*12 Original Cho', 12, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (86, 'cookie', 'CA!-COOKIE-95G*24-ORI-SP', 'CA!-COOKIE-95G*24-ORI-SP', 13, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (87, 'cookie', 'CA!-COOKIE-285G*12-ORI-FP', 'CA!-COOKIE-285G*12-ORI-FP', 14, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (88, 'cookie', 'CA!-COOKIE-95G*24-COF-SP', 'CA!-COOKIE-95G*24-COF-SP', 15, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (89, 'cookie', 'CA!-COOKIE-285G*12-COF-FP', 'CA!-COOKIE-285G*12-COF-FP', 16, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (90, 'cookie', 'CA! Candy Blast 255g', 'CA! Candy Blast 255g', 17, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (91, 'cookie', 'Chips Ahoy Others', 'Chips Ahoy Others', 18, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (92, 'cookie', 'Oreo DF SDW 106g*24 Blueberry&Raspberry', 'Oreo DF SDW 106g*24 Blueberry&Raspberry', 19, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (93, 'cookie', 'Oreo DF SDW 318g*15 Blueberry&Raspberry', 'Oreo DF SDW 318g*15 Blueberry&Raspberry', 20, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (94, 'cookie', 'OREO SDW 130g*24 Original', 'OREO SDW 130g*24 Original', 21, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (95, 'cookie', 'OREO SDW 130g*24 Strawberry', 'OREO SDW 130g*24 Strawberry', 22, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (96, 'cookie', 'OREO SDW 130g*24 Chocolate', 'OREO SDW 130g*24 Chocolate', 23, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (97, 'cookie', 'OREO Icecream 106g*24 Green Tea', 'OREO Icecream 106g*24 Green Tea', 24, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (98, 'cookie', 'OREO Icecream 106g*24 Vanilla', 'OREO Icecream 106g*24 Vanilla', 25, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (99, 'cookie', 'OREO Icecream 318g*15 Green Tea', 'OREO Icecream 318g*15 Green Tea', 26, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (100, 'cookie', 'OREO Icecream 318g*15 Vanilla', 'OREO Icecream 318g*15 Vanilla', 27, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (101, 'cookie', 'OREO SDW 130g*24 Light Sweet', 'OREO SDW 130g*24 Light Sweet', 28, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (102, 'cookie', 'Golden Oreo single pack 106g*24 Chocolate', 'Golden Oreo single pack 106g*24 Chocolate', 29, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (103, 'cookie', 'Golden Oreo family pack 318g*15 Chocolate', 'Golden Oreo family pack 318g*15 Chocolate', 30, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (104, 'cookie', 'Golden Oreo single pack 106g*24 Strawberry', 'Golden Oreo single pack 106g*24 Strawberry', 31, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (105, 'cookie', 'Golden Oreo family pack 318g*15 Strawberry', 'Golden Oreo family pack 318g*15 Strawberry', 32, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (106, 'cookie', 'OREO SDW Portion Pack 10*3 (Original)', 'OREO SDW Portion Pack 10*3 (Original)', 33, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (107, 'cookie', 'OREO SDW Portion Pack 10*3 (Chocolate)', 'OREO SDW Portion Pack 10*3 (Chocolate)', 34, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (108, 'cookie', 'OREO SDW Portion Pack 10*3 (Strawberry)', 'OREO SDW Portion Pack 10*3 (Strawberry)', 35, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (109, 'cookie', 'OREO SDW Thin 104g*24 Lemon', 'OREO SDW Thin 104g*24 Lemon', 36, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (110, 'cookie', 'OREO SDW Thin 312g*15 Lemon', 'OREO SDW Thin 312g*15 Lemon', 37, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (111, 'cookie', 'OREO SDW Thin 104g*24 Vanilla Mousse', 'OREO SDW Thin 104g*24 Vanilla Mousse', 38, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (112, 'cookie', 'OREO SDW Thin 104g*24 Tiramisu', 'OREO SDW Thin 104g*24 Tiramisu', 39, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (113, 'cookie', 'OREO SDW Thin 312g*15 Vanilla Mousse', 'OREO SDW Thin 312g*15 Vanilla Mousse', 40, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (114, 'cookie', 'OREO SDW Thin 312g*15 Tiramisu', 'OREO SDW Thin 312g*15 Tiramisu', 41, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (115, 'cookie', 'Oreo DF SDW 318g*15 Grape+Peach', 'Oreo DF SDW 318g*15 Grape+Peach', 42, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (116, 'cookie', 'Oreo Birthday Cake Sandwich 106g*24', 'Oreo Birthday Cake Sandwich 106g*24', 43, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (117, 'cookie', 'Oreo Birthday Cake Sandwich 318g*15', 'Oreo Birthday Cake Sandwich 318g*15', 44, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (118, 'cookie', 'OREO SDW 520g family pack - Chocolate', 'OREO SDW 520g family pack - Chocolate', 45, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (119, 'cookie', 'OREO SDW 520g family pack - Light sweet', 'OREO SDW 520g family pack - Light sweet', 46, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (120, 'cookie', 'OREO SDW 520g family pack - Original', 'OREO SDW 520g family pack - Original', 47, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (121, 'cookie', 'OREO SDW 520g family pack - Strawberry', 'OREO SDW 520g family pack - Strawberry', 48, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (122, 'cookie', 'OREO SDW 260g single pack - Original', 'OREO SDW 260g single pack - Original', 49, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (123, 'cookie', 'OREO SDW 260g single pack - Light sweet', 'OREO SDW 260g single pack - Light sweet', 50, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (124, 'cookie', 'OREO SDW 260g single pack - Chocolate', 'OREO SDW 260g single pack - Chocolate', 51, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (125, 'cookie', 'OREO SDW 260g single pack - Strawberry', 'OREO SDW 260g single pack - Strawberry', 52, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (126, 'cookie', 'OREO Star 47g*24 Chocolate', 'OREO Star 47g*24 Chocolate', 53, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (127, 'cookie', 'OREO Star 47g*24 Tiramisu', 'OREO Star 47g*24 Tiramisu', 54, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (128, 'cookie', 'OREO Star 47g*24 Vanilla Mousse', 'OREO Star 47g*24 Vanilla Mousse', 55, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (129, 'cookie', 'OREO-FW-55G*24-CHO-SP(NPD07)', 'OREO-FW-55G*24-CHO-SP(NPD07)', 56, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (130, 'cookie', 'OREO-FW-55G*24-VAN-SP(NPD07)', 'OREO-FW-55G*24-VAN-SP(NPD07)', 57, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (131, 'cookie', 'Mini Oreo SDW 55g*24 Chocolate', 'Mini Oreo SDW 55g*24 Chocolate', 58, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (132, 'cookie', 'Mini Oreo SDW 55g*24 Ori', 'Mini Oreo SDW 55g*24 Ori', 59, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (133, 'cookie', 'Mini Oreo SDW 55g*24  Strawberry', 'Mini Oreo SDW 55g*24  Strawberry', 60, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (134, 'cookie', 'Coated wafer tiramisu 20s', 'Coated wafer tiramisu 20s', 61, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (135, 'cookie', 'OFW 14.5G*16*24Vani+ChocoFP', 'OFW 14.5G*16*24Vani+ChocoFP', 62, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (136, 'cookie', 'OFW 14.5g*16*24 Cho+Str FP', 'OFW 14.5g*16*24 Cho+Str FP', 63, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (137, 'cookie', 'OREO-COATED WF-12.8G*5*30-Original', 'OREO-COATED WF-12.8G*5*30-Original', 64, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (138, 'cookie', 'OREO-COATED WF-12.8G*20*24-Milk', 'OREO-COATED WF-12.8G*20*24-Milk', 65, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (139, 'cookie', 'OREO-COATED WF-12.8G*20*24-Mocha', 'OREO-COATED WF-12.8G*20*24-Mocha', 66, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (140, 'cookie', 'OREO-COATED WF-12.8G*20*24-Original', 'OREO-COATED WF-12.8G*20*24-Original', 67, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (141, 'cookie', 'Oreo Others', 'Oreo Others', 68, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (142, 'cookie', 'Oreo soft cookie 160g*16 Vanilla', 'Oreo soft cookie 160g*16 Vanilla', 69, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (143, 'cookie', 'Oreo soft cookie 160g*16 Strawberry', 'Oreo soft cookie 160g*16 Strawberry', 70, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (144, 'cookie', 'Oreo Soft Others', 'Oreo Soft Others', 71, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (145, 'cookie', 'PSODA-BASE-400G*12-SAL-FP', 'PSODA-BASE-400G*12-SAL-FP', 72, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (146, 'cookie', 'PSODA-BASE-400G*12-SES-FP', 'PSODA-BASE-400G*12-SES-FP', 73, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (147, 'cookie', 'PSODA-BASE-400G*12-SEA-FP', 'PSODA-BASE-400G*12-SEA-FP', 74, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (148, 'cookie', 'PSODA-BASE-400G*12-ONI-FP', 'PSODA-BASE-400G*12-ONI-FP', 75, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (149, 'cookie', 'Pacific Soda-300g*12-Salt', 'Pacific Soda-300g*12-Salt', 76, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (150, 'cookie', 'Pacific Soda-300g*12-Onion', 'Pacific Soda-300g*12-Onion', 77, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (151, 'cookie', 'Pacific Soda-100g*24-Salt-SP', 'Pacific Soda-100g*24-Salt-SP', 78, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (152, 'cookie', 'Pacific Soda-100g*24-Onion-SP', 'Pacific Soda-100g*24-Onion-SP', 79, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (153, 'cookie', 'Pacific Others', 'Pacific Others', 80, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (154, 'cookie', 'Prince Cookie 85g*48 Chocolate', 'Prince Cookie 85g*48 Chocolate', 81, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (155, 'cookie', 'Prince Others', 'Prince Others', 82, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (156, 'cookie', 'Tuc Original 90g', 'Tuc Original 90g', 83, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (157, 'cookie', 'Tuc Tomato flavor 90g', 'Tuc Tomato flavor 90g', 84, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (158, 'cookie', 'Tuc Beef flavor 90g', 'Tuc Beef flavor 90g', 85, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (159, 'cookie', 'Tuc Beef flavor 360g', 'Tuc Beef flavor 360g', 86, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (160, 'cookie', 'Tuc Tomato flavor 360g', 'Tuc Tomato flavor 360g', 87, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (161, 'cookie', 'Tuc Original 360g', 'Tuc Original 360g', 88, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (162, 'cookie', 'Tuc seaweed flavor 360g', 'Tuc seaweed flavor 360g', 89, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (163, 'cookie', 'TUC Original 260g portion pack', 'TUC Original 260g portion pack', 90, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (164, 'cookie', 'TUC Sandwich cheese flavor 80g', 'TUC Sandwich cheese flavor 80g', 91, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (165, 'cookie', 'TUC Sandwich cheese flavor 160g', 'TUC Sandwich cheese flavor 160g', 92, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (166, 'cookie', 'TUC Sandwich seaweed flavor 160g', 'TUC Sandwich seaweed flavor 160g', 93, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (167, 'cookie', 'Tuc Others', 'Tuc Others', 94, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (168, 'cookie', 'Uguan plain family pack 500g*10', 'Uguan plain family pack 500g*10', 95, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (169, 'cookie', 'Uguan plain single slug 100g*30', 'Uguan plain single slug 100g*30', 96, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (170, 'cookie', 'Uguan plain portion pack 300g*12', 'Uguan plain portion pack 300g*12', 97, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (171, 'cookie', 'Uguan SDW 130g*30 Milk', 'Uguan SDW 130g*30 Milk', 98, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (172, 'cookie', 'Uguan SDW 390g*10 Milk', 'Uguan SDW 390g*10 Milk', 99, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (173, 'cookie', 'Uguan Others', 'Uguan Others', 100, now());
		INSERT INTO `goods_sku`(`id`,`major_type`, `name`, `description`, `order`, `create_time`) VALUES (174, 'cookie', 'Mondelez Others', 'Mondelez Others', 101, now());
		
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
        
        INSERT INTO `admin_role`(`id`, `name`, `description`, `create_time`) VALUES (1, 'admin', '管理员', now());
        INSERT INTO `admin_user_role_mapping`(`id`, `user_id`,`role_id`, `create_time`) VALUES (1, 1, 1, now());
        
        INSERT INTO `admin_role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (1, 1, 1, now());
        INSERT INTO `admin_role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (2, 1, 2, now());
        INSERT INTO `admin_role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (3, 1, 3, now());
        INSERT INTO `admin_role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (4, 1, 4, now());
	END IF;
END//

DELIMITER ;

CALL CreateMarketingTables();
CALL CreateInitialUser();
CALL CreatePrivileges();
CALL CreateApplication();
CALL CreateGoodsSku();
CALL CreateAdminPrivileges();

DROP PROCEDURE IF EXISTS CheckTableExist;
DROP PROCEDURE IF EXISTS CheckColumnExist;
DROP PROCEDURE IF EXISTS CheckIndexExist;
DROP PROCEDURE IF EXISTS CheckConstraintExist;
DROP PROCEDURE IF EXISTS CheckPrimaryKeyExist;
DROP PROCEDURE IF EXISTS CheckDataExist;
DROP PROCEDURE IF EXISTS CreateMarketingTables;
DROP PROCEDURE IF EXISTS CreateInitialUser;
DROP PROCEDURE IF EXISTS CreatePrivileges;
DROP PROCEDURE IF EXISTS CreateApplication;
DROP PROCEDURE IF EXISTS CreateGoodsSku;
DROP PROCEDURE IF EXISTS CreateAdminPrivileges;
