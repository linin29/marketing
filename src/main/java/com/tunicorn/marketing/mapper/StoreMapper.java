package com.tunicorn.marketing.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.vo.StoreVO;

public interface StoreMapper {
	
	@Select("select count(id) from store where project_id=#{projectId}")
	public int getStoreCountByProjectId (String projectId);
	
	@Insert("Insert into store(code, project_id) values(#{code}, #{projectId})")
	public void insertStore(StoreVO storeVO);
}
