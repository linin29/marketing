package com.tunicorn.marketing.api;

import java.util.UUID;

public class ImageListAjaxResponse {
	private Boolean success;
	private Object data;
	private int errcode;
	private String errmsg;
	private String requestId;
	private int count;

	private ImageListAjaxResponse(Object data) {
		this.success = true;
		this.data = data;
	}

	private ImageListAjaxResponse(Object data, int count) {
		this.success = true;
		this.data = data;
		this.count = count;
	}

	private ImageListAjaxResponse(int errcode, String errmsg) {
		this.success = false;
		this.errcode = errcode;
		this.errmsg = errmsg;
		this.requestId = UUID.randomUUID().toString();
	}

	public static ImageListAjaxResponse toSuccess(Object data) {
		return new ImageListAjaxResponse(data);
	}

	public static ImageListAjaxResponse toFailure(int errorCode, String errorMessage) {
		return new ImageListAjaxResponse(errorCode, errorMessage);
	}

	public static ImageListAjaxResponse toSuccess(Object data, int count) {
		return new ImageListAjaxResponse(data, count);
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

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}
}
