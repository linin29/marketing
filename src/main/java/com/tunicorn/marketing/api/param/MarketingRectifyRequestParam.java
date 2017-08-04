package com.tunicorn.marketing.api.param;

import java.io.Serializable;

import org.apache.commons.lang3.StringUtils;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tunicorn.common.api.param.IRequestParam;

public class MarketingRectifyRequestParam implements IRequestParam, Serializable {

	private static final long serialVersionUID = 6305170072319540211L;

	private String taskId;
	private String majorType;

	public String getTaskId() {
		return taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	public String getMajorType() {
		return majorType;
	}

	public void setMajorType(String majorType) {
		this.majorType = majorType;
	}

	@Override
	public String convertToJSON() {
		ObjectNode node = mapper.createObjectNode();

		if (StringUtils.isNotBlank(taskId)) {
			node.put("task_id", taskId);
		}
		if (StringUtils.isNotBlank(majorType)) {
			node.put("major_type", majorType);
		}

		return node.toString();
	}

}
