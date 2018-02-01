package com.tunicorn.marketing.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tunicorn.marketing.mapper.ProjectReminderUpdateMapper;
import com.tunicorn.marketing.vo.ProjectReminderUpdateVO;

@Service
public class ProjectReminderUpdateService {
	@Autowired
	private ProjectReminderUpdateMapper projectReminderMapper;
	
	public List<ProjectReminderUpdateVO> getProjectReminders () {
		return projectReminderMapper.getPrejectReminderUpdatess();
	}
}
