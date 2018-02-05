package com.tunicorn.marketing.vo;

import java.util.Date;

import org.apache.commons.lang3.StringUtils;

import com.tunicorn.marketing.constant.MarketingConstants;

public class ProjectVO {

	private String id;
	private String name;
	private String address;
	private String mobile;
	private String contacts;
	private String type;
	private int storeNumber;
	private int callNumber;
	private int imageNumber;
	private float threshhold;
	private Date createTime;
	private Date lastUpdateTime;
	private String status;
	private String typeStr;

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

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getContacts() {
		return contacts;
	}

	public void setContacts(String contacts) {
		this.contacts = contacts;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getStoreNumber() {
		return storeNumber;
	}

	public void setStoreNumber(int storeNumber) {
		this.storeNumber = storeNumber;
	}

	public int getCallNumber() {
		return callNumber;
	}

	public void setCallNumber(int callNumber) {
		this.callNumber = callNumber;
	}

	public int getImageNumber() {
		return imageNumber;
	}

	public void setImageNumber(int imageNumber) {
		this.imageNumber = imageNumber;
	}

	public float getThreshhold() {
		return threshhold;
	}

	public void setThreshhold(float threshhold) {
		this.threshhold = threshhold;
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

	public String getTypeStr() {
		if (StringUtils.isNotBlank(type)) {
			typeStr = MarketingConstants.PROJECT_TYPE_NAME_MAPPING.get(type);
		}

		return typeStr;
	}
}
