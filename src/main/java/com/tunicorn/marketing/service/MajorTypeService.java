package com.tunicorn.marketing.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tunicorn.marketing.bo.MajorTypeBO;
import com.tunicorn.marketing.mapper.MajorTypeMapper;
import com.tunicorn.marketing.vo.MajorTypeVO;

@Service
public class MajorTypeService {

	@Autowired
	private MajorTypeMapper majorTypeMapper;

	public int createMajorType(MajorTypeVO majorTypeVO) {
		return majorTypeMapper.createMajorType(majorTypeVO);
	}

	public int updateMajorType(MajorTypeVO majorTypeVO) {
		return majorTypeMapper.updateMajorType(majorTypeVO);
	}

	public List<MajorTypeVO> getMajorTypeListByBO(MajorTypeBO majorTypeBO) {
		return majorTypeMapper.getMajorTypeListByBO(majorTypeBO);
	}

	public int getMajorTypeCount(MajorTypeBO majorTypeBO) {
		return majorTypeMapper.getMajorTypeCount(majorTypeBO);
	}
}
