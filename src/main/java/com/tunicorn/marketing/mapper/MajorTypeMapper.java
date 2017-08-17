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
	@Select("select mt.* from admin_major_type_service_apply_mapping am "
			+ "left join admin_service_apply asa on asa.id=am.service_apply_id"
			+ " left join major_type mt on mt.id=am.major_type_id "
			+ " left join `user` u on u.username=asa.username "
			+ " where asa.username=#{username} and mt.`status`='active'")
	public List<MajorTypeVO> getMajorTypeList(@Param("username") String username);

	@Results({ @Result(property = "createTime", column = "create_time") })
	@Select("select id, `name`, `version`, description, create_time from major_type where status='active'")
	public List<MajorTypeVO> getAllMajorTypeList();
	
	public int createMajorType(MajorTypeVO majorTypeVO);

	public int updateMajorType(MajorTypeVO majorTypeVO);

	public List<MajorTypeVO> getMajorTypeListByBO(MajorTypeBO majorTypeBO);

	public int getMajorTypeCount(MajorTypeBO majorTypeBO);
	
	@Select("select `name`, `version`, description from major_type where status='active'")
	public List<MajorTypeApiVO> getMajorTypeListForApi();
	
	@Select("select count(*) from major_type where name=#{name} and status='active'")
	public int getMajorTypeCountByName(@Param("name") String name);
	 
	@Select("select id, `name`, `version`, description, create_time from major_type where id=#{majorTypeId} and status='active'")
	public MajorTypeVO getMajorTypeById(@Param("majorTypeId") long majorTypeId);
}
