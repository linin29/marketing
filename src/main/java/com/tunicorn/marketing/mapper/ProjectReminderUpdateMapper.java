package com.tunicorn.marketing.mapper;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.vo.ProjectReminderUpdateVO;

  
public interface ProjectReminderUpdateMapper {
	@Select("select id, project_id as projectId,  reminder_day as remiderDay "
			+ "from project_reminder_update where project_id=#{projectId} and reminder_day=#{date}") 
	public ProjectReminderUpdateVO getPrejectDateReminderByProjectId (@Param("projectId") String projectId, @Param("date") String date);
	
	@Insert("Insert into project_reminder_update(project_id, reminder_day) values(#{projectId}, #{remiderDay})")
	public void insertProjectReminder (ProjectReminderUpdateVO update);
	
	@Delete("delete from project_reminder_update where reminder_day < #{date}")
	public void deletePreviousReminder (String date);
}
