package com.tunicorn.marketing.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.fasterxml.jackson.databind.JsonNode;
import com.tunicorn.common.Constant;
import com.tunicorn.marketing.service.AdminUserService;
import com.tunicorn.marketing.utils.CookieUtils;
import com.tunicorn.marketing.vo.UserVO;
import com.tunicorn.util.SecurityUtils;

public class AdminLoginInterceptor extends HandlerInterceptorAdapter {
	private static Logger logger = Logger.getLogger(AdminLoginInterceptor.class);

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		UserVO user = (UserVO) request.getSession().getAttribute(Constant.SESSION_USER);
		String contextPath = request.getContextPath();
		if (user == null) {
			String tokenCookie = CookieUtils.getTokenCookie(request);

			if (tokenCookie != null) {
				JsonNode json = SecurityUtils.vefifyAuthToken(tokenCookie);
				if (json != null) {
					String userID = json.get("userID").toString();
					BeanFactory factory = WebApplicationContextUtils
							.getRequiredWebApplicationContext(request.getServletContext());

					AdminUserService userService = (AdminUserService) factory.getBean("adminUserService");
					user = userService.getUserByID(userID);

					if (user != null) {
						request.getSession().setAttribute(Constant.SESSION_USER, user);
					}

				}
			}
		}

		if (user == null) {
			logger.error("Login required for : " + request.getRequestURL());

			String ajaxRquestFlag = request.getHeader("X-Requested-With");
			if (StringUtils.equals(ajaxRquestFlag, "XMLHttpRequest")) {
				response.setStatus(911);
				response.setHeader("sessionStatus", "timeout");
				response.addHeader("loginPath", contextPath + "/admin/login");
				response.getWriter().write("goto_login");
			} else {
				response.sendRedirect(contextPath + "/admin/login");
			}

			return false;
		}

		return super.preHandle(request, response, handler);
	}
}
