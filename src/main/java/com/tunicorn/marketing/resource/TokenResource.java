package com.tunicorn.marketing.resource;


import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.tunicorn.common.api.Message;
import com.tunicorn.marketing.api.MarketingRestAPIResponse;
import com.tunicorn.marketing.service.ApplicationService;
import com.tunicorn.marketing.service.TokenService;
import com.tunicorn.marketing.utils.ConfigUtils;
import com.tunicorn.marketing.vo.ApplicationVO;
import com.tunicorn.marketing.vo.TokenVO;
import com.tunicorn.util.MessageUtils;

@RestController
@EnableAutoConfiguration
@RequestMapping(value = "/api/v1/oauth", produces = "application/json;charset=utf-8")
@Validated
public class TokenResource extends BaseResource {
	private static Logger logger = Logger.getLogger(TokenResource.class);
	@Autowired
	private ApplicationService applicationService;
	@Autowired
	private TokenService tokenService;
	
	@RequestMapping(value = "/token", method = RequestMethod.POST)
	@ResponseBody
	public synchronized String  createTask(HttpServletRequest request,
			@RequestParam(value = "grant_type") String grantType,
			@RequestParam(value = "client_id") String clientId,
			@RequestParam(value = "client_secret") String clientSecret) {
		ApplicationVO app = applicationService.getApplicationByKeyAndSecret(clientId, clientSecret);
		if (app==null) {
			Message message = MessageUtils.getInstance().getMessage("key_secret_invalid");
			MarketingRestAPIResponse rsp = new MarketingRestAPIResponse(message.getCode(), message.getMessage());
			logger.info("request_id:" + rsp.getRequestId() + ";App-Key:" + clientId + ",app-key或app-secret不合法");
			return rsp.toString();
		}
		
		TokenVO tokenVO = tokenService.getToken(app.getId(), app.getUserId(), clientId); 
		long currentTime = System.currentTimeMillis();
		String token = null;
		
		if(tokenVO==null || tokenVO.getExpiresTime()-5000<currentTime){
			if(tokenVO != null){
				tokenService.deleteToekn(tokenVO.getAccessToken());
			}
			tokenVO = new TokenVO();
			token = RandomStringUtils.randomAlphanumeric(64);
			logger.info(token);
			tokenVO.setAccessToken(token);
			tokenVO.setAppId(app.getId());
			tokenVO.setUserId(app.getUserId());
			tokenVO.setClientId(clientId);
			String expiresTime = ConfigUtils.getInstance().getConfigValue("token.expires.time");
			tokenVO.setExpiresTime(currentTime + Long.parseLong(expiresTime)*1000);
			tokenService.insertToken(tokenVO);
		}else{
			token = tokenVO.getAccessToken();
		}
		MarketingRestAPIResponse rsp = new MarketingRestAPIResponse();
		rsp.setData("access_token", token);
		rsp.setData("expires_in", ConfigUtils.getInstance().getConfigValue("token.expires.time"));
		rsp.setData("token_type", "Bearer");
		return rsp.toString();
	}

}
