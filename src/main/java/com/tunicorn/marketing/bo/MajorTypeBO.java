package com.tunicorn.marketing.bo;

import java.util.Date;

public class MajorTypeBO extends PaginationBO {
	private String name;
	private Date createTime;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

}
