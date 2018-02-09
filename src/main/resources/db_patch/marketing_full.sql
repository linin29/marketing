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
DROP PROCEDURE IF EXISTS CreateApplication;
DROP PROCEDURE IF EXISTS CreateGoodsSku;
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
CREATE PROCEDURE CreateMarketingTables()
BEGIN
	SET @ret = 0;
	CALL CheckTableExist("user", @ret);
	IF @ret = 0 THEN
		CREATE TABLE IF NOT EXISTS `user` (
		  `id` varchar(40) NOT NULL,
		  `username` varchar(128) NOT NULL unique,
		  `password` varchar(255) NOT NULL,
		  `email` varchar(128) NOT NULL,
		  `name` varchar(255) DEFAULT NULL,
		  `create_time` datetime DEFAULT NULL,
		  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		  `status` enum('active','deleted','inactive') NOT NULL DEFAULT 'active',
		  PRIMARY KEY (`id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;

		CREATE TABLE IF NOT EXISTS `user_ext` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `user_id` varchar(40) NOT NULL,
		  `item_name` varchar(255) NOT NULL,
		  `item_value` varchar(255) DEFAULT NULL,
		  `create_time` datetime DEFAULT NULL,
		  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		  `status` enum('active','deleted','inactive') NOT NULL DEFAULT 'active',
		  PRIMARY KEY (`id`),
		  KEY `user_user_ext_fk_idx` (`user_id`)
		) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

		CREATE TABLE IF NOT EXISTS `application` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `name` varchar(255) DEFAULT NULL,
		  `description` varchar(512) DEFAULT NULL,
		  `user_id` varchar(40) DEFAULT NULL,
		  `app_key` varchar(255) NOT NULL,
		  `app_secret` varchar(255) NOT NULL,
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
		  `project_id` varchar(40) DEFAULT NULL,
		  `store_code` varchar(40) DEFAULT NULL,
		  `major_type` varchar(20) DEFAULT NULL,
		  `calling_day` date NOT NULL,
		  `user_name` varchar(255) NOT NULL,
		  `calling_times` int(11) DEFAULT 0,
		  `create_time` datetime DEFAULT NULL,
		  `last_update` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		  `status` enum('active','deleted','inactive') DEFAULT 'active',
		  PRIMARY KEY (`id`),
		  KEY `user_api_calling_fk_idx` (`user_name`),
		  KEY `day_api_calling_fk_idx` (`calling_day`),
		  KEY `project_api_calling_fk_idx` (`project_id`),
		  KEY `store_api_calling_fk_idx` (`store_code`),
		  KEY `major_api_calling_fk_idx` (`major_type`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;

		CREATE TABLE IF NOT EXISTS `api_calling_detail` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `api_method` varchar(255) NOT NULL,
		  `api_name` varchar(255) NOT NULL,
		  `major_type` varchar(20) DEFAULT NULL,
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
          `result` mediumtext,
          `rows` varchar(100) DEFAULT NULL,
          `major_type` varchar(20) DEFAULT NULL,
          `project_id` varchar(40) DEFAULT NULL,
          `store_code` varchar(40) DEFAULT NULL,
          `host` VARCHAR(50) DEFAULT NULL,
          `need_stitch` INT(11) DEFAULT '1' COMMENT '是否去重,默认为去重',
          `goods_info` mediumtext,
          `identify_success_times` int(11) DEFAULT '0',
		  PRIMARY KEY (`id`),
		  KEY `user_task_fk_idx` (`user_id`),
		  KEY `task_status_task_fk_idx` (`task_status`),
		  KEY `host_task_fk_idx` (`host`),
		  KEY `create_time_task_fk_idx` (`create_time`),
		  KEY `status_task_fk_idx` (`status`),
		  KEY `major_type_task_fk_idx` (`major_type`),
		  KEY `idx_last_update` (`last_update`),
		  KEY `idx_task_name` (`name`),
		  KEY `project_task_fk_idx` (`project_id`),
		  KEY `store_task_fk_idx` (`store_code`)
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
		  `result` mediumtext,
		  PRIMARY KEY (`id`),
		  KEY `user_task_fk_idx` (`user_id`),
		  KEY `task_image_fk_idx` (`task_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		
		CREATE TABLE IF NOT EXISTS `token` (
		  `id` int(11) NOT NULL AUTO_INCREMENT,
		  `app_id` int(11) NOT NULL,
		  `user_id` varchar(40) NOT NULL,
		  `client_id` varchar(255) NOT NULL,
		  `access_token` varchar(255) NOT NULL,
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
       `item_value` varchar(255) DEFAULT NULL COMMENT 'for menu type, its value is menu url',
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
		`version` varchar(20) DEFAULT NULL,
		PRIMARY KEY (`id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	
	CREATE TABLE IF NOT EXISTS `goods_sku` (
	    `id` INT(11) NOT NULL AUTO_INCREMENT,
		`major_type` VARCHAR(128) NOT NULL,
		`name` VARCHAR(128) NOT NULL,
		`description` VARCHAR(512) DEFAULT NULL,
		`order` INT(11) NOT NULL DEFAULT '0',
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
		`password` varchar(255) NOT NULL,
		`email` varchar(128) NOT NULL,
		`name` varchar(255) DEFAULT NULL,
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
       `item_value` varchar(255) DEFAULT NULL COMMENT 'for menu type, its value is menu url',
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
		`user_id` INT(11),
  		`username` varchar(128) NOT NULL,
  		`email` varchar(128) NOT NULL,
		`creator_id` INT(11) NOT NULL,
		`project_id` varchar(40) DEFAULT NULL,
		`start_time` datetime DEFAULT NULL,
		`end_time` datetime DEFAULT NULL,
		`contracted_value` float DEFAULT NULL,
		`contracted_no`  varchar(20) DEFAULT NULL,
		`create_time` DATETIME DEFAULT NULL,
		`reject_reason` varchar(255) DEFAULT NULL,
		`apply_status` ENUM('created','opened','rejected', 'closed') NOT NULL DEFAULT 'created',
		`last_update` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		`status` ENUM('active','deleted','inactive') NOT NULL DEFAULT 'active',
		PRIMARY KEY (`id`),
		INDEX `project_service_apply_fk_idx` (`project_id`),
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
	
	CREATE TABLE IF NOT EXISTS `training_data` (
		`id` int(11) NOT NULL AUTO_INCREMENT,
		`major_type` varchar(50) NOT NULL,
		`image_path` varchar(255) NOT NULL,
		`file_path` varchar(255) NOT NULL,
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
	
	CREATE TABLE IF NOT EXISTS `task_dump` (
 		 `id` int(11) NOT NULL AUTO_INCREMENT,
 		 `name` varchar(255) NOT NULL,
 		 `result` text,
 		 `score` double(255,15) DEFAULT '0.000000000000000',
 		 `md5` varchar(255) DEFAULT NULL,
  		PRIMARY KEY (`id`)
	) ENGINE=InnoDB AUTO_INCREMENT=4116 DEFAULT CHARSET=utf8;
	
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
	  PRIMARY KEY (`id`),
	  KEY `project_reminder_fk_idx` (`project_id`)
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
        INSERT INTO `privilege`(`id`, `parent_id`, `item_name`, `item_value`, `description`, `display_order`, `create_time`) VALUES (3, NULL, '数据导出', '/export', '数据导出一级菜单', 3, now());
		INSERT INTO `privilege`(`id`, `parent_id`, `item_name`, `item_value`, `description`, `display_order`, `create_time`) VALUES (4, NULL, '批量任务', '/batch_import', '创建批量任务一级菜单', 4, now());
		INSERT INTO `privilege`(`id`, `parent_id`, `item_name`, `item_value`, `description`, `display_order`, `create_time`) VALUES (5, NULL, '文件上传', '/fileUpload', '文件上传一级菜单', 5, now());
        INSERT INTO `privilege`(`id`, `parent_id`, `item_name`, `item_value`, `description`, `display_order`, `create_time`) VALUES (6, NULL, '价格识别', '/priceIdentify', '价格识别一级菜单', 6, now());
        INSERT INTO `privilege`(`id`, `parent_id`, `item_name`, `item_value`, `description`, `display_order`, `create_time`) VALUES (7, NULL, '线下纠错', '/aec', '线下纠错一级菜单', 7, now());
        
		INSERT INTO `role`(`name`, `description`, `create_time`) VALUES ('admin', '管理员', now());
		INSERT INTO `role`(`name`, `description`, `create_time`) VALUES ('user', '普通用户', now());
        
        INSERT INTO `role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (1, 1, 1, now());
        INSERT INTO `role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (2, 1, 2, now());
        INSERT INTO `role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (3, 1, 3, now());
        INSERT INTO `role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (4, 1, 4, now());
		INSERT INTO `role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (5, 1, 5, now());
		INSERT INTO `role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (6, 1, 6, now());
		INSERT INTO `role_privilege_mapping`(`id`, `role_id`, `privilege_id`, `create_time`) VALUES (7, 1, 7, now());
		
		INSERT INTO `role_privilege_mapping`(`role_id`, `privilege_id`, `create_time`) VALUES (2, 1, now());
        INSERT INTO `role_privilege_mapping`(`role_id`, `privilege_id`, `create_time`) VALUES (2, 2, now());
        INSERT INTO `role_privilege_mapping`(`role_id`, `privilege_id`, `create_time`) VALUES (2, 3, now());
        
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
        
        INSERT INTO `admin_service_apply`(`id`, `user_id`, `username`, `email`, `creator_id`, `apply_status`, `create_time`) VALUES (1, 0, 'tiannuo', 'tiannuo@tunicorn.cn', '1', 'opened', now());
        INSERT INTO `admin_service_apply`(`id`, `user_id`, `username`, `email`, `creator_id`, `apply_status`, `create_time`) VALUES (2, 0, 'tunicorn', 'tunicorn@tunicorn.cn', '1', 'opened', now());
        INSERT INTO `admin_service_apply`(`id`, `user_id`, `username`, `email`, `creator_id`, `apply_status`, `create_time`) VALUES (3, 0, 'tiannuoapi', 'tiannuo@tunicorn.cn', '1', 'opened', now());
        
        INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (1, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (1, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (1, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (2, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (2, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (2, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (3, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (3, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (3, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (4, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (4, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (4, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (5, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (5, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (5, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (6, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (6, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (6, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (7, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (7, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (7, 3, now());
        
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
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (17, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (17, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (17, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (18, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (18, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (18, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (19, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (19, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (19, 3, now());
		
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (20, 1, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (20, 2, now());
		INSERT INTO `admin_major_type_service_apply_mapping`(`major_type_id`, `service_apply_id`, `create_time`) VALUES (20, 3, now());
	END IF;
END//

DELIMITER //
CREATE PROCEDURE CreateApplication()
BEGIN
	SET @ret = 0;
	CALL CheckDataExist("application", "id=1", @ret);
	IF @ret = 0 THEN
		INSERT INTO `application`(`name`, `description`, `user_id`, `app_key`, `app_secret`, `privacy`, `create_time`) VALUES ('tiannuo', '天诺应用', '588574ecd0c7a62ad39e875d', '4d3a2650-b54b-11e6-bdf3-13d45f19d90a','a3a70e4e-e490-402f-8d5e-f31d92be6ad8', 'public', now());
		INSERT INTO `application`(`name`, `description`, `user_id`, `app_key`, `app_secret`, `privacy`, `create_time`) VALUES ('tiannuo2', 'tiannuo', '588574ecd0c7a62ad39e875d', '0502aef0-b54d-11e6-bdf3-13d45f19d90a', 'b7b74802-0622-4cf2-91b4-c4d26e8c8766', 'public', now());
		INSERT INTO `application`(`name`, `description`, `user_id`, `app_key`, `app_secret`, `privacy`, `create_time`) VALUES ('tunicorn', 'tunicorn', '577cb78b8d88b50b106ab973', '4d3a2650-b54b-11e6-bdf3-13d45f19d123', 'a3a70e4e-e490-402f-8d5e-f31d92be6123', 'public', now());
	END IF;
END//

DELIMITER //
CREATE PROCEDURE CreateGoodsSku()
BEGIN
	SET @ret = 0;
	CALL CheckDataExist("major_type", "id=1", @ret);
	IF @ret = 0 THEN
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`, `status`) VALUES ('coffee', '咖啡', NULL, now(), 'deleted');
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`) VALUES ('chocolate', '巧克力', '2.0', now());
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`) VALUES ('beer', '啤酒', '9.0', now());
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`, `status`) VALUES ('driedmilk', '奶粉', '3.0', now(), 'deleted');
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`) VALUES ('cookie', '饼干', '6.0', now());
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`) VALUES ('extra', '口香糖', '4.0', now());
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`) VALUES ('colgate', '高露洁', '2.0', now());
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`) VALUES ('nielsennv', '尼尔森女性护理', '1.0', now());
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`) VALUES ('nielsendrink', '尼尔森饮料', '1.0', now());
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`, `status`) VALUES ('nestlemilk', '雀巢炼奶', '3.0', now(), 'deleted');
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`) VALUES ('nestlecoffee', '雀巢咖啡', '5.0', now());
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`, `status`) VALUES ('nestlemilkpowder', '雀巢奶粉', '3.0', now(), 'deleted');
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`, `status`) VALUES ('nestleoatmeal', '雀巢麦片', '3.0', now(), 'deleted');
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`, `status`) VALUES ('nestlericeflour', '雀巢营养品', '3.0', now(), 'deleted');
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`, `status`) VALUES ('nestlesugar', '雀巢糖果', '3.0', now(), 'deleted');
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`, `status`) VALUES ('nestlebiscuit', '雀巢饼干', '3.0', now(), 'deleted');
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`) VALUES ('nestlenutrition', '雀巢营养品', '1.0', now());
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`) VALUES ('nestleconfectionery', '雀巢糕点糖果', '1.0', now());
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`) VALUES ('nestledairy', '雀巢奶制品', '1.0', now());
		INSERT INTO `major_type`(`name`, `description`, `version`, `create_time`) VALUES ('nielsenchips', '尼尔森薯片', '4.0', now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('coffee', 'NesCafe', 'NesCafe', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('coffee', 'Maxwell', 'Maxwell', 1, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'BRK New 125g BLUE', 'BRK New 125g BLUE', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'BRK New 125g PFC', 'BRK New 125g PFC', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'BRK New Others', 'BRK New Others', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Hello kitty black', 'Hello kitty black', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Hello kitty blue', 'Hello kitty blue', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Hello kitty red', 'Hello kitty red', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Bar 210g Almond', 'HSY Bar 210g Almond', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Bar 210g CNC', 'HSY Bar 210g CNC', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Bar 210g CNCH', 'HSY Bar 210g CNCH', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Bar 210g Dark', 'HSY Bar 210g Dark', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Bar 210g Milk', 'HSY Bar 210g Milk', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Bar 40g CNC', 'HSY Bar 40g CNC', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Bar 40g CNCH', 'HSY Bar 40g CNCH', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Bar 40g Dark', 'HSY Bar 40g Dark', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Bar 40g Milk', 'HSY Bar 40g Milk', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Drops 60g Almond', 'HSY Drops 60g Almond', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Drops 60g CNC', 'HSY Drops 60g CNC', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Drops 60g Milk', 'HSY Drops 60g Milk', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Drops 140g Almond', 'HSY Drops 140g Almond', 18, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Drops 140g CNC', 'HSY Drops 140g CNC', 19, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Drops 140g Milk', 'HSY Drops 140g Milk', 20, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Kisses 146g CNC', 'Kisses 146g CNC', 21, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Kisses 146g Dark', 'Kisses 146g Dark', 22, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Kisses 146g Dark Almond', 'Kisses 146g Dark Almond', 23, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Kisses 146g Dark Hazel', 'Kisses 146g Dark Hazel', 24, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Kisses 146g Milk', 'Kisses 146g Milk', 25, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY Gift Package', 'HSY Gift Package', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'HSY others', 'HSY others', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Ferrero Rocher', 'Ferrero Rocher', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Ferrero Rocher Kinder', 'Ferrero Rocher Kinder', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'MARS Crispy', 'MARS Crispy', 30, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'MARS Dove', 'MARS Dove', 31, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'MARS SNICKERS', 'MARS SNICKERS', 32, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', "MARS M&M'S", "MARS M&M'S", 33, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Mondelez Milka', 'Mondelez Milka', 34, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'BRK New 30g BLUE', 'BRK New 30g BLUE', 35, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'BRK New 30g PFC', 'BRK New 30g PFC', 36, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Kisses 82g CNC', 'Kisses 82g CNC', 37, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Kisses 36g CNC', 'Kisses 36g CNC', 38, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Kisses 82g Dark', 'Kisses 82g Dark', 39, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Kisses 36g Dark', 'Kisses 36g Dark', 40, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Kisses 82g Dark Almond', 'Kisses 82g Dark Almond', 41, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Kisses 36g Dark Almond', 'Kisses 36g Dark Almond', 42, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Kisses 82g Dark Hazel', 'Kisses 82g Dark Hazel', 43, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Kisses 36g Dark Hazel', 'Kisses 36g Dark Hazel', 44, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Kisses 82g Milk', 'Kisses 82g Milk', 45, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('chocolate', 'Kisses 36g Milk', 'Kisses 36g Milk', 46, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'bass1', 'bass1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser1', 'budweiser1', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser2', 'budweiser2', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser3', 'budweiser3', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser4', 'budweiser4', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser5', 'budweiser5', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser6', 'budweiser6', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser7', 'budweiser7', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser8', 'budweiser8', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser9', 'budweiser9', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser10', 'budweiser10', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser11', 'budweiser11', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser12', 'budweiser12', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser13', 'budweiser13', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser14', 'budweiser14', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser15', 'budweiser15', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser16', 'budweiser16', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser17', 'budweiser17', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser18', 'budweiser18', 18, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser19', 'budweiser19', 19, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser20', 'budweiser20', 20, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser21', 'budweiser21', 21, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser22', 'budweiser22', 22, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser23', 'budweiser23', 23, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser24', 'budweiser24', 24, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser25', 'budweiser25', 25, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser26', 'budweiser26', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser27', 'budweiser27', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser28', 'budweiser28', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser29', 'budweiser29', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser30', 'budweiser30', 30, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser31', 'budweiser31', 31, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser32', 'budweiser32', 32, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser33', 'budweiser33', 33, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser34', 'budweiser34', 34, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser35', 'budweiser35', 35, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser36', 'budweiser36', 36, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser37', 'budweiser37', 37, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser38', 'budweiser38', 38, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser39', 'budweiser39', 39, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser40', 'budweiser40', 40, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser41', 'budweiser41', 41, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser42', 'budweiser42', 42, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser43', 'budweiser43', 43, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser44', 'budweiser44', 44, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser45', 'budweiser45', 45, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser46', 'budweiser46', 46, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser47', 'budweiser47', 47, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser48', 'budweiser48', 48, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser49', 'budweiser49', 49, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser50', 'budweiser50', 50, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser51', 'budweiser51', 51, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser52', 'budweiser52', 52, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'budweiser53', 'budweiser53', 53, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'boddington1', 'boddington1', 54, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'hoegaarden1', 'hoegaarden1', 55, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'hoegaarden2', 'hoegaarden2', 56, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'hoegaarden3', 'hoegaarden3', 57, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'hoegaarden4', 'hoegaarden4', 58, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin1', 'harbin1', 59, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin2', 'harbin2', 60, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin3', 'harbin3', 61, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin4', 'harbin4', 62, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin5', 'harbin5', 63, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin6', 'harbin6', 64, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin7', 'harbin7', 65, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin8', 'harbin8', 66, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin9', 'harbin9', 67, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin10', 'harbin10', 68, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin11', 'harbin11', 69, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin12', 'harbin12', 70, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin13', 'harbin13', 71, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin14', 'harbin14', 72, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin15', 'harbin15', 73, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin16', 'harbin16', 74, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin17', 'harbin17', 75, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin18', 'harbin18', 76, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin19', 'harbin19', 77, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin20', 'harbin20', 78, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin21', 'harbin21', 79, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin22', 'harbin22', 80, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin23', 'harbin23', 81, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin24', 'harbin24', 82, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin25', 'harbin25', 83, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin26', 'harbin26', 84, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin27', 'harbin27', 85, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin28', 'harbin28', 86, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin29', 'harbin29', 87, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin30', 'harbin30', 88, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin31', 'harbin31', 89, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin32', 'harbin32', 90, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin33', 'harbin33', 91, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin34', 'harbin34', 92, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin35', 'harbin35', 93, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin36', 'harbin36', 94, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin37', 'harbin37', 95, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin38', 'harbin38', 96, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin39', 'harbin39', 97, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin40', 'harbin40', 98, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin41', 'harbin41', 99, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin42', 'harbin42', 100, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin43', 'harbin43', 101, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin44', 'harbin44', 102, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin45', 'harbin45', 103, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin46', 'harbin46', 104, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin47', 'harbin47', 105, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin48', 'harbin48', 106, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin49', 'harbin49', 107, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin50', 'harbin50', 108, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin51', 'harbin51', 109, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin52', 'harbin52', 110, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin53', 'harbin53', 111, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin54', 'harbin54', 112, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin55', 'harbin55', 113, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin56', 'harbin56', 114, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin57', 'harbin57', 115, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin58', 'harbin58', 116, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin59', 'harbin59', 117, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin60', 'harbin60', 118, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin61', 'harbin61', 119, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin62', 'harbin62', 120, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin63', 'harbin63', 121, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin64', 'harbin64', 122, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin65', 'harbin65', 123, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin66', 'harbin66', 124, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin67', 'harbin67', 125, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin68', 'harbin68', 126, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin69', 'harbin69', 127, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'harbin70', 'harbin70', 128, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'corona1', 'corona1', 129, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'corona2', 'corona2', 130, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'corona3', 'corona3', 131, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('beer', 'corona4', 'corona4', 132, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'NESTLE Senior mainstream milk powder 400g pouch', '雀巢中老年营养奶粉400g', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'NESTLE YinYang JianXin Senior mainstream Hi-Cal fish oil milk powder 800g tin', '雀巢怡养健心中老年高钙营养奶粉鱼油配方800g', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'NESTLE YiYang JianXin Senior mainstream Hi-Cal fish oil milk powder 400g pouch', '雀巢怡养健心中老年高钙营养奶粉鱼油配方400g', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'NESTLE YIYANG PRTCTSM-Aged&SrMPwdr 850g tin', '雀巢奶粉怡养益护因子高钙无蔗糖中老年奶粉850g', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'NESPRAY Student milk powder 400g pouch', '雀巢中小学生儿童营养奶粉钙铁锌400g袋装', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'NESPRAY Student milk powder 1000g tin', '雀巢中小学生儿童营养配方奶粉钙铁锌1000g听装', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'Nestle ClclckAngeHiCaHiFe milk powder 400g pouch', '雀巢安骼高钙高铁成人奶粉400g', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'Nestle ClclckAngeHiCaHiFe milk powder 800g tin', '雀巢安骼高钙高铁奶粉800g听装', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'NESTLE Hi-Cal Nutrition milk powder 16*25g pouch', '雀巢高钙营养奶粉 成人奶粉 16x25g 袋装', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'NESTLE Hi-Cal Nutrition milk powder 850g Tin', '雀巢高钙营养奶粉 成人奶粉 850g 听装', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'NESPRAY FCMP 400g pouch', '雀巢全脂奶粉400g', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'NESPRAY FCMP  900g tin', '雀巢成人奶粉全脂奶粉900g听装', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'NESTLE Family Nutrition Sweet milk powder 300g pouch', '雀巢全家营养甜奶粉300克袋装', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'NESTLE YiYang Jianxin Gold2in1 Senior mainstream Hi-cal mik powder 800g tin', '雀巢怡养金装健心2合1中老年高钙营养奶粉800g', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'Gift Package 1', '礼盒装1', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'Gift Package 2', '礼盒装2', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('driedmilk', 'Gift Package 3', '礼盒装3', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `is_show`, `create_time`) VALUES ('driedmilk', 'Nestle Others', '雀巢其他奶粉', 17, 0, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Belvita Breakfast Bing 150g*24 M&C', 'Belvita Breakfast Bing 150g*24 M&C', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Belvita Breakfast Bing 300g*12 M&C', 'Belvita Breakfast Bing 300g*12 M&C', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Belvita Breakfast Bing 150g*24 N&H', 'Belvita Breakfast Bing 150g*24 N&H', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Belvita Breakfast Bing 300g*12 N&H', 'Belvita Breakfast Bing 300g*12 N&H', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Belvita Breakfast Bing 150g*24 MB', 'Belvita Breakfast Bing 150g*24 MB', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Belvita Breakfast Bing 300g*12 MB', 'Belvita Breakfast Bing 300g*12 MB', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'BelVita Others', 'BelVita Others', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'CA! Chunky Cookie 72g*24 Original flavor', 'CA! Chunky Cookie 72g*24 Original flavor', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'CA! Chunky Cookie 216g*12 Original flavor', 'CA! Chunky Cookie 216g*12 Original flavor', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'CA! Chunky Cookie 216g*12 Coffee', 'CA! Chunky Cookie 216g*12 Coffee', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'CA! Chewy 80g*24 Original Cho', 'CA! Chewy 80g*24 Original Cho', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'CA! Chewy 240g*12 Raisin', 'CA! Chewy 240g*12 Raisin', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'CA! Chewy 240g*12 Original Cho', 'CA! Chewy 240g*12 Original Cho', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'CA!-COOKIE-95G*24-ORI-SP', 'CA!-COOKIE-95G*24-ORI-SP', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'CA!-COOKIE-285G*12-ORI-FP', 'CA!-COOKIE-285G*12-ORI-FP', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'CA!-COOKIE-95G*24-COF-SP', 'CA!-COOKIE-95G*24-COF-SP', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'CA!-COOKIE-285G*12-COF-FP', 'CA!-COOKIE-285G*12-COF-FP', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'CA! Candy Blast 255g', 'CA! Candy Blast 255g', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Chips Ahoy Others', 'Chips Ahoy Others', 18, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Oreo DF SDW 106g*24 Blueberry&Raspberry', 'Oreo DF SDW 106g*24 Blueberry&Raspberry', 19, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Oreo DF SDW 318g*15 Blueberry&Raspberry', 'Oreo DF SDW 318g*15 Blueberry&Raspberry', 20, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW 130g*24 Original', 'OREO SDW 130g*24 Original', 21, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW 130g*24 Strawberry', 'OREO SDW 130g*24 Strawberry', 22, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW 130g*24 Chocolate', 'OREO SDW 130g*24 Chocolate', 23, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO Icecream 106g*24 Green Tea', 'OREO Icecream 106g*24 Green Tea', 24, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO Icecream 106g*24 Vanilla', 'OREO Icecream 106g*24 Vanilla', 25, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO Icecream 318g*15 Green Tea', 'OREO Icecream 318g*15 Green Tea', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO Icecream 318g*15 Vanilla', 'OREO Icecream 318g*15 Vanilla', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW 130g*24 Light Sweet', 'OREO SDW 130g*24 Light Sweet', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Golden Oreo single pack 106g*24 Chocolate', 'Golden Oreo single pack 106g*24 Chocolate', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Golden Oreo family pack 318g*15 Chocolate', 'Golden Oreo family pack 318g*15 Chocolate', 30, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Golden Oreo single pack 106g*24 Strawberry', 'Golden Oreo single pack 106g*24 Strawberry', 31, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Golden Oreo family pack 318g*15 Strawberry', 'Golden Oreo family pack 318g*15 Strawberry', 32, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW Portion Pack 10*3 (Original)', 'OREO SDW Portion Pack 10*3 (Original)', 33, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW Portion Pack 10*3 (Chocolate)', 'OREO SDW Portion Pack 10*3 (Chocolate)', 34, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW Portion Pack 10*3 (Strawberry)', 'OREO SDW Portion Pack 10*3 (Strawberry)', 35, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW Thin 104g*24 Lemon', 'OREO SDW Thin 104g*24 Lemon', 36, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW Thin 312g*15 Lemon', 'OREO SDW Thin 312g*15 Lemon', 37, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW Thin 104g*24 Vanilla Mousse', 'OREO SDW Thin 104g*24 Vanilla Mousse', 38, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW Thin 104g*24 Tiramisu', 'OREO SDW Thin 104g*24 Tiramisu', 39, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW Thin 312g*15 Vanilla Mousse', 'OREO SDW Thin 312g*15 Vanilla Mousse', 40, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW Thin 312g*15 Tiramisu', 'OREO SDW Thin 312g*15 Tiramisu', 41, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Oreo DF SDW 318g*15 Grape+Peach', 'Oreo DF SDW 318g*15 Grape+Peach', 42, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Oreo Birthday Cake Sandwich 106g*24', 'Oreo Birthday Cake Sandwich 106g*24', 43, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Oreo Birthday Cake Sandwich 318g*15', 'Oreo Birthday Cake Sandwich 318g*15', 44, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW 520g family pack - Chocolate', 'OREO SDW 520g family pack - Chocolate', 45, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW 520g family pack - Light sweet', 'OREO SDW 520g family pack - Light sweet', 46, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW 520g family pack - Original', 'OREO SDW 520g family pack - Original', 47, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW 520g family pack - Strawberry', 'OREO SDW 520g family pack - Strawberry', 48, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW 260g single pack - Original', 'OREO SDW 260g single pack - Original', 49, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW 260g single pack - Light sweet', 'OREO SDW 260g single pack - Light sweet', 50, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW 260g single pack - Chocolate', 'OREO SDW 260g single pack - Chocolate', 51, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO SDW 260g single pack - Strawberry', 'OREO SDW 260g single pack - Strawberry', 52, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO Star 47g*24 Chocolate', 'OREO Star 47g*24 Chocolate', 53, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO Star 47g*24 Tiramisu', 'OREO Star 47g*24 Tiramisu', 54, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO Star 47g*24 Vanilla Mousse', 'OREO Star 47g*24 Vanilla Mousse', 55, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO-FW-55G*24-CHO-SP(NPD07)', 'OREO-FW-55G*24-CHO-SP(NPD07)', 56, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO-FW-55G*24-VAN-SP(NPD07)', 'OREO-FW-55G*24-VAN-SP(NPD07)', 57, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Mini Oreo SDW 55g*24 Chocolate', 'Mini Oreo SDW 55g*24 Chocolate', 58, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Mini Oreo SDW 55g*24 Ori', 'Mini Oreo SDW 55g*24 Ori', 59, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Mini Oreo SDW 55g*24  Strawberry', 'Mini Oreo SDW 55g*24  Strawberry', 60, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Coated wafer tiramisu 20s', 'Coated wafer tiramisu 20s', 61, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OFW 14.5G*16*24Vani+ChocoFP', 'OFW 14.5G*16*24Vani+ChocoFP', 62, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OFW 14.5g*16*24 Cho+Str FP', 'OFW 14.5g*16*24 Cho+Str FP', 63, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO-COATED WF-12.8G*5*30-Original', 'OREO-COATED WF-12.8G*5*30-Original', 64, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO-COATED WF-12.8G*20*24-Milk', 'OREO-COATED WF-12.8G*20*24-Milk', 65, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO-COATED WF-12.8G*20*24-Mocha', 'OREO-COATED WF-12.8G*20*24-Mocha', 66, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'OREO-COATED WF-12.8G*20*24-Original', 'OREO-COATED WF-12.8G*20*24-Original', 67, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Oreo Others', 'Oreo Others', 68, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Oreo soft cookie 160g*16 Vanilla', 'Oreo soft cookie 160g*16 Vanilla', 69, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Oreo soft cookie 160g*16 Strawberry', 'Oreo soft cookie 160g*16 Strawberry', 70, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Oreo Soft Others', 'Oreo Soft Others', 71, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'PSODA-BASE-400G*12-SAL-FP', 'PSODA-BASE-400G*12-SAL-FP', 72, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'PSODA-BASE-400G*12-SES-FP', 'PSODA-BASE-400G*12-SES-FP', 73, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'PSODA-BASE-400G*12-SEA-FP', 'PSODA-BASE-400G*12-SEA-FP', 74, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'PSODA-BASE-400G*12-ONI-FP', 'PSODA-BASE-400G*12-ONI-FP', 75, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Pacific Soda-300g*12-Salt', 'Pacific Soda-300g*12-Salt', 76, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Pacific Soda-300g*12-Onion', 'Pacific Soda-300g*12-Onion', 77, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Pacific Soda-100g*24-Salt-SP', 'Pacific Soda-100g*24-Salt-SP', 78, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Pacific Soda-100g*24-Onion-SP', 'Pacific Soda-100g*24-Onion-SP', 79, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Pacific Others', 'Pacific Others', 80, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Prince Cookie 85g*48 Chocolate', 'Prince Cookie 85g*48 Chocolate', 81, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Prince Others', 'Prince Others', 82, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Tuc Original 90g', 'Tuc Original 90g', 83, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Tuc Tomato flavor 90g', 'Tuc Tomato flavor 90g', 84, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Tuc Beef flavor 90g', 'Tuc Beef flavor 90g', 85, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Tuc Beef flavor 360g', 'Tuc Beef flavor 360g', 86, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Tuc Tomato flavor 360g', 'Tuc Tomato flavor 360g', 87, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Tuc Original 360g', 'Tuc Original 360g', 88, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Tuc seaweed flavor 360g', 'Tuc seaweed flavor 360g', 89, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'TUC Original 260g portion pack', 'TUC Original 260g portion pack', 90, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'TUC Sandwich cheese flavor 80g', 'TUC Sandwich cheese flavor 80g', 91, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'TUC Sandwich cheese flavor 160g', 'TUC Sandwich cheese flavor 160g', 92, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'TUC Sandwich seaweed flavor 160g', 'TUC Sandwich seaweed flavor 160g', 93, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Tuc Others', 'Tuc Others', 94, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Uguan plain family pack 500g*10', 'Uguan plain family pack 500g*10', 95, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Uguan plain single slug 100g*30', 'Uguan plain single slug 100g*30', 96, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Uguan plain portion pack 300g*12', 'Uguan plain portion pack 300g*12', 97, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Uguan SDW 130g*30 Milk', 'Uguan SDW 130g*30 Milk', 98, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Uguan SDW 390g*10 Milk', 'Uguan SDW 390g*10 Milk', 99, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Uguan Others', 'Uguan Others', 100, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('cookie', 'Mondelez Others', 'Mondelez Others', 101, now());
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
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 1', '益达40粒瓶装蜜瓜', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 2', '益达40粒瓶装薄荷', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 3', '益达40粒瓶装蓝莓', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 4', '益达40粒瓶装香橙', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 5', '益达40粒瓶装草本', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 6', '益达40粒瓶装冰柠', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 7', '益达40粒瓶装蜜柚', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 8', '益达40粒瓶装蜜桃', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 9', '益达40粒瓶装草莓', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 10', '益达40粒瓶装西瓜', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 11', '益达40粒瓶装西柚', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 12', '益达冰泡泡40粒', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 13', '益达40粒热带炫果', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 14', '益达70粒瓶装草莓', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 15', '益达70粒瓶装蜜瓜', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 16', '益达70粒瓶装混合水果味', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 17', '益达12片热带水果', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 18', '益达12片热带西瓜', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 19', '益达12片冰泡泡', 18, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 20', '益达12片薄荷', 19, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 21', '益达OTC西瓜', 20, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 22', '益达OTC蓝莓', 21, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', '40 others', '益达其他40粒装', 22, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 23', '益达40粒瓶装蜜瓜促销装', 23, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 24', '益达40粒瓶装薄荷促销装', 24, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 25', '益达40粒瓶装蓝莓促销装', 25, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 26', '益达40粒瓶装香橙促销装', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 27', '益达40粒瓶装草莓促销装', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 28', '益达40粒瓶装西瓜促销装', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 29', '益达70粒瓶装西瓜', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 30', '益达70粒瓶装薄荷', 30, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 31', '益达12片装不合规陈列热带水果', 31, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 32', '益达12片装不合规陈列热带西瓜', 32, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 33', '益达12片装不合规陈列冰泡泡', 33, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 34', '益达12片装不合规陈列薄荷', 34, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 35', '益达OTC不合规陈列西瓜', 35, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('extra', 'Extra 36', '益达OTC不合规陈列蓝莓', 36, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate1', 'colgate1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate2', 'colgate2', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate3', 'colgate3', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate4', 'colgate4', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate5', 'colgate5', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate6', 'colgate6', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate7', 'colgate7', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate8', 'colgate8', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate9', 'colgate9', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate10', 'colgate10', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate11', 'colgate11', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate12', 'colgate12', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate13', 'colgate13', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate14', 'colgate14', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate15', 'colgate15', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate16', 'colgate16', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate17', 'colgate17', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate18', 'colgate18', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate19', 'colgate19', 18, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('colgate', 'colgate20', 'colgate20', 19, now());
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
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco72', 'nco72', 71, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco73', 'nco73', 72, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco74', 'nco74', 73, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco75', 'nco75', 74, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco76', 'nco76', 75, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco77', 'nco77', 76, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco78', 'nco78', 77, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco79', 'nco79', 78, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco80', 'nco80', 79, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco81', 'nco81', 80, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco82', 'nco82', 81, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco83', 'nco83', 82, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlecoffee', 'nco84', 'nco84', 83, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle1', 'Nestle1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle21', 'Nestle21', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle2', 'Nestle2', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle22', 'Nestle22', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle3', 'Nestle3', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle23', 'Nestle23', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle4', 'Nestle4', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle24', 'Nestle24', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle5', 'Nestle5', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle25', 'Nestle25', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle6', 'Nestle6', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle26', 'Nestle26', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle7', 'Nestle7', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle27', 'Nestle27', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle8', 'Nestle8', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle28', 'Nestle28', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle9', 'Nestle9', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle29', 'Nestle29', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle10', 'Nestle10', 18, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle30', 'Nestle30', 19, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle11', 'Nestle11', 20, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle31', 'Nestle31', 21, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle35', 'Nestle35', 22, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle36', 'Nestle36', 23, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle12', 'Nestle12', 24, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle32', 'Nestle32', 25, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle13', 'Nestle13', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle33', 'Nestle33', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle14', 'Nestle14', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle34', 'Nestle34', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle15', 'Nestle15', 30, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle16', 'Nestle16', 31, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle17', 'Nestle17', 32, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle18', 'Nestle18', 33, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle19', 'Nestle19', 34, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle20', 'Nestle20', 35, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle37', 'Nestle37', 36, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle38', 'Nestle38', 37, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle39', 'Nestle39', 38, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle40', 'Nestle40', 39, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle41', 'Nestle41', 40, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle42', 'Nestle42', 41, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle43', 'Nestle43', 42, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle44', 'Nestle44', 43, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle45', 'Nestle45', 44, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle46', 'Nestle46', 45, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle47', 'Nestle47', 46, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle48', 'Nestle48', 47, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle49', 'Nestle49', 48, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle50', 'Nestle50', 49, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle51', 'Nestle51', 50, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle52', 'Nestle52', 51, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle53', 'Nestle53', 52, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle54', 'Nestle54', 53, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle55', 'Nestle55', 54, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle56', 'Nestle56', 55, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle57', 'Nestle57', 56, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle58', 'Nestle58', 57, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle59', 'Nestle59', 58, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle60', 'Nestle60', 59, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle61', 'Nestle61', 60, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle62', 'Nestle62', 61, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle63', 'Nestle63', 62, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle64', 'Nestle64', 63, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle65', 'Nestle65', 64, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle66', 'Nestle66', 65, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle67', 'Nestle67', 66, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle68', 'Nestle68', 67, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle69', 'Nestle69', 68, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle70', 'Nestle70', 69, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle71', 'Nestle71', 70, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle72', 'Nestle72', 71, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle73', 'Nestle73', 72, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle74', 'Nestle74', 73, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle75', 'Nestle75', 74, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle76', 'Nestle76', 75, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle77', 'Nestle77', 76, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle78', 'Nestle78', 77, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle79', 'Nestle79', 78, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle80', 'Nestle80', 79, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle81', 'Nestle81', 80, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle82', 'Nestle82', 81, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle83', 'Nestle83', 82, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle84', 'Nestle84', 83, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle85', 'Nestle85', 84, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle86', 'Nestle86', 85, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle87', 'Nestle87', 86, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle88', 'Nestle88', 87, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle89', 'Nestle89', 88, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle90', 'Nestle90', 89, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle91', 'Nestle91', 90, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle92', 'Nestle92', 91, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle93', 'Nestle93', 92, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle94', 'Nestle94', 93, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle95', 'Nestle95', 94, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle96', 'Nestle96', 95, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle97', 'Nestle97', 96, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlemilkpowder', 'Nestle98', 'Nestle98', 97, now());
		
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
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg13', 'nqmg13', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg1box', 'nqmg1box', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg2box', 'nqmg2box', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg3box', 'nqmg3box', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg4box', 'nqmg4box', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg5box', 'nqmg5box', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlesugar', 'nqmg6box', 'nqmg6box', 18, now());
		
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
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'nccs27', 'nccs27', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'youcui1', 'youcui1', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'youcui2', 'youcui2', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'youcui3', 'youcui3', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlebiscuit', 'youcui4', 'youcui4', 30, now());
		
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
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle45', 'Nestle45', 34, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle46', 'Nestle46', 35, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle47', 'Nestle47', 36, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle48', 'Nestle48', 37, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle49', 'Nestle49', 38, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle50', 'Nestle50', 39, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle51', 'Nestle51', 40, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle52', 'Nestle52', 41, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle53', 'Nestle53', 42, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle54', 'Nestle54', 43, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle55', 'Nestle55', 44, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle56', 'Nestle56', 45, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle57', 'Nestle57', 46, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle58', 'Nestle58', 47, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle59', 'Nestle59', 48, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle60', 'Nestle60', 49, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle61', 'Nestle61', 50, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle62', 'Nestle62', 51, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle63', 'Nestle63', 52, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle64', 'Nestle64', 53, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle65', 'Nestle65', 54, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle66', 'Nestle66', 55, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle67', 'Nestle67', 56, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle68', 'Nestle68', 57, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle69', 'Nestle69', 58, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle70', 'Nestle70', 59, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle71', 'Nestle71', 60, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle72', 'Nestle72', 61, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle73', 'Nestle73', 62, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle74', 'Nestle74', 63, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle75', 'Nestle75', 64, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle76', 'Nestle76', 65, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle77', 'Nestle77', 66, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle78', 'Nestle78', 67, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle79', 'Nestle79', 68, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle80', 'Nestle80', 69, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle81', 'Nestle81', 70, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle82', 'Nestle82', 71, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle83', 'Nestle83', 72, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle84', 'Nestle84', 73, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle85', 'Nestle85', 74, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle86', 'Nestle86', 75, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle87', 'Nestle87', 76, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle88', 'Nestle88', 77, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle89', 'Nestle89', 78, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle90', 'Nestle90', 79, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestlenutrition', 'Nestle91', 'Nestle91', 80, now());
		
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
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle1', 'Nestle1', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle21', 'Nestle21', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle2', 'Nestle2', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle22', 'Nestle22', 30, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle3', 'Nestle3', 31, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle23', 'Nestle23', 32, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle4', 'Nestle4', 33, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle24', 'Nestle24', 34, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle5', 'Nestle5', 35, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle25', 'Nestle25', 36, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle6', 'Nestle6', 37, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle26', 'Nestle26', 38, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle7', 'Nestle7', 39, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle27', 'Nestle27', 40, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle8', 'Nestle8', 41, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle28', 'Nestle28', 42, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle9', 'Nestle9', 43, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle29', 'Nestle29', 44, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle10', 'Nestle10', 45, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle30', 'Nestle30', 46, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle11', 'Nestle11', 47, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle31', 'Nestle31', 48, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle35', 'Nestle35', 49, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle36', 'Nestle36', 50, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle12', 'Nestle12', 51, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle32', 'Nestle32', 52, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle13', 'Nestle13', 53, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle33', 'Nestle33', 54, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle14', 'Nestle14', 55, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle34', 'Nestle34', 56, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle15', 'Nestle15', 57, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle16', 'Nestle16', 58, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle17', 'Nestle17', 59, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle18', 'Nestle18', 60, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle19', 'Nestle19', 61, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle20', 'Nestle20', 62, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle37', 'Nestle37', 63, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle38', 'Nestle38', 64, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle39', 'Nestle39', 65, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle40', 'Nestle40', 66, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle41', 'Nestle41', 67, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle42', 'Nestle42', 68, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle43', 'Nestle43', 69, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle44', 'Nestle44', 70, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle92', 'Nestle92', 71, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle93', 'Nestle93', 72, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle94', 'Nestle94', 73, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle95', 'Nestle95', 74, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle96', 'Nestle96', 75, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle97', 'Nestle97', 76, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nestledairy', 'Nestle98', 'Nestle98', 77, now());
		
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips1', 'layschips1', 0, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips2', 'layschips2', 1, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips3', 'layschips3', 2, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips4', 'layschips4', 3, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips5', 'layschips5', 4, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips6', 'layschips6', 5, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips7', 'layschips7', 6, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips8', 'layschips8', 7, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips9', 'layschips9', 8, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips10', 'layschips10', 9, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips11', 'layschips11', 10, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips12', 'layschips12', 11, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips13', 'layschips13', 12, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips14', 'layschips14', 13, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips15', 'layschips15', 14, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips16', 'layschips16', 15, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips17', 'layschips17', 16, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips18', 'layschips18', 17, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips19', 'layschips19', 18, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips20', 'layschips20', 19, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips21', 'layschips21', 20, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips22', 'layschips22', 21, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips23', 'layschips23', 22, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips24', 'layschips24', 23, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips25', 'layschips25', 24, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips26', 'layschips26', 25, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips27', 'layschips27', 26, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips28', 'layschips28', 27, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips29', 'layschips29', 28, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips30', 'layschips30', 29, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips31', 'layschips31', 30, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips32', 'layschips32', 31, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips33', 'layschips33', 32, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips34', 'layschips34', 33, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips35', 'layschips35', 34, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips36', 'layschips36', 35, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips37', 'layschips37', 36, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips38', 'layschips38', 37, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips39', 'layschips39', 38, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips40', 'layschips40', 39, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips41', 'layschips41', 40, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips42', 'layschips42', 41, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips43', 'layschips43', 42, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips44', 'layschips44', 43, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips45', 'layschips45', 44, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips46', 'layschips46', 45, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips47', 'layschips47', 46, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips48', 'layschips48', 47, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips49', 'layschips49', 48, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips50', 'layschips50', 49, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips51', 'layschips51', 50, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips52', 'layschips52', 51, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips53', 'layschips53', 52, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips54', 'layschips54', 53, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips55', 'layschips55', 54, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips56', 'layschips56', 55, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips57', 'layschips57', 56, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips58', 'layschips58', 57, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips59', 'layschips59', 58, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips60', 'layschips60', 59, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips61', 'layschips61', 60, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips62', 'layschips62', 61, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips63', 'layschips63', 62, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips64', 'layschips64', 63, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips65', 'layschips65', 64, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips66', 'layschips66', 65, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips67', 'layschips67', 66, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips68', 'layschips68', 67, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips69', 'layschips69', 68, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips70', 'layschips70', 69, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips71', 'layschips71', 70, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips72', 'layschips72', 71, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips73', 'layschips73', 72, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips74', 'layschips74', 73, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips75', 'layschips75', 74, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips76', 'layschips76', 75, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips77', 'layschips77', 76, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips78', 'layschips78', 77, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips79', 'layschips79', 78, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips80', 'layschips80', 79, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips81', 'layschips81', 80, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips82', 'layschips82', 81, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips83', 'layschips83', 82, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips84', 'layschips84', 83, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips85', 'layschips85', 84, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips86', 'layschips86', 85, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips87', 'layschips87', 86, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips88', 'layschips88', 87, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips89', 'layschips89', 88, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips90', 'layschips90', 89, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips91', 'layschips91', 90, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips92', 'layschips92', 91, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips93', 'layschips93', 92, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips94', 'layschips94', 93, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips95', 'layschips95', 94, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips96', 'layschips96', 95, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips97', 'layschips97', 96, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips98', 'layschips98', 97, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips99', 'layschips99', 98, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips100', 'layschips100', 99, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips101', 'layschips101', 100, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips102', 'layschips102', 101, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips103', 'layschips103', 102, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'layschips104', 'layschips104', 103, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged1', 'deepridged1', 104, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged2', 'deepridged2', 105, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged3', 'deepridged3', 106, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged4', 'deepridged4', 107, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged5', 'deepridged5', 108, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged6', 'deepridged6', 109, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged7', 'deepridged7', 110, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged8', 'deepridged8', 111, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged9', 'deepridged9', 112, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged10', 'deepridged10', 113, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged11', 'deepridged11', 114, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged12', 'deepridged12', 115, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged13', 'deepridged13', 116, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged14', 'deepridged14', 117, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged15', 'deepridged15', 118, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged16', 'deepridged16', 119, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged17', 'deepridged17', 120, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged18', 'deepridged18', 121, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged19', 'deepridged19', 122, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged20', 'deepridged20', 123, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged21', 'deepridged21', 124, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged22', 'deepridged22', 125, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged23', 'deepridged23', 126, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged24', 'deepridged24', 127, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged25', 'deepridged25', 128, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged26', 'deepridged26', 129, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged27', 'deepridged27', 130, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'deepridged28', 'deepridged28', 131, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'cheetos1', 'cheetos1', 132, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'cheetos2', 'cheetos2', 133, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'cheetos3', 'cheetos3', 134, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'cheetos4', 'cheetos4', 135, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'cheetos5', 'cheetos5', 136, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'cheetos6', 'cheetos6', 137, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'cheetos7', 'cheetos7', 138, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'cheetos8', 'cheetos8', 139, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'cheetos9', 'cheetos9', 140, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'cheetos10', 'cheetos10', 141, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'cheetos11', 'cheetos11', 142, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'cheetos12', 'cheetos12', 143, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'cheetos13', 'cheetos13', 144, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'cheetos14', 'cheetos14', 145, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'cheetos15', 'cheetos15', 146, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'funnypotato1', 'funnypotato1', 147, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'funnypotato2', 'funnypotato2', 148, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'funnypotato3', 'funnypotato3', 149, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'funnypotato4', 'funnypotato4', 150, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'funnypotato5', 'funnypotato5', 151, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'funnypotato6', 'funnypotato6', 152, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'funnypotato7', 'funnypotato7', 153, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax1', 'stax1', 154, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax2', 'stax2', 155, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax3', 'stax3', 156, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax4', 'stax4', 157, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax5', 'stax5', 158, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax6', 'stax6', 159, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax7', 'stax7', 160, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax8', 'stax8', 161, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax9', 'stax9', 162, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax10', 'stax10', 163, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax11', 'stax11', 164, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax12', 'stax12', 165, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax13', 'stax13', 166, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax14', 'stax14', 167, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax15', 'stax15', 168, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax16', 'stax16', 169, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax17', 'stax17', 170, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax18', 'stax18', 171, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax19', 'stax19', 172, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax20', 'stax20', 173, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax21', 'stax21', 174, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax22', 'stax22', 175, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax23', 'stax23', 176, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax24', 'stax24', 177, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax25', 'stax25', 178, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax26', 'stax26', 179, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax27', 'stax27', 180, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax28', 'stax28', 181, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax29', 'stax29', 182, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax30', 'stax30', 183, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'stax31', 'stax31', 184, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles1', 'bugles1', 185, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles2', 'bugles2', 186, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles3', 'bugles3', 187, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles4', 'bugles4', 188, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles5', 'bugles5', 189, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles6', 'bugles6', 190, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles7', 'bugles7', 191, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles8', 'bugles8', 192, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles9', 'bugles9', 193, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles10', 'bugles10', 194, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles11', 'bugles11', 195, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles12', 'bugles12', 196, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles13', 'bugles13', 197, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles14', 'bugles14', 198, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles15', 'bugles15', 199, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles16', 'bugles16', 200, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles17', 'bugles17', 201, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles18', 'bugles18', 202, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles19', 'bugles19', 203, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles20', 'bugles20', 204, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles21', 'bugles21', 205, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles22', 'bugles22', 206, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles23', 'bugles23', 207, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'bugles24', 'bugles24', 208, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'zcst1', 'zcst1', 209, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'zcst2', 'zcst2', 210, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'zcst3', 'zcst3', 211, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'zcst4', 'zcst4', 212, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'zcst5', 'zcst5', 213, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'zcst6', 'zcst6', 214, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'zcst7', 'zcst7', 215, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'zcst8', 'zcst8', 216, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'xzyk1', 'xzyk1', 217, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'xzyk2', 'xzyk2', 218, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'xzyk3', 'xzyk3', 219, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'xzyk4', 'xzyk4', 220, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos1', 'doritos1', 221, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos2', 'doritos2', 222, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos3', 'doritos3', 223, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos4', 'doritos4', 224, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos5', 'doritos5', 225, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos6', 'doritos6', 226, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos7', 'doritos7', 227, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos8', 'doritos8', 228, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos9', 'doritos9', 229, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos10', 'doritos10', 230, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos11', 'doritos11', 231, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos12', 'doritos12', 232, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos13', 'doritos13', 233, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos14', 'doritos14', 234, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos15', 'doritos15', 235, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos16', 'doritos16', 236, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos17', 'doritos17', 237, now());
		INSERT INTO `goods_sku`(`major_type`, `name`, `description`, `order`, `create_time`) VALUES ('nielsenchips', 'doritos18', 'doritos18', 238, now());

	END IF;
END//

DELIMITER //
CREATE PROCEDURE UpdateSkuTableData()
BEGIN
	SET @ret = 0;
	CALL CheckTableExist("major_type", @ret);
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

CALL CreateMarketingTables();
CALL CreateInitialUser();
CALL CreatePrivileges();
CALL CreateApplication();
CALL CreateGoodsSku();
CALL UpdateSkuTableData();

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
DROP PROCEDURE IF EXISTS UpdateSkuTableData;