package com.tunicorn.marketing.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.tunicorn.marketing.bo.MajorTypeBO;
import com.tunicorn.marketing.mapper.MajorTypeMapper;
import com.tunicorn.marketing.vo.MajorTypeApiVO;
import com.tunicorn.marketing.vo.MajorTypeVO;

@Service
public class MajorTypeService {
 
	@Autowired
	private MajorTypeMapper majorTypeMapper;

	@Transactional
	public int createMajorType(MajorTypeVO majorTypeVO) {
		return majorTypeMapper.createMajorType(majorTypeVO);
	}

	@Transactional
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
	
	public int getMajorTypeCountByName(String name){
		return majorTypeMapper.getMajorTypeCountByName(name);
	}
	
	public MajorTypeVO getMajorTypeById(long majorTypeId){
		return majorTypeMapper.getMajorTypeById(majorTypeId);
	}
	
	public List<MajorTypeVO> getMajorTypeList(String username){
		return majorTypeMapper.getMajorTypeList(username);
	}
	
	public List<MajorTypeVO> getAllMajorTypeList(){
		return majorTypeMapper.getAllMajorTypeList();
	}
}
