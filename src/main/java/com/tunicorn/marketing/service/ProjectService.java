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

	public Integer getAPICallCountByProjectId(String projectId) {
		return apiCallingMapper.getAPICallCountByProjectId(projectId);
	}

	public AdminServiceApplyVO getServiceByProjectId(String projectId) {
		return serviceApplyMapper.getServiceByProjectId(projectId);
	}

	/**
	 * 通过用户id获取该用户关联的项目信息
	 * @auther weixiaokai
	 * @date 2018年2月5日 上午10:40:30
	 * @param userId
	 * @return
	 */
	public List<Map<String, Object>> getProjectsByUserId(String userId) {
		return projectMapper.getProjectsByUserId(userId);
	}
	
	/**
	 * 根据项目ID获取该项目信息
	 * @auther weixiaokai
	 * @date 2018年2月5日 上午10:46:20
	 * @param projectId
	 * @return
	 */
	public ProjectVO getProjectById(String projectId){
		return projectMapper.getProjectById(projectId);
	}
	
	public ProjectVO getProjectsByUserIdAndProjectId(String userId,String id) {
		return projectMapper.getProjectsByUserIdAndProjectId(userId,id);
	}
	/**
	 * 根据项目名称获取
	 * @auther weixiaokai
	 * @date 2018年2月9日 下午2:44:08
	 * @param projectId
	 * @return
	 */
	public ProjectVO getProjectByName(String name){
		return projectMapper.getProjectByName(name);
	}
}
