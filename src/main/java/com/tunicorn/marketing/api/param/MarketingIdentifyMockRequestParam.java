package com.tunicorn.marketing.api.param;

import java.io.Serializable;

import org.apache.commons.lang3.StringUtils;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tunicorn.common.api.param.IRequestParam;

public class MarketingIdentifyMockRequestParam implements IRequestParam, Serializable {

	private static final long serialVersionUID = -3072995293797528827L;

	private String imagePath;


	public String getImagePath() {
		return imagePath;
	}


	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	@Override
	public String convertToJSON() {
		ObjectNode node = mapper.createObjectNode();

		if (StringUtils.isNotBlank(imagePath)) {
			node.put("img_path", imagePath);
		}
		return node.toString();
	}

}
