package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.tunicorn.marketing.vo.AdminUserVO;

public interface AdminUserMapper {

	@Results({ @Result(property = "userName", column = "username"),
			@Result(property = "createTime", column = "create_time") })
	@Select("select * from admin_user where username = #{userName} and status='active'")
	public AdminUserVO getUserByUserName(String userName);

	@Results({ @Result(property = "createTime", column = "create_time") })
	@Select("select * from admin_user where id = #{userId} and status = 'active'")
	public AdminUserVO getUserByID(String userId);

	@Update("update admin_user set password=#{password} where id=#{id} and status='active'")
	public Boolean updateUserPassword(AdminUserVO user);

	@Update("update admin_user set status='deleted' where id=#{userId}")
	public Boolean deleteUser(@Param("userId") String userId);
	
	public List<AdminUserVO> getAdminUserList();
}
