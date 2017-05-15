package com.tunicorn.marketing.bo;

import java.util.List;

import com.tunicorn.marketing.vo.TaskVO;

public class TaskListForAPIBO {

	private boolean success;
	private List<TaskVO> data;
	private int length;
	private int currentPage;
	private int pages;

	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}

	public List<TaskVO> getData() {
		return data;
	}

	public void setData(List<TaskVO> data) {
		this.data = data;
	}

	public int getLength() {
		return length;
	}

	public void setLength(int length) {
		this.length = length;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getPages() {
		return pages;
	}

	public void setPages(int pages) {
		this.pages = pages;
	}

}
