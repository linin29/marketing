package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.vo.PrivilegeVO;

public interface AdminPrivilegeMapper {
	@Select("select c.id, c.parent_id as parentId, c.item_name as privilegeName, c.item_value as privilegeValue, c.display_order as displayOrder "
			+ "from admin_user_role_mapping a, admin_role b, admin_privilege c, admin_role_privilege_mapping d "
			+ "where a.role_id = b.id and b.id = d.role_id and d.privilege_id = c.id and a.user_id = #{userId} "
			+ "and a.status='active' and b.status='active' and c.status='active' and d.status='active' "
			+ "order by c.display_order")
	public List<PrivilegeVO> getMenuPrivileges(String userId);

	@Insert("Insert into admin_privilege( item_name, item_value, description, create_time) values "
			+ "( #{privilegeName}, #{privilegeValue}, #{description} ,now())")
	@Options(useGeneratedKeys = true, keyProperty = "id", keyColumn = "id")
	public int create(PrivilegeVO privilegeVO);

	@Insert("Update admin_privilege set item_name=#{privilegeName},description= #{description},last_update=now() "
			+ "where item_value=#{privilegeValue} and status='active'")
	public int update(PrivilegeVO privilegeVO);
}
