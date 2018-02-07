package com.tunicorn.marketing.vo;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import org.apache.commons.lang3.StringUtils;

import com.tunicorn.marketing.constant.MarketingConstants;

public class AdminServiceApplyVO {
	private long id;
	private int userId;
	private int creatorId;
	private String projectId;
	private Timestamp startTime;
	private Timestamp endTime;
	private String applyStatus;
	private Date createTime;
	private Date lastUpdate;
	private String status;
	private List<MajorTypeVO> majorTypes;
	private UserVO creator;
	private String statusStr;
	@NotNull(message="用户名不能为空")
	@Size(max=80, min=1, message="用户名长度在1-80个字符之内")
	@Pattern(regexp="^[a-zA-Z0-9_\u4e00-\u9fa5]+$", message="用户名只能包含字母、数字和下划线")
	private String username;
	@NotNull(message="邮箱不能为空")
	@Pattern(regexp = "^(\\w)+(.\\w+)*@(\\w)+((.\\w+)+)$", message="邮箱格式不正确")
	private String email;
	private String rejectReason;
	private String appKey;
	private String appSecret;
	private float contractedValue;
	private String contractedNo;
	private ProjectVO project;
	private String startTimeStr;
	private String endTimeStr;
	private int taskCount;
	private int callCount;

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

	public String getAppKey() {
		return appKey;
	}

	public void setAppKey(String appKey) {
		this.appKey = appKey;
	}

	public String getAppSecret() {
		return appSecret;
	}

	public void setAppSecret(String appSecret) {
		this.appSecret = appSecret;
	}

	public float getContractedValue() {
		return contractedValue;
	}

	public void setContractedValue(float contractedValue) {
		this.contractedValue = contractedValue;
	}

	public String getContractedNo() {
		return contractedNo;
	}

	public void setContractedNo(String contractedNo) {
		this.contractedNo = contractedNo;
	}

	public String getProjectId() {
		return projectId;
	}

	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}

	public Timestamp getStartTime() {
		return startTime;
	}

	public void setStartTime(Timestamp startTime) {
		this.startTime = startTime;
	}

	public Timestamp getEndTime() {
		return endTime;
	}

	public void setEndTime(Timestamp endTime) {
		this.endTime = endTime;
	}

	public ProjectVO getProject() {
		return project;
	}

	public void setProject(ProjectVO project) {
		this.project = project;
	}

	public int getTaskCount() {
		return taskCount;
	}

	public void setTaskCount(int taskCount) {
		this.taskCount = taskCount;
	}

	public int getCallCount() {
		return callCount;
	}

	public void setCallCount(int callCount) {
		this.callCount = callCount;
	}

	public String getStatusStr() {
		if (StringUtils.isNotBlank(applyStatus)) {
			statusStr = MarketingConstants.SERVICE_STATUS_NAME_MAPPING.get(applyStatus);
		}

		return statusStr;
	}

	public String getStartTimeStr() {
		if (StringUtils.isBlank(startTimeStr) && startTime != null) {
			startTimeStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(startTime);
		}

		return startTimeStr;
	}

	public String getEndTimeStr() {
		if (StringUtils.isBlank(endTimeStr) && endTime != null) {
			endTimeStr = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(endTime);
		}

		return endTimeStr;
	}
}
