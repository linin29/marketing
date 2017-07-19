package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.bo.MajorTypeBO;
import com.tunicorn.marketing.vo.MajorTypeApiVO;
import com.tunicorn.marketing.vo.MajorTypeVO;

public interface MajorTypeMapper {

	@Results({ @Result(property = "createTime", column = "create_time") })
	@Select("select id, `name`, description, create_time from major_type where status='active'")
	public List<MajorTypeVO> getMajorTypeList();

	public int createMajorType(MajorTypeVO majorTypeVO);

	public int updateMajorType(MajorTypeVO majorTypeVO);

	public List<MajorTypeVO> getMajorTypeListByBO(MajorTypeBO majorTypeBO);

	public int getMajorTypeCount(MajorTypeBO majorTypeBO);
	
	@Select("select `name`, description from major_type where status='active'")
	public List<MajorTypeApiVO> getMajorTypeListForApi();
	
	@Select("select count(*) from major_type where name=#{name} and status='active'")
	public int getMajorTypeCountByName(@Param("name") String name);
	 
	@Select("select id, `name`, description, create_time from major_type where id=#{majorTypeId} and status='active'")
	public MajorTypeVO getMajorTypeById(@Param("majorTypeId") long majorTypeId);
}
