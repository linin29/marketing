package com.tunicorn.marketing.api.param;

import java.io.Serializable;

import org.apache.commons.lang3.StringUtils;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tunicorn.common.api.param.IRequestParam;

public class MarketingIdentifyRequestParam implements IRequestParam, Serializable {

	private static final long serialVersionUID = -3072995293797528827L;

	private String task_id;
	private String major_type;


	public String getTask_id() {
		return task_id;
	}

	public void setTask_id(String task_id) {
		this.task_id = task_id;
	}

	public String getMajor_type() {
		return major_type;
	}

	public void setMajor_type(String major_type) {
		this.major_type = major_type;
	}

	@Override
	public String convertToJSON() {
		ObjectNode node = mapper.createObjectNode();

		if (StringUtils.isNotBlank(major_type)) {
			node.put("major_type", major_type);
		}
		node.put("task_id", task_id);
		return node.toString();
	}

}
