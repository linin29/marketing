package com.tunicorn.marketing.vo;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.tunicorn.marketing.constant.MarketingConstants;

public class AdminServiceApplyVO {
	private long id;
	private int userId;
	private String appBusinessName;
	private String appBusinessAddress;
	private String appBusinessMobile;
	private String appBusinessContacts;
	private long maxCallNumber;
	private int creatorId;
	private String applyStatus;
	private Date createTime;
	private Date lastUpdate;
	private String status;
	private List<MajorTypeVO> majorTypes;
	private UserVO creator;
	private String statusStr;
	private String username;
	private String email;
	private String rejectReason;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public List<MajorTypeVO> getMajorTypes() {
		return majorTypes;
	}

	public void setMajorTypes(List<MajorTypeVO> majorTypes) {
		this.majorTypes = majorTypes;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
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

	public String getAppBusinessContacts() {
		return appBusinessContacts;
	}

	public void setAppBusinessContacts(String appBusinessContacts) {
		this.appBusinessContacts = appBusinessContacts;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public UserVO getCreator() {
		return creator;
	}

	public void setCreator(UserVO creator) {
		this.creator = creator;
	}

	public String getRejectReason() {
		return rejectReason;
	}

	public void setRejectReason(String rejectReason) {
		this.rejectReason = rejectReason;
	}

	public String getStatusStr() {
		if (StringUtils.isNotBlank(applyStatus)) {
			statusStr = MarketingConstants.SERVICE_STATUS_NAME_MAPPING.get(applyStatus);
		}

		return statusStr;
	}
}
