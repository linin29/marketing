package com.tunicorn.marketing.api.param;

import java.io.Serializable;

import org.apache.commons.lang3.StringUtils;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tunicorn.common.api.param.IRequestParam;

public class MarketingStitcherRequestParam implements IRequestParam, Serializable {

	private static final long serialVersionUID = -1681802806771579462L;

	private String task_id;
	private boolean need_stitch;
	private String major_type;

	public String getTask_id() {
		return task_id;
	}

	public void setTask_id(String task_id) {
		this.task_id = task_id;
	}

	public boolean isNeed_stitch() {
		return need_stitch;
	}

	public void setNeed_stitch(boolean need_stitch) {
		this.need_stitch = need_stitch;
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
		node.put("need_stitch", need_stitch);

		return node.toString();
	}

}
