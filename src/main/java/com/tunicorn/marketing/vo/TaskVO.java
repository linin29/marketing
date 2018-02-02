package com.tunicorn.marketing.vo;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.lang3.StringUtils;

import com.tunicorn.marketing.bo.PaginationBO;

public class TaskVO extends PaginationBO {
	private String id;
	private String _id;
	private String name;
	private String taskStatus;
	private String userId;
	private Date createTime;
	private Date lastUpdateTime;
	private String status;
	private String stitchImagePath;
	private Object result;
	private String rows;
	private String majorType;
	private String author;
	private Date createdAt;
	private Date updatedAt;
	private String startTime;
	private String endTime;
	private String goodsInfo;
	private long identifySuccessTimes;
	private String majorTypeName;
	private int needStitch;
	/**************2018-02-02 weixiaokai 添加项目id*****************/
	private String projectId;

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public Date getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String get_id() {
		return _id;
	}

	public void set_id(String _id) {
		this._id = _id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTaskStatus() {
		return taskStatus;
	}

	public void setTaskStatus(String taskStatus) {
		this.taskStatus = taskStatus;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
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

	public String getStitchImagePath() {
		return stitchImagePath;
	}

	public void setStitchImagePath(String stitchImagePath) {
		this.stitchImagePath = stitchImagePath;
	}

	public Object getResult() {
		return result;
	}

	public void setResult(Object result) {
		this.result = result;
	}

	public String getRows() {
		return rows;
	}

	public void setRows(String rows) {
		this.rows = rows;
	}

	public String getMajorType() {
		return majorType;
	}

	public void setMajorType(String majorType) {
		this.majorType = majorType;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getGoodsInfo() {
		return goodsInfo;
	}

	public void setGoodsInfo(String goodsInfo) {
		this.goodsInfo = goodsInfo;
	}

	public long getIdentifySuccessTimes() {
		return identifySuccessTimes;
	}

	public void setIdentifySuccessTimes(long identifySuccessTimes) {
		this.identifySuccessTimes = identifySuccessTimes;
	}

	public String getMajorTypeName() {
		return majorTypeName;
	}

	public void setMajorTypeName(String majorTypeName) {
		this.majorTypeName = majorTypeName;
	}

	public int getNeedStitch() {
		return needStitch;
	}

	public void setNeedStitch(int needStitch) {
		this.needStitch = needStitch;
	}

	/////////////////////////////////////

	private String createTimeStr;
	private String lastUpdateTimeStr;

	public String getCreateTimeStr() {
		return getTimeStr(createTime, createTimeStr);
	}

	public String getLastUpdateTimeStr() {
		return getTimeStr(lastUpdateTime, lastUpdateTimeStr);
	}

	private String getTimeStr(Date time, String timeStr) {
		if (StringUtils.isEmpty(timeStr)) {
			if (time != null) {
				timeStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(time);
			} else {
				timeStr = "";
			}
		}
		return timeStr;
	}

	public String getProjectId() {
		return projectId;
	}

	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}
	
}
