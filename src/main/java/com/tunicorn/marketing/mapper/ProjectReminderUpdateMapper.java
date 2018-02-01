package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.vo.ProjectReminderUpdateVO;

  
public interface ProjectReminderUpdateMapper {
	@Select("select id, project_id as projectId,  reminder_day as remiderDay, flag from project_reminder_update where flag='0'") 
	public List<ProjectReminderUpdateVO> getPrejectReminderUpdatess ();
	
}
