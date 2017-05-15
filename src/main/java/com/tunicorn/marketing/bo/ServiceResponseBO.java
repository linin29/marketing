package com.tunicorn.marketing.bo;

public class ServiceResponseBO {

	private boolean success;
	private Object result;

	public ServiceResponseBO() {

	}

	public ServiceResponseBO(Object result) {
		this.success = true;
		this.result = result;
	}

	public ServiceResponseBO(boolean success, String result) {
		this.success = success;
		this.result = result;
	}

	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}

	public Object getResult() {
		return result;
	}

	public void setResult(Object result) {
		this.result = result;
	}

}
