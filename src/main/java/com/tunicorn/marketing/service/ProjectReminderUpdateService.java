package com.tunicorn.marketing.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tunicorn.marketing.mapper.ProjectReminderUpdateMapper;
import com.tunicorn.marketing.vo.ProjectReminderUpdateVO;

@Service
public class ProjectReminderUpdateService {
	@Autowired
	private ProjectReminderUpdateMapper projectReminderMapper;
	
	public ProjectReminderUpdateVO getProjectReminders (String projectId, String date) {
		return projectReminderMapper.getPrejectDateReminderByProjectId(projectId, date);
	}
	
	public void insertReminder (ProjectReminderUpdateVO update) {
		projectReminderMapper.insertProjectReminder(update);
	}
	
	public void deletePreviousReminder (String date) {
		projectReminderMapper.deletePreviousReminder(date);
	}
}
