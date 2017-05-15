package com.tunicorn.marketing.api;

import java.util.UUID;

public class TaskListAjaxResponse {
	private Boolean success;
	private Object data;
	private int errcode;
	private String errmsg;
	private String requestId;
	private int length;
	private int currentPage;
	private int pages;

	private TaskListAjaxResponse(Object data) {
		this.success = true;
		this.data = data;
	}

	private TaskListAjaxResponse(Object data, int length, int currentPage, int pages) {
		this.success = true;
		this.data = data;
		this.length = length;
		this.currentPage = currentPage;
		this.pages = pages;
	}

	private TaskListAjaxResponse(int errcode, String errmsg) {
		this.success = false;
		this.errcode = errcode;
		this.errmsg = errmsg;
		this.requestId = UUID.randomUUID().toString();
	}

	public static TaskListAjaxResponse toSuccess(Object data) {
		return new TaskListAjaxResponse(data);
	}

	public static TaskListAjaxResponse toFailure(int errorCode, String errorMessage) {
		return new TaskListAjaxResponse(errorCode, errorMessage);
	}

	public static TaskListAjaxResponse toSuccess(Object data, int length, int currentPage, int pages) {
		return new TaskListAjaxResponse(data, length, currentPage, pages);
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

	public int getLength() {
		return length;
	}

	public void setLength(int length) {
		this.length = length;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getPages() {
		return pages;
	}

	public void setPages(int pages) {
		this.pages = pages;
	}

}
