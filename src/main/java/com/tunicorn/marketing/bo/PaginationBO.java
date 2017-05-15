package com.tunicorn.marketing.bo;

import com.tunicorn.marketing.constant.MarketingConstants;

public class PaginationBO {
	private int perPage = MarketingConstants.PAGINATION_ITEMS_PER_PAGE;
	private int pageNum = 0;
	
	private int startNum;
	
	public int getPerPage() {
		return perPage;
	}

	public void setPerPage(int perPage) {
		this.perPage = perPage;
	}

	public int getPageNum() {
		return pageNum;
	}

	public void setPageNum(int pageNum) {
		this.pageNum = pageNum;
	}

	public int getStartNum() {
		startNum = perPage * pageNum;
		return startNum;
	}
}
