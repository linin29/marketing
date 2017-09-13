package com.tunicorn.marketing.bo;

import com.fasterxml.jackson.databind.node.ArrayNode;

public class MarkImageCropBO {
	private int order;
	private ArrayNode imageCrop;
	private String imageId;
	private String majorType;
	private String filePath;
	private String imagePath;

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

	public String getFilePath() {
		return filePath;
	}

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}

	public String getImagePath() {
		return imagePath;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	@Override
	public String toString() {
		return "MarkImageCropBO [order=" + order + ", imageCrop=" + imageCrop + ", imageId=" + imageId + ", majorType="
				+ majorType + ", filePath=" + filePath + ", imagePath=" + imagePath + "]";
	}

}
