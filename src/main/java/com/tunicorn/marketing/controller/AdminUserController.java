package com.tunicorn.marketing.controller;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tunicorn.common.api.Message;
import com.tunicorn.common.api.RestAPIResponse;
import com.tunicorn.marketing.service.AdminUserService;
import com.tunicorn.marketing.vo.AdminUserVO;
import com.tunicorn.util.MessageUtils;

@Controller 
@RequestMapping("/admin")
@EnableAutoConfiguration
public class AdminUserController extends BaseController{
	private static Logger logger = Logger.getLogger(AdminUserController.class);
	@Autowired
	private AdminUserService adminUserService;

	/**
	 * admin update password
	 * 
	 * @param user
	 * @return
	 */
	@RequestMapping(value = "/user/password", method = RequestMethod.POST)
	@ResponseBody
	public RestAPIResponse updatePassword(@RequestBody AdminUserVO user, HttpServletRequest request) {
		if (adminUserService.updatePassword(user)) {
			return new RestAPIResponse(null);
		} else {
			Message message = MessageUtils.getInstance().getMessage("update_db_error");
			return new RestAPIResponse(message.getCode(), message.getMessage());
		}
	}

	/**
	 * person center
	 * 
	 * @param
	 * @return
	 */
	@RequestMapping(value = "/user/personcenter", method = RequestMethod.GET)
	public String personCenter() {
		return "admin/user/personcenter";
	}

	/**
	 * user update password itself
	 * 
	 * @param
	 * @return
	 */
	@RequestMapping(value = "/user/personcenter/password", method = RequestMethod.POST)
	@ResponseBody
	public RestAPIResponse updateUserPassword(@RequestBody AdminUserVO user, HttpServletRequest request) {
		AdminUserVO sessionUser = getCurrentAdminUser(request);
		AdminUserVO dbUser = adminUserService.getLoginUser(sessionUser.getUserName());
		if (!adminUserService.isValidUser(dbUser, user.getPassword())) {
			Message message = MessageUtils.getInstance().getMessage("user_name_password_error");
			logger.info(message.getMessage());
			return new RestAPIResponse(message.getCode(), message.getMessage());
		} else if (adminUserService.updatePassword(user)) {
			return new RestAPIResponse(null);
		} else {
			Message message = MessageUtils.getInstance().getMessage("update_db_error");
			logger.info(message.getMessage());
			return new RestAPIResponse(message.getCode(), message.getMessage());
		}
	}
}
