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
import com.tunicorn.common.entity.AjaxResponse;
import com.tunicorn.marketing.service.UserService;
import com.tunicorn.marketing.vo.UserVO;
import com.tunicorn.util.MessageUtils;


@Controller
@RequestMapping(value = "/user")
@EnableAutoConfiguration
public class UserController extends BaseController {
	private static Logger logger = Logger.getLogger(UserController.class);
	@Autowired
	private UserService userService;

	
	/**
	 * admin update password
	 * @param user
	 * @return
	 */
	@RequestMapping(value = "/password", method = RequestMethod.POST)
	@ResponseBody
	public RestAPIResponse updatePassword(@RequestBody UserVO user, HttpServletRequest request) {  
		if (userService.updatePassword(user)) {
			return new RestAPIResponse(null);
		} else {
			Message message = MessageUtils.getInstance().getMessage("update_db_error");
			logger.info(message.getMessage());
			return new RestAPIResponse(message.getCode(), message.getMessage());
		}
	}
	
	
	/**
	 * person center
	 * @param 
	 * @return
	 */
	@RequestMapping(value = "/personcenter", method = RequestMethod.GET)
	public String personCenter() {
		return "user/personcenter";
	}
	
	/**
	 * user update password itself
	 * @param 
	 * @return
	 */
	@RequestMapping(value = "/personcenter/password", method = RequestMethod.POST)
	@ResponseBody
	public RestAPIResponse updateUserPassword(@RequestBody UserVO user, HttpServletRequest request) {
		UserVO sessionUser = getCurrentUser(request);
		UserVO dbUser = userService.getLoginUser(sessionUser.getUserName());
		if (!userService.isValidUser(dbUser, user.getPassword())){
			Message message = MessageUtils.getInstance().getMessage("user_name_password_error");
			logger.info(message.getMessage());
			return new RestAPIResponse(message.getCode(), message.getMessage());
		}else if (userService.updatePassword(user)) {
			return new RestAPIResponse(null);
		} else {
			Message message = MessageUtils.getInstance().getMessage("update_db_error");
			logger.info(message.getMessage());
			return new RestAPIResponse(message.getCode(), message.getMessage());
		}
	}
	
	@RequestMapping(value = "/create", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponse createUser(@RequestBody UserVO user, HttpServletRequest request) {
		UserVO userVO = userService.getUserByUserName(user.getUserName());
		if (userVO != null) {
			Message message = MessageUtils.getInstance().getMessage("user_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		int result = userService.createUser(user);
		if (result == 0) {
			Message message = MessageUtils.getInstance().getMessage("marketing_user_create_failed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		return AjaxResponse.toSuccess(null);
	}
}
