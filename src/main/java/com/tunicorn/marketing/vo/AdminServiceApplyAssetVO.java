package com.tunicorn.marketing.vo;

import java.util.Date;

import org.apache.commons.lang.StringUtils;

import com.tunicorn.marketing.constant.MarketingConstants;

public class AdminServiceApplyAssetVO {
	private long id;
	private long serviceApplyId;
	private String displayName;
	private String filePath;
	private String fileExt;
	private long fileSize;
	private Date createTime;
	private Date lastUpdate;
	private String status;
	private String realPath;

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

	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getFileExt() {
		return fileExt;
	}

	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}

	public long getFileSize() {
		return fileSize;
	}

	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
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
	public String getRealPath() {
		if(StringUtils.isNotBlank(filePath)) {
			realPath = filePath.replace(MarketingConstants.MARKETING_IMAGE_BASE_PATH, MarketingConstants.PIC_MARKETING);
		} else {
			realPath = "";
		}
		
		return realPath;
	}
}
