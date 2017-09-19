package com.tunicorn.marketing.bo;

import java.io.File;

public class AnnotationBO {
	private String id;
	private String type;
	private File image;
	private File annotationXML;
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	
	public File getImage() {
		return image;
	}
	public void setImage(File image) {
		this.image = image;
	}
	public File getAnnotationXML() {
		return annotationXML;
	}
	public void setAnnotationXML(File annotationXML) {
		this.annotationXML = annotationXML;
	}
	
}
