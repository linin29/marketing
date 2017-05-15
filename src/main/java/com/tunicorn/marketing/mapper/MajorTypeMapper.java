package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.bo.MajorTypeBO;
import com.tunicorn.marketing.vo.MajorTypeVO;

public interface MajorTypeMapper {

	@Results({ @Result(property = "createTime", column = "create_time") })
	@Select("select id, `name`, description, create_time from major_type where status='active'")
	public List<MajorTypeVO> getMajorTypeList();

	public int createMajorType(MajorTypeVO majorTypeVO);

	public int updateMajorType(MajorTypeVO majorTypeVO);

	public List<MajorTypeVO> getMajorTypeListByBO(MajorTypeBO majorTypeBO);

	public int getMajorTypeCount(MajorTypeBO majorTypeBO);
}
