package com.tunicorn.marketing.utils;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tunicorn.common.Constant;
import com.tunicorn.marketing.vo.UserVO;
import com.tunicorn.util.SecurityUtils;

public class CookieUtils {
	private static final String COOKIE_PATH = "/marketing";

	public static void setTokenCookie(HttpServletResponse response, UserVO user) throws JsonProcessingException {
		ObjectMapper mapper = new ObjectMapper();
		ObjectNode node = mapper.createObjectNode();
		node.put("userID", user.getId());
		String info = mapper.writeValueAsString(node);
		String tokenCookie = SecurityUtils.generateAuthToken(info);

		addCookie(response, Constant.COOKIE_TOKEN, tokenCookie, Constant.COOKIE_EXPIRATION * 60 * 60);
	}

	public static String getTokenCookie(HttpServletRequest request) {
		return getCookie(request, Constant.COOKIE_TOKEN);
	}

	private static void addCookie(HttpServletResponse response, String name, String value, int keepTime) {
		Cookie cookies = new Cookie(name, value);

		cookies.setPath(COOKIE_PATH);
		cookies.setMaxAge(keepTime);
		cookies.setHttpOnly(true);

		response.addCookie(cookies);
	}

	private static String getCookie(HttpServletRequest request, String name) {
		Cookie cookie = getCookieObj(request, name);
		if (cookie != null) {
			return cookie.getValue();
		}

		return null;
	}

	private static Cookie getCookieObj(HttpServletRequest request, String name) {
		Cookie[] cookies = request.getCookies();

		if (cookies == null) {
			return null;
		}

		for (int i = 0; i < cookies.length; i++) {
			if (cookies[i].getName().equals(name)) {
				return cookies[i];
			}
		}

		return null;
	}

	public static void removeCookie(HttpServletRequest request, HttpServletResponse response, String cookieName) {
		Cookie newCookie = getCookieObj(request, cookieName);
		if (newCookie != null) {
			newCookie.setPath(COOKIE_PATH);
			newCookie.setMaxAge(0);
			response.addCookie(newCookie);
		}
	}
}
