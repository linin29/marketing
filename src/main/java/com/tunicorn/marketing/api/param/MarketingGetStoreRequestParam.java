package com.tunicorn.marketing.api.param;

import java.io.Serializable;
import java.net.URLEncoder;

import com.tunicorn.common.api.param.IRequestParam;

public class MarketingGetStoreRequestParam implements IRequestParam, Serializable {

	private static final long serialVersionUID = 6305170072319540211L;

	private String taskId;
	private String token;

	public String getTaskId() {
		return taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	@Override
	public String convertToJSON() {
		/*
		 * ObjectNode node = mapper.createObjectNode();
		 * 
		 * if (StringUtils.isNotBlank(taskId)) { node.put("TaskId", taskId); }
		 * if (StringUtils.isNotBlank(token)) { node.put("token", token); }
		 */
		return "TaskId=" + URLEncoder.encode(taskId) + "&token=" + URLEncoder.encode(token);
	}

}
