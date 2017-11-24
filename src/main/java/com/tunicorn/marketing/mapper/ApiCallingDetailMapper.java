package com.tunicorn.marketing.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Options;

import com.tunicorn.marketing.vo.ApiCallingDetailVO;

public interface ApiCallingDetailMapper {

	@Insert("Insert into api_calling_detail (api_method, api_name, user_name, calling_status, pictures, create_time)"
			+ " values (#{apiMethod}, #{apiName}, #{userName}, #{callingStatus}, #{pictures}, now())")
	@Options(useGeneratedKeys = true, keyProperty = "id", keyColumn = "id")
	public int insertApiCallingDetail(ApiCallingDetailVO apiCallingDetailVO);
}
