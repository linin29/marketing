package com.tunicorn.marketing.vo;

import java.util.Date;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import org.apache.commons.lang3.StringUtils;

import com.tunicorn.marketing.constant.MarketingConstants;

public class ProjectVO {

	private String id;
	@NotNull(message="项目名称不能为空")
	@Size(max=40, min=1, message="项目名称长度在1-40个字符之内")
	@Pattern(regexp="^[a-zA-Z0-9_\u4e00-\u9fa5]+$", message="项目名称只能是中文、英文、数字和下划线组合")
	private String name;
	@NotNull(message="地址不能为空")
	@Size(max=200, min=1, message="地址长度在1-200个字符之内")
	private String address;
	@NotNull(message="联系方式不能为空")
	@Pattern(regexp = "^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$", message="手机号格式不正确")
	private String mobile;
	@NotNull(message="联系人不能为空")
	@Size(max=80, min=1, message="联系人长度在1-80个字符之内")
	@Pattern(regexp="^[a-zA-Z0-9_\u4e00-\u9fa5]+$", message="联系人只能是中文、英文、数字和下划线组合")
	private String contacts;
	private String type;
	@NotNull(message="门店数不能为空")
	@Min(1)
	@Max(999999999)
	private int storeNumber;
	@NotNull(message="调用次数不能为空")
	@Min(1)
	@Max(999999999)
	private int callNumber;
	@NotNull(message="图片数不能为空")
	@Min(1)
	@Max(999999999)
	private int imageNumber;
	private float threshhold;
	private Date createTime;
	private Date lastUpdateTime;
	private String status;
	private String typeStr;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getContacts() {
		return contacts;
	}

	public void setContacts(String contacts) {
		this.contacts = contacts;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getStoreNumber() {
		return storeNumber;
	}

	public void setStoreNumber(int storeNumber) {
		this.storeNumber = storeNumber;
	}

	public int getCallNumber() {
		return callNumber;
	}

	public void setCallNumber(int callNumber) {
		this.callNumber = callNumber;
	}

	public int getImageNumber() {
		return imageNumber;
	}

	public void setImageNumber(int imageNumber) {
		this.imageNumber = imageNumber;
	}

	public float getThreshhold() {
		return threshhold;
	}

	public void setThreshhold(float threshhold) {
		this.threshhold = threshhold;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Date getLastUpdateTime() {
		return lastUpdateTime;
	}

	public void setLastUpdateTime(Date lastUpdateTime) {
		this.lastUpdateTime = lastUpdateTime;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getTypeStr() {
		if (StringUtils.isNotBlank(type)) {
			typeStr = MarketingConstants.PROJECT_TYPE_NAME_MAPPING.get(type);
		}

		return typeStr;
	}
}
