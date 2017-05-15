package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Update;

import com.tunicorn.marketing.bo.ApiCallingSummaryBO;
import com.tunicorn.marketing.vo.ApiCallingSummaryVO;

public interface ApiCallingSummaryMapper {

	@Insert("Insert into api_calling_count (api_method, api_name, calling_day, user_name,calling_times,create_time)"
			+ " values (#{apiMethod}, #{apiName}, #{callingDay}, #{userName}, #{callingTimes}, now())")
	@Options(useGeneratedKeys = true, keyProperty = "id", keyColumn = "id")
	public long insertApiCallingSummary(ApiCallingSummaryVO apiCallingSummaryVO);

	@Update("update api_calling_count set calling_times= #{callingTimes} where id = #{id} and status='active'")
	public int updateApiCallingSummary(ApiCallingSummaryVO apiCallingSummaryVO);

	public List<ApiCallingSummaryVO> getApiCallingSummaryList(ApiCallingSummaryBO apiCallingSummaryBO);
	
	public List<ApiCallingSummaryVO> getApiCallingSummaryListByVO(ApiCallingSummaryVO apiCallingSummaryVO);
	
	public int getApiCallingSummary(ApiCallingSummaryBO apiCallingSummaryBO);
}
