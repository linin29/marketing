package com.tunicorn.marketing.mapper;

import org.apache.ibatis.annotations.Select;

public interface StoreMapper {
	
	@Select("select count(id) from store where project_id=#{projectId}")
	public int getStoreCountByProjectId (String projectId);
}
