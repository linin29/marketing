package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.vo.ProjectVO;

public interface ProjectMapper {
	
	@Select("select id, name, address, mobile, contacts, type, store_number as storeNumber,call_number as callNumber, image_number as imageNumber,"
			+ "threshhold, create_time as createTime, last_update as lastUpdateTime, status from project p, admin_service_apply s "
			+ "where p.id=s.project_id and p.status='active' and s.apply_status='opened'")
	public List<ProjectVO> getProjectList ();
	
	public int createProject(ProjectVO projectVO);
	
	public int updateProject(ProjectVO projectVO);
	
}
