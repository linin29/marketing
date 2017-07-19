package com.tunicorn.marketing.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tunicorn.common.api.Message;
import com.tunicorn.common.api.RestAPIResponse;
import com.tunicorn.common.entity.AjaxResponse;
import com.tunicorn.marketing.bo.UserBO;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.service.UserService;
import com.tunicorn.marketing.vo.UserVO;
import com.tunicorn.util.MessageUtils;

@Controller 
@EnableAutoConfiguration
public class UserController extends BaseController {
	private static Logger logger = Logger.getLogger(UserController.class);
	@Autowired
	private UserService userService;

	/**
	 * admin update password
	 * 
	 * @param user
	 * @return
	 */
	@RequestMapping(value = "/user/password", method = RequestMethod.POST)
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
	 * 
	 * @param
	 * @return
	 */
	@RequestMapping(value = "/user/personcenter", method = RequestMethod.GET)
	public String personCenter() {
		return "user/personcenter";
	}

	/**
	 * user update password itself
	 * 
	 * @param
	 * @return
	 */
	@RequestMapping(value = "/user/personcenter/password", method = RequestMethod.POST)
	@ResponseBody
	public RestAPIResponse updateUserPassword(@RequestBody UserVO user, HttpServletRequest request) {
		UserVO sessionUser = getCurrentUser(request);
		UserVO dbUser = userService.getLoginUser(sessionUser.getUserName());
		if (!userService.isValidUser(dbUser, user.getPassword())) {
			Message message = MessageUtils.getInstance().getMessage("user_name_password_error");
			logger.info(message.getMessage());
			return new RestAPIResponse(message.getCode(), message.getMessage());
		} else if (userService.updatePassword(user)) {
			return new RestAPIResponse(null);
		} else {
			Message message = MessageUtils.getInstance().getMessage("update_db_error");
			logger.info(message.getMessage());
			return new RestAPIResponse(message.getCode(), message.getMessage());
		}
	}

	@RequestMapping(value = "/user/create", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponse createUser(@RequestBody UserVO user, HttpServletRequest request) {
		UserVO userVO = userService.getUserByUserName(user.getUserName());
		if (userVO != null) {
			Message message = MessageUtils.getInstance().getMessage("user_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		int result = userService.createUserWithRoleMapping(user);
		if (result == 0) {
			Message message = MessageUtils.getInstance().getMessage("marketing_user_create_failed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		return AjaxResponse.toSuccess(null);
	}

	@RequestMapping(value = "/admin/user", method = RequestMethod.GET)
	public String userList(HttpServletRequest request, Model model) {
		UserBO userBO = new UserBO();
		if (StringUtils.isNotBlank(request.getParameter("pageNum"))) {
			userBO.setPageNum(Integer.parseInt(request.getParameter("pageNum")));
		}
		List<UserVO> userVOs = userService.getUserListByBO(userBO);
		int totalCount = userService.getUserCount(userBO);

		model.addAttribute("users", userVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", userBO.getPageNum() + 1);
		return "admin/user/user";
	}

	@RequestMapping(value = "/admin/user/{userId}/update", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponse updateUser(HttpServletRequest request, @PathVariable("userId") String userId,
			@RequestBody UserVO user) {
		user.setId(userId);
		UserVO userVO = userService.getUserByID(userId);
		if (userVO == null) {
			Message message = MessageUtils.getInstance().getMessage("user_not_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		userService.updateUser(user);
		return AjaxResponse.toSuccess(null);
	}

	@RequestMapping(value = "/admin/user/{userId}/resetPwd", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponse resetPwd(HttpServletRequest request, @PathVariable("userId") String userId) {
		UserVO user = new UserVO();
		user.setId(userId);
		UserVO userVO = userService.getUserByID(userId);
		if (userVO == null) {
			Message message = MessageUtils.getInstance().getMessage("user_not_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		user.setNewPassword(MarketingConstants.TIANNUO_PASSWORD);
		userService.updatePassword(user);
		return AjaxResponse.toSuccess(null);
	}
}
