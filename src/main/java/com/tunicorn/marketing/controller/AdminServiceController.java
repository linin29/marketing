package com.tunicorn.marketing.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.tunicorn.marketing.service.AdminUserService;
import com.tunicorn.marketing.vo.UserVO;

@Controller
@RequestMapping("/admin/service")
@EnableAutoConfiguration
public class AdminServiceController extends BaseController{

	@Autowired
	private AdminUserService adminUserService;
	
	@RequestMapping(value = "/apply", method = RequestMethod.GET)
	public String serviceApply(HttpServletRequest request, HttpServletResponse resp, Model model) {
		UserVO user = getCurrentUser(request);
		return "admin/service/service_apply";
	}
}
