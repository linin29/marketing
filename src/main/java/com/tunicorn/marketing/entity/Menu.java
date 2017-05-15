package com.tunicorn.marketing.entity;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Menu implements Serializable {
	private static final long serialVersionUID = 5715994179368303180L;
	
	private String name;
	private String url;
	private int order;
	
	private List<Menu> subMenus;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public int getOrder() {
		return order;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	public List<Menu> getSubMenus() {
		if(subMenus == null) {
			subMenus = new ArrayList<Menu>();
		}
		
		return subMenus;
	}

	public void setSubMenus(List<Menu> subMenus) {
		this.subMenus = subMenus;
	}
}
