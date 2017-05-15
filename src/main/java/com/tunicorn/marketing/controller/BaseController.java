package com.tunicorn.marketing.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;

import com.tunicorn.common.Constant;
import com.tunicorn.marketing.vo.UserVO;

@Controller
@EnableAutoConfiguration
public class BaseController {

	public UserVO getCurrentUser(HttpServletRequest request) {
		Object obj = request.getSession().getAttribute(Constant.SESSION_USER);
		return obj == null ? null : (UserVO) obj;
	}
}
