package com.tunicorn.marketing.bo;

import java.util.Date;

public class ApiCallingSummaryBO extends PaginationBO {
	private long id;
	private String apiMethod;
	private String apiName;
	private String callingDay;
	private String userName;
	private int callingTimes;
	private Date createTime;
	private String status;
	private String startDate;
	private String endDate;
	

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

	public String getCallingDay() {
		return callingDay;
	}

	public void setCallingDay(String callingDay) {
		this.callingDay = callingDay;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public int getCallingTimes() {
		return callingTimes;
	}

	public void setCallingTimes(int callingTimes) {
		this.callingTimes = callingTimes;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

}
