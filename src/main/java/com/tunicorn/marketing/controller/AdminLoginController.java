package com.tunicorn.marketing.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tunicorn.common.Constant;
import com.tunicorn.common.api.Message;
import com.tunicorn.common.api.RestAPIResponse;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.service.AdminUserService;
import com.tunicorn.marketing.utils.ConfigUtils;
import com.tunicorn.marketing.utils.CookieUtils;
import com.tunicorn.marketing.vo.AdminUserVO;
import com.tunicorn.util.MessageUtils;

@Controller
@RequestMapping("/admin")
@EnableAutoConfiguration
public class AdminLoginController {

	private static Logger logger = Logger.getLogger(LoginController.class);

	@Autowired
	private AdminUserService adminUserService;

	/**
	 * Login page
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "/login", "/" }, method = RequestMethod.GET)
	public String index(HttpServletRequest request, Model model) {
		AdminUserVO user = (AdminUserVO) request.getSession().getAttribute(MarketingConstants.SESSION_ADMIN_USER);
		String isOpen = ConfigUtils.getInstance().getConfigValue("register.isOpen");
		boolean regiserable = false;
		if (StringUtils.isNotEmpty(isOpen) && isOpen.equals("true")) {
			regiserable = true;
		}
		model.addAttribute("regiserable", regiserable);
		if (user == null) {
			return "admin/login/login";
		} else {
			return "redirect:admin/dashboard/index";
		}
	}

	/**
	 * login authentication
	 * 
	 * @param user
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/login", method = RequestMethod.POST, consumes = "application/json")
	@ResponseBody
	public RestAPIResponse auth(@RequestBody AdminUserVO user, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String userName = user.getUserName();
		String password = user.getPassword();
		if (StringUtils.isEmpty(userName.trim()) || StringUtils.isEmpty(password.trim())) {
			Message message = MessageUtils.getInstance().getMessage("user_name_password_error");
			logger.info(message.getMessage());
			return new RestAPIResponse(message.getCode(), message.getMessage());
		}
		AdminUserVO dbUser = adminUserService.getLoginUser(userName);
		if (dbUser == null) {
			Message message = MessageUtils.getInstance().getMessage("user_not_existed");
			logger.info(message.getMessage());
			return new RestAPIResponse(message.getCode(), message.getMessage());
		}
		if (adminUserService.isValidUser(dbUser, password)) {
			request.getSession().setAttribute(MarketingConstants.SESSION_ADMIN_USER, dbUser);
			CookieUtils.setTokenCookie(response, dbUser);
			return new RestAPIResponse(null);
		}
		Message message = MessageUtils.getInstance().getMessage("user_name_password_error");
		logger.info(message.getMessage());
		return new RestAPIResponse(message.getCode(), message.getMessage());
	}

	/**
	 * logout
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout(HttpServletRequest request, HttpServletResponse response) {
		request.getSession().removeAttribute(MarketingConstants.SESSION_ADMIN_USER);
		CookieUtils.removeCookie(request, response, Constant.COOKIE_TOKEN);
		return "redirect:login";
	}

}
