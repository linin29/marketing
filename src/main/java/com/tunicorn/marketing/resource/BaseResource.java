package com.tunicorn.marketing.resource;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.web.bind.annotation.RestController;

import com.tunicorn.common.api.Message;
import com.tunicorn.common.api.RestAPIResponse;
import com.tunicorn.common.entity.AjaxResponse;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.entity.AppKeySecretEntity;
import com.tunicorn.marketing.service.ApplicationService;
import com.tunicorn.marketing.service.TokenService;
import com.tunicorn.marketing.vo.ApplicationVO;
import com.tunicorn.marketing.vo.TokenVO;
import com.tunicorn.util.MessageUtils;

@RestController
@EnableAutoConfiguration
public class BaseResource {
	private static Logger logger = Logger.getLogger(BaseResource.class);
	@Autowired
	private ApplicationService appService;
	@Autowired
	private TokenService tokenService;

	public AppKeySecretEntity checkAppKeySecret(HttpServletRequest request) {
		String key = request.getHeader(MarketingConstants.APP_KEY_HEADER_NAME);
		String secret = request.getHeader(MarketingConstants.APP_SECRET_HEADER_NAME);

		if (StringUtils.isBlank(key) || StringUtils.isBlank(secret)
				|| !MarketingConstants.APP_KEY_SECRET_PATTERN.matcher(key).matches()
				|| !MarketingConstants.APP_KEY_SECRET_PATTERN.matcher(secret).matches()) {
			Message message = MessageUtils.getInstance().getMessage("key_secret_invalid");
			RestAPIResponse response = new RestAPIResponse(message.getCode(), message.getMessage());
			logger.info("request_id:" + response.getRequestId() + ";App-Key:" + key + ",app-key或app-secret不合法");
			return new AppKeySecretEntity(response.toString());
		}

		ApplicationVO application = appService.getApplicationByKeyAndSecret(key, secret);
		if (application == null) {
			Message message = MessageUtils.getInstance().getMessage("key_secret_error");
			RestAPIResponse response = new RestAPIResponse(message.getCode(), message.getMessage());
			logger.info("request_id:" + response.getRequestId() + ";App-Key:" + key + ", App不存在");
			return new AppKeySecretEntity(response.toString());
		}
		return new AppKeySecretEntity(application);
	}

	public AjaxResponse checkToken(HttpServletRequest request) {
		String token = request.getHeader(MarketingConstants.TOKEN_HEADER_NAME);
		if (token != null && token.indexOf(" ") > 0) {
			token = token.split(" ")[1];
		} else {
			Message message = MessageUtils.getInstance().getMessage("token_not_avaliable");
			AjaxResponse response = AjaxResponse.toFailure(message.getCode(), message.getMessage());
			logger.info("request_id:" + response.getRequestId() + ";Token Header:" + token + "无效");
			return response;
		}

		if (StringUtils.isBlank(token) || !MarketingConstants.TOKEN_PATTERN.matcher(token).matches()) {
			Message message = MessageUtils.getInstance().getMessage("token_not_avaliable");
			AjaxResponse response = AjaxResponse.toFailure(message.getCode(), message.getMessage());
			logger.info("request_id:" + response.getRequestId() + ";Token:" + token + "无效");
			return response;
		}

		long currentTime = System.currentTimeMillis();
		TokenVO tokenVO = tokenService.getToken(token, currentTime);
		if (tokenVO == null) {
			Message message = MessageUtils.getInstance().getMessage("token_not_avaliable");
			AjaxResponse response = AjaxResponse.toFailure(message.getCode(), message.getMessage());
			logger.info("request_id:" + response.getRequestId() + ";Token:" + token + "无效");
			return response;
		}
		return AjaxResponse.toSuccess(tokenVO);
	}
}
