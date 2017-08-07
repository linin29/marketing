package com.tunicorn.marketing.bo;

import com.fasterxml.jackson.databind.node.ArrayNode;

public class ImageCropBO {
	private int order;
	private ArrayNode imageCrop;
	private String imageId;
	private String majorType;

	public int getOrder() {
		return order;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	public ArrayNode getImageCrop() {
		return imageCrop;
	}

	public void setImageCrop(ArrayNode imageCrop) {
		this.imageCrop = imageCrop;
	}

	public String getImageId() {
		return imageId;
	}

	public void setImageId(String imageId) {
		this.imageId = imageId;
	}

	public String getMajorType() {
		return majorType;
	}

	public void setMajorType(String majorType) {
		this.majorType = majorType;
	}

}
