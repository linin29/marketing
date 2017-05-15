package com.tunicorn.marketing.api;

import java.util.UUID;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

public class CommonAjaxResponse {
	private Boolean success;
	private Object data;
	private int errcode;
	private String errmsg;
	private String requestId;

	private CommonAjaxResponse(Object data) {
		this.success = true;
		this.data = data;
	}

	private CommonAjaxResponse(int errcode, String errmsg) {
		this.success = false;
		this.errcode = errcode;
		this.errmsg = errmsg;
		this.requestId = UUID.randomUUID().toString();
	}

	public static CommonAjaxResponse toSuccess(Object data) {
		return new CommonAjaxResponse(data);
	}

	public static CommonAjaxResponse toFailure(int errorCode, String errorMessage) {
		return new CommonAjaxResponse(errorCode, errorMessage);
	}

	public Boolean getSuccess() {
		return success;
	}

	public void setSuccess(Boolean success) {
		this.success = success;
	}

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}

	public int getErrcode() {
		return errcode;
	}

	public void setErrcode(int errcode) {
		this.errcode = errcode;
	}

	public String getErrmsg() {
		return errmsg;
	}

	public void setErrmsg(String errmsg) {
		this.errmsg = errmsg;
	}

	public String getRequestId() {
		return requestId;
	}

	public void setRequestId(String requestId) {
		this.requestId = requestId;
	}

	@Override
	public String toString() {
		ObjectMapper mapper = new ObjectMapper();
		ObjectNode node = mapper.createObjectNode();
		if (!success) {
			node.removeAll();
			node.put("success", this.success);
			node.put("errcode", this.errcode);
			node.put("errmsg", this.errmsg);
			node.put("requestId", this.requestId);
		} else {
			node.put("success", this.success);
		}
		return node.toString();
	}
}
