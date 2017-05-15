package com.tunicorn.marketing.entity;

import org.apache.commons.lang.StringUtils;

import com.tunicorn.marketing.vo.ApplicationVO;

public class AppKeySecretEntity {
	private ApplicationVO application;
	private String errMsg;

	public AppKeySecretEntity(String errMsg) {
		this.errMsg = errMsg;
	}

	public AppKeySecretEntity(ApplicationVO application) {
		this.application = application;
	}

	public ApplicationVO getApplication() {
		return application;
	}

	public void setApplication(ApplicationVO application) {
		this.application = application;
	}

	public String getErrMsg() {
		return errMsg;
	}

	public void setErrMsg(String errMsg) {
		this.errMsg = errMsg;
	}

	public boolean isValid() {
		return (application != null) && StringUtils.isBlank(errMsg);
	}
}
