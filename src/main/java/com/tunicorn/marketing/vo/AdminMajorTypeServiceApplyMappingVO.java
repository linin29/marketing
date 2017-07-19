package com.tunicorn.marketing.vo;

import java.util.Date;

public class AdminMajorTypeServiceApplyMappingVO {
	private long id;
	private long serviceApplyId;
	private long majorTypeId;
	private Date createTime;
	private Date lastUpdate;
	private String status;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public long getServiceApplyId() {
		return serviceApplyId;
	}

	public void setServiceApplyId(long serviceApplyId) {
		this.serviceApplyId = serviceApplyId;
	}

	public long getMajorTypeId() {
		return majorTypeId;
	}

	public void setMajorTypeId(long majorTypeId) {
		this.majorTypeId = majorTypeId;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Date getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(Date lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

}
