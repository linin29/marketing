package com.tunicorn.marketing.vo;

import java.util.Date;

public class ProjectReminderUpdateVO {
	private String id;
	private String projectId;
	private Date remiderDay;
	private String flag;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getProjectId() {
		return projectId;
	}
	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}
	public Date getRemiderDay() {
		return remiderDay;
	}
	public void setRemiderDay(Date remiderDay) {
		this.remiderDay = remiderDay;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
}
