package com.tunicorn.marketing.api.param;

import java.io.Serializable;

import org.apache.commons.lang3.StringUtils;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tunicorn.common.api.param.IRequestParam;

public class MarketingPriceIdentifyRequestParam implements IRequestParam, Serializable {
	private static final long serialVersionUID = -4124497689665609109L;

	private String img_url;
	private String majorType;

	public String getImg_url() {
		return img_url;
	}

	public void setImg_url(String img_url) {
		this.img_url = img_url;
	}


	public String getMajorType() {
		return majorType;
	}

	public void setMajorType(String majorType) {
		this.majorType = majorType;
	}

	@Override
	public String convertToJSON() {
		ObjectNode node = mapper.createObjectNode();

		if (StringUtils.isNotBlank(img_url)) {
			node.put("img_url", img_url);
		}
		if (StringUtils.isNotBlank(majorType)) {
			node.put("majorType", majorType);
		}
		return node.toString();
	}

}
