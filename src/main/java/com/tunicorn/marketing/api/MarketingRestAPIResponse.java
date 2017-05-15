package com.tunicorn.marketing.api;

import java.io.Serializable;
import java.util.UUID;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

public class MarketingRestAPIResponse implements Serializable {
	private static final long serialVersionUID = -5021964284964089157L;
	
	private ObjectMapper mapper = new ObjectMapper();
	private ObjectNode node = mapper.createObjectNode();
	private int errcode;
	private String errmsg;
	private Boolean success;
	private String requestId;

	// failure response
	public MarketingRestAPIResponse(int errcode, String errmsg) {
		this.success = false;
		this.errcode = errcode;
		this.errmsg = errmsg;
		this.requestId = UUID.randomUUID().toString();
	}
	
	// success response
	public MarketingRestAPIResponse(){
		this.success = true;
	}
	
	public void setData(String key, String vlaue) {
		this.node.put(key, vlaue);
	}
	
	public void setData(String key, Long vlaue) {
		this.node.put(key, vlaue);
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

	public Boolean getSuccess() {
		return success;
	}

	public void setSuccess(Boolean success) {
		this.success = success;
	}

	public String getRequestId() {
		return requestId;
	}

	public void setRequestId(String requestId) {
		this.requestId = requestId;
	}

	@Override
	public String toString() {
		if (!success) {
			node.removeAll();
			node.put("success", this.success);
			node.put("error_code", this.errcode);
			node.put("error_message", this.errmsg);
			node.put("request_id", this.requestId);
		} else {
			node.put("success", this.success);
		}
		return node.toString();
	}
}
