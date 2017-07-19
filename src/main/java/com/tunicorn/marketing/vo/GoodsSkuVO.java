package com.tunicorn.marketing.vo;

import java.util.Date;

public class GoodsSkuVO {
	private long id;
	private String name;
	private String description;
	private int order;
	private Date createTime;
	private Date lastUpdateTime;
	private String status;
	private Boolean isShow;
	private String majorType;
	private MajorTypeVO majorTypeVO;
 
	public MajorTypeVO getMajorTypeVO() {
		return majorTypeVO;
	}

	public void setMajorTypeVO(MajorTypeVO majorTypeVO) {
		this.majorTypeVO = majorTypeVO;
	}

	public String getMajorType() {
		return majorType;
	}

	public void setMajorType(String majorType) {
		this.majorType = majorType;
	}

	public Boolean getIsShow() {
		return isShow;
	}

	public void setIsShow(Boolean isShow) {
		this.isShow = isShow;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getOrder() {
		return order;
	}

	public void setOrder(int order) {
		this.order = order;
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
