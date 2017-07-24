package com.tunicorn.marketing.mapper;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.vo.ApplicationVO;

public interface ApplicationMapper {
	@Results({
	    @Result(property = "userId", column = "user_id"),
	    @Result(property = "appKey", column = "app_key"),
	    @Result(property = "appSecret", column = "app_secret"),
	    @Result(property = "createTime", column = "create_time"),
	    @Result(property = "lastUpdate", column = "last_update")
	})
	@Select("select * from application where app_key=#{key} and app_secret=#{secret} and status='active'") 
	public ApplicationVO getApplicationByKeyAndSecret (@Param("key") String key, @Param("secret") String secret);
	
	public int createApplication(ApplicationVO applicationVO);
}
