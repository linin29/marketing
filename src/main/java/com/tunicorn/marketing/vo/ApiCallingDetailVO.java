package com.tunicorn.marketing.vo;

import java.util.Date;

public class ApiCallingDetailVO {
	private long id;
	private String apiMethod;
	private String apiName;
	private String userName;
	private String callingStatus;
	private int pictures;
	private Date createTime;
	private Date lastUpdateTime;
	private String status;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getApiMethod() {
		return apiMethod;
	}

	public void setApiMethod(String apiMethod) {
		this.apiMethod = apiMethod;
	}

	public String getApiName() {
		return apiName;
	}

	public void setApiName(String apiName) {
		this.apiName = apiName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getCallingStatus() {
		return callingStatus;
	}

	public void setCallingStatus(String callingStatus) {
		this.callingStatus = callingStatus;
	}

	public int getPictures() {
		return pictures;
	}

	public void setPictures(int pictures) {
		this.pictures = pictures;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Date getLastUpdateTime() {
		return lastUpdateTime;
	}

	public void setLastUpdateTime(Date lastUpdateTime) {
		this.lastUpdateTime = lastUpdateTime;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}
