package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Update;

import com.tunicorn.marketing.vo.AdminMajorTypeServiceApplyMappingVO;

public interface AdminMajorTypeServiceApplyMappingMapper {

	public void batchInsertMajorTypeApplicationMapping(List<AdminMajorTypeServiceApplyMappingVO> applyMappingVOs);

	public void batchDeleteMajorTypeApplicationMapping(List<AdminMajorTypeServiceApplyMappingVO> applyMappingVOs);
	 
	public void deleteMajorTypeApplicationMappingByApplyId(long applyId);
	
	@Update("Update admin_major_type_service_apply_mapping set status='inactive' where service_apply_id=#{applyId}")
	public void inactiveMajorTypeApplicationMappingByApplyId(long applyId);
}
