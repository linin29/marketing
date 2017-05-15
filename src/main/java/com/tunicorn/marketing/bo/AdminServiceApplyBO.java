package com.tunicorn.marketing.bo;

import java.util.Date;

public class AdminServiceApplyBO extends PaginationBO {
	private int userId;
	private String appBusinessName;
	private String appBusinessAddress;
	private String appBusinessMobile;
	private long maxCallNumber;
	private int creatorId;
	private String applyStatus;
	private Date createTime;
	private Date lastUpdate;
	private int majorTypeId;
	private String majorTypeName;

	public String getMajorTypeName() {
		return majorTypeName;
	}

	public void setMajorTypeName(String majorTypeName) {
		this.majorTypeName = majorTypeName;
	}

	public int getMajorTypeId() {
		return majorTypeId;
	}

	public void setMajorTypeId(int majorTypeId) {
		this.majorTypeId = majorTypeId;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getAppBusinessName() {
		return appBusinessName;
	}

	public void setAppBusinessName(String appBusinessName) {
		this.appBusinessName = appBusinessName;
	}

	public String getAppBusinessAddress() {
		return appBusinessAddress;
	}

	public void setAppBusinessAddress(String appBusinessAddress) {
		this.appBusinessAddress = appBusinessAddress;
	}

	public String getAppBusinessMobile() {
		return appBusinessMobile;
	}

	public void setAppBusinessMobile(String appBusinessMobile) {
		this.appBusinessMobile = appBusinessMobile;
	}

	public long getMaxCallNumber() {
		return maxCallNumber;
	}

	public void setMaxCallNumber(long maxCallNumber) {
		this.maxCallNumber = maxCallNumber;
	}

	public int getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(int creatorId) {
		this.creatorId = creatorId;
	}

	public String getApplyStatus() {
		return applyStatus;
	}

	public void setApplyStatus(String applyStatus) {
		this.applyStatus = applyStatus;
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
}
