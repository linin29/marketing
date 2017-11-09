package com.tunicorn.marketing.controller;

import java.util.Calendar;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;

import com.tunicorn.common.Constant;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.vo.AdminUserVO;
import com.tunicorn.marketing.vo.UserVO;

@Controller
@EnableAutoConfiguration
public class BaseController {

	public UserVO getCurrentUser(HttpServletRequest request) {
		Object obj = request.getSession().getAttribute(Constant.SESSION_USER);
		return obj == null ? null : (UserVO) obj;
	}

	public AdminUserVO getCurrentAdminUser(HttpServletRequest request) {
		Object obj = request.getSession().getAttribute(MarketingConstants.SESSION_ADMIN_USER);
		return obj == null ? null : (AdminUserVO) obj;
	}

	public Date getBefore2Day(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.DAY_OF_MONTH, -2);
		date = calendar.getTime();
		return date;
	}
}
