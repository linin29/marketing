package com.tunicorn.marketing.bo;

public class GoodsBO {

	private String goods_name;
	private String goods_desc;
	private String ratio;
	private String num;
	private Boolean isShow;
	private String rows;
	private String ori_area;

	public String getRows() {
		return rows;
	}

	public void setRows(String rows) {
		this.rows = rows;
	}

	public Boolean getIsShow() {
		return isShow;
	}

	public void setIsShow(Boolean isShow) {
		this.isShow = isShow;
	}

	public String getGoods_name() {
		return goods_name;
	}

	public void setGoods_name(String goods_name) {
		this.goods_name = goods_name;
	}

	public String getGoods_desc() {
		return goods_desc;
	}

	public void setGoods_desc(String goods_desc) {
		this.goods_desc = goods_desc;
	}

	public String getRatio() {
		return ratio;
	}

	public void setRatio(String ratio) {
		this.ratio = ratio;
	}

	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}

	public String getOri_area() {
		return ori_area;
	}

	public void setOri_area(String ori_area) {
		this.ori_area = ori_area;
	}

}
