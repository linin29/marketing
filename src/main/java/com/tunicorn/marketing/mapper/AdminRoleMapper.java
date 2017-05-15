package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.vo.RoleVO;

public interface AdminRoleMapper {
	@Select("select * from admin_role where name = #{name} and status='active'") 
	public RoleVO getRoleByName (String name);
	
	@Select("SELECT id, name, description, create_time as createTime, status FROM admin_role WHERE status='active'")
	public List<RoleVO> getActiveRoles();
	
}
