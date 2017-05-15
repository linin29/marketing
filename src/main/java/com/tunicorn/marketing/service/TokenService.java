package com.tunicorn.marketing.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tunicorn.marketing.mapper.TokenMapper;
import com.tunicorn.marketing.vo.TokenVO;

@Service
public class TokenService {
	@Autowired
	private TokenMapper tokenMapper;

	public TokenVO getToken(String token, long currentTime) {
		return tokenMapper.getToken(token, currentTime);
	}
	
	public TokenVO getToken(int appId, String userId, String clientId) {
		return tokenMapper.getTokenByInfo(appId, userId, clientId); 
	}
	
	public void insertToken(TokenVO tokenVO) {
		tokenMapper.insertToken(tokenVO);
	}
	
	public void deleteToekn(String token) {
		tokenMapper.deleteToekn(token);
	}
}
