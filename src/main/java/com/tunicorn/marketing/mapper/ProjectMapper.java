package com.tunicorn.marketing.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.vo.ProjectVO;

public interface ProjectMapper {

	@Select("select p.id, p.name, p.address, p.mobile, p.contacts, p.type, p.store_number as storeNumber,p.call_number as callNumber, "
			+ "p.image_number as imageNumber, p.threshhold, p.create_time as createTime, p.last_update as lastUpdateTime, p.status "
			+ "from project p, admin_service_apply s "
			+ "where p.id=s.project_id and p.status='active' and s.apply_status='opened' and s.status='active'")
	public List<ProjectVO> getProjectList();

	public int createProject(ProjectVO projectVO);

	public int updateProject(ProjectVO projectVO);

	public List<Map<String, Object>> getProjectsByUserId(@Param("userId") String userId);

	@Select("select id, name, address, mobile, contacts, type, store_number as storeNumber,call_number as callNumber, "
			+ "image_number as imageNumber, threshhold, create_time as createTime, last_update as lastUpdateTime, status "
			+ "from project p where status='active'")
	public List<ProjectVO> getAllProjects();

}
