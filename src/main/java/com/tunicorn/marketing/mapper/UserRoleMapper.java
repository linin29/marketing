package com.tunicorn.marketing.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Options;

import com.tunicorn.marketing.vo.UserRoleVO;

public interface UserRoleMapper {
	@Insert("Insert into user_role_mapping (user_id, role_id, create_time) values (#{userId},#{roleId},now())")
	@Options(useGeneratedKeys = true, keyProperty = "id", keyColumn = "id") 
	public int createUserRoleMapping (UserRoleVO userRole);
}
