package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.tunicorn.marketing.bo.UserBO;
import com.tunicorn.marketing.vo.UserVO;
  
public interface UserMapper {

	@Results({ @Result(property = "userName", column = "username"),
			@Result(property = "createTime", column = "create_time") })
	@Select("select * from user where username = #{userName} and status='active'")
	public UserVO getUserByUserName(String userName);

	@Results({ @Result(property = "createTime", column = "create_time") })
	@Select("select * from user where id = #{userId} and status = 'active'")
	public UserVO getUserByID(String userId);

	@Update("update user set password=#{password} where id=#{id} and status='active'")
	public Boolean updateUserPassword(UserVO user);

	@Update("update user set status='deleted' where id=#{userId}")
	public Boolean deleteUser(@Param("userId") String userId);
	
	public int createUser(UserVO userVO);
	
	public List<UserVO> getUserListByBO(UserBO userBO);

	public int getUserCount(UserBO userBO);
	
	public int updateUser(UserVO userVO);
}
