package com.tunicorn.marketing.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tunicorn.marketing.bo.MajorTypeBO;
import com.tunicorn.marketing.mapper.MajorTypeMapper;
import com.tunicorn.marketing.vo.MajorTypeApiVO;
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
	
	public List<MajorTypeApiVO> getMajorTypeListForApi(){
		return majorTypeMapper.getMajorTypeListForApi();
	}
	
	public int getMajorTypeByName(String name){
		return majorTypeMapper.getMajorTypeByName(name);
	}
	
	public MajorTypeVO getMajorTypeById(long majorTypeId){
		return majorTypeMapper.getMajorTypeById(majorTypeId);
	}
}
