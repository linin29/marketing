package com.tunicorn.marketing.bo;

import com.fasterxml.jackson.databind.node.ArrayNode;

public class ImageCropBO {

	private int order;
	private ArrayNode imageCrop;

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

}
