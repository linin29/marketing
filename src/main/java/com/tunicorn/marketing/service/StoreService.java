package com.tunicorn.marketing.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tunicorn.marketing.mapper.StoreMapper;

@Service
public class StoreService {
	@Autowired
	private StoreMapper storeMapper;
	
	public int getStoreCountByProjectId(String projectId) {
		return storeMapper.getStoreCountByProjectId(projectId);
	}
}
