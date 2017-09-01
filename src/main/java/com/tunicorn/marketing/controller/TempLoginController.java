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
import com.tunicorn.marketing.service.UserService;
import com.tunicorn.marketing.utils.ConfigUtils;
import com.tunicorn.marketing.utils.CookieUtils;
import com.tunicorn.marketing.vo.UserVO;
import com.tunicorn.util.MessageUtils;

@Controller
@EnableAutoConfiguration
public class TempLoginController {
	private static Logger logger = Logger.getLogger(TempLoginController.class);
	
	@Autowired
	private UserService userService;

	/**
	 * Login page
	 * 
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping(value = { "/showView/login", "/" }, method = RequestMethod.GET)
	public String index(HttpServletRequest request, Model model) {
		UserVO user = (UserVO) request.getSession().getAttribute(Constant.SESSION_USER);
		String isOpen = ConfigUtils.getInstance().getConfigValue("register.isOpen");
		boolean regiserable = false;
		if (StringUtils.isNotEmpty(isOpen) && isOpen.equals("true")) {
			regiserable = true;
		}
		model.addAttribute("regiserable", regiserable);
		if (user == null) {
			return "login/login_temp";
		} else {
			return "redirect:tasks";
		}
	}

	/**
	 * login authentication
	 * @param user
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "/showView/login", method = RequestMethod.POST, consumes = "application/json")
	@ResponseBody
	public RestAPIResponse auth(@RequestBody UserVO user, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String userName = user.getUserName();
		String password = user.getPassword();
		if (StringUtils.isEmpty(userName.trim()) || StringUtils.isEmpty(password.trim())) {
			Message message = MessageUtils.getInstance().getMessage("user_name_password_error");
			logger.info(message.getMessage());
			return new RestAPIResponse(message.getCode(), message.getMessage());
		}
		UserVO dbUser = userService.getLoginUser(userName);
		if (dbUser == null) {
			Message message = MessageUtils.getInstance().getMessage("user_not_existed");
			logger.info(message.getMessage());
			return new RestAPIResponse(message.getCode(), message.getMessage());
		}
		if (userService.isValidUser(dbUser, password)) {
			request.getSession().setAttribute(Constant.SESSION_USER, dbUser);
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
	@RequestMapping(value = "/showView/logout", method = RequestMethod.GET)
	public String logout(HttpServletRequest request, HttpServletResponse response) {
		request.getSession().removeAttribute(Constant.SESSION_USER);
		CookieUtils.removeCookie(request, response, Constant.COOKIE_TOKEN);
		return "redirect:showView/login";
	}

}
