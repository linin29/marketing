package com.tunicorn.marketing.bo;

public class TaskBO extends PaginationBO {
	private String id;
	private String name;
	private String taskStatus;
	private String userId;
	private String majorType;
	private String startTime;
	private String endTime;
	private String[] majorTypeArray;
	private String[] taskIds;
	private String projectId;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTaskStatus() {
		return taskStatus;
	}

	public void setTaskStatus(String taskStatus) {
		this.taskStatus = taskStatus;
	}

	public String getMajorType() {
		return majorType;
	}

	public void setMajorType(String majorType) {
		this.majorType = majorType;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String[] getMajorTypeArray() {
		return majorTypeArray;
	}

	public void setMajorTypeArray(String[] majorTypeArray) {
		this.majorTypeArray = majorTypeArray;
	}

	public String[] getTaskIds() {
		return taskIds;
	}

	public void setTaskIds(String[] taskIds) {
		this.taskIds = taskIds;
	}

	public String getProjectId() {
		return projectId;
	}

	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}

}
