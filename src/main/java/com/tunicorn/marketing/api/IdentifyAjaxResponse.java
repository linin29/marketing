package com.tunicorn.marketing.api;

import java.util.UUID;

import com.fasterxml.jackson.databind.node.ArrayNode;

public class IdentifyAjaxResponse {
	private Boolean success;
	private Object data;
	private int errcode;
	private String errmsg;
	private String requestId;
	private Object rows;
	private ArrayNode crops;
	private ArrayNode rows_length;
	private String results_border;

	private IdentifyAjaxResponse(Object data) {
		this.success = true;
		this.data = data;
	}

	private IdentifyAjaxResponse(Object data, Object rows) {
		this.success = true;
		this.data = data;
		this.rows = rows;
	}

	private IdentifyAjaxResponse(Object data, Object rows, ArrayNode crops, ArrayNode rows_length) {
		this.success = true;
		this.data = data;
		this.rows = rows;
		this.crops = crops;
		this.rows_length = rows_length;
	}

	private IdentifyAjaxResponse(Object data, Object rows, ArrayNode crops, ArrayNode rows_length, String results_border) {
		this.success = true;
		this.data = data;
		this.rows = rows;
		this.crops = crops;
		this.rows_length = rows_length;
		this.results_border = results_border;
		
	}
	private IdentifyAjaxResponse(int errcode, String errmsg) {
		this.success = false;
		this.errcode = errcode;
		this.errmsg = errmsg;
		this.requestId = UUID.randomUUID().toString();
	}

	public static IdentifyAjaxResponse toSuccess(Object data) {
		return new IdentifyAjaxResponse(data);
	}

	public static IdentifyAjaxResponse toFailure(int errorCode, String errorMessage) {
		return new IdentifyAjaxResponse(errorCode, errorMessage);
	}

	public static IdentifyAjaxResponse toSuccess(Object data, Object rows) {
		return new IdentifyAjaxResponse(data, rows);
	}

	public static IdentifyAjaxResponse toSuccess(Object data, Object rows, ArrayNode crops, ArrayNode rows_length) {
		return new IdentifyAjaxResponse(data, rows, crops, rows_length);
	}

	public static IdentifyAjaxResponse toSuccess(Object data, Object rows, ArrayNode crops, ArrayNode rows_length, String results_border) {
		return new IdentifyAjaxResponse(data, rows, crops, rows_length, results_border);
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

	public Object getRows() {
		return rows;
	}

	public void setRows(Object rows) {
		this.rows = rows;
	}

	public ArrayNode getCrops() {
		return crops;
	}

	public void setCrops(ArrayNode crops) {
		this.crops = crops;
	}

	public ArrayNode getRows_length() {
		return rows_length;
	}

	public void setRows_length(ArrayNode rows_length) {
		this.rows_length = rows_length;
	}

	public String getResults_border() {
		return results_border;
	}

	public void setResults_border(String results_border) {
		this.results_border = results_border;
	}

}
