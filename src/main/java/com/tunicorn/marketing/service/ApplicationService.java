package com.tunicorn.marketing.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tunicorn.marketing.mapper.ApplicationMapper;
import com.tunicorn.marketing.vo.ApplicationVO;

@Service
public class ApplicationService {
	@Autowired
	private ApplicationMapper applicationMapper;

	public ApplicationVO getApplicationByKeyAndSecret (String key, String secret) {
		return applicationMapper.getApplicationByKeyAndSecret(key, secret);
	}
}
