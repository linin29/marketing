package com.tunicorn.marketing.mapper;


import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import com.tunicorn.marketing.vo.TokenVO;

public interface TokenMapper {
	@Results({
	    @Result(property = "userId", column = "user_id"),
	    @Result(property = "accessToken", column = "access_token"),
	    @Result(property = "expiresTime", column = "expires_time")
	})
	@Select("select id, user_id, access_token, expires_time from token where access_token=#{token} and expires_time>#{currentTime} and status='active'") 
	public TokenVO getToken(@Param("token") String token, @Param("currentTime") Long currentTime);
	
	@Results({
	    @Result(property = "userId", column = "user_id"),
	    @Result(property = "accessToken", column = "access_token"),
	    @Result(property = "expiresTime", column = "expires_time")
	})
	@Select("select id, user_id, access_token, expires_time from token where app_id=#{appId} and user_id=#{userId} and client_id=#{clientId} and status='active'") 
	public TokenVO getTokenByInfo(@Param("appId") int appId, @Param("userId") String userId, @Param("clientId") String clientId);
	
	@Update("update token set status = 'deleted' where access_token = #{token}") 
	public void deleteToekn(@Param("token") String token);
	
	@Insert("insert into token(app_id, user_id, client_id, access_token, expires_time, create_time) "
			+ "values(#{appId}, #{userId}, #{clientId}, #{accessToken}, #{expiresTime}, now())")
	public void insertToken(TokenVO tokenVO);
}
