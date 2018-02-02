package com.tunicorn.marketing.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tunicorn.marketing.mapper.AdminServiceApplyMapper;
import com.tunicorn.marketing.mapper.ApiCallingSummaryMapper;
import com.tunicorn.marketing.mapper.ProjectMapper;
import com.tunicorn.marketing.vo.AdminServiceApplyVO;
import com.tunicorn.marketing.vo.ProjectVO;

@Service
public class ProjectService {
	@Autowired
	private ProjectMapper projectMapper;
	
	@Autowired
	ApiCallingSummaryMapper apiCallingMapper;
	
	@Autowired
	AdminServiceApplyMapper serviceApplyMapper;
	
	public List<ProjectVO> getProjects() {
		return projectMapper.getProjectList();
	}
	
	public int getAPICallCountByProjectId(String projectId) {
		return apiCallingMapper.getAPICallCountByProjectId(projectId);
	}
	
	public AdminServiceApplyVO getServiceByProjectId (String projectId) {
		return serviceApplyMapper.getServiceByProjectId(projectId);
	}
	
	public List<Map<String, Object>> getProjectsByUserId(String userId){
		return projectMapper.getProjectsByUserId(userId);
	}
}
