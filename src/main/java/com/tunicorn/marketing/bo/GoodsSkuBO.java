package com.tunicorn.marketing.bo;

public class GoodsSkuBO extends PaginationBO {
	private String name;
	private long majorTypeId;
	private Integer order;
	private Boolean isShow;
	private String majorType;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public long getMajorTypeId() {
		return majorTypeId;
	}

	public void setMajorTypeId(long majorTypeId) {
		this.majorTypeId = majorTypeId;
	}

	public Integer getOrder() {
		return order;
	}

	public void setOrder(Integer order) {
		this.order = order;
	}

	public Boolean getIsShow() {
		return isShow;
	}

	public void setIsShow(Boolean isShow) {
		this.isShow = isShow;
	}

	public String getMajorType() {
		return majorType;
	}

	public void setMajorType(String majorType) {
		this.majorType = majorType;
	}

}
