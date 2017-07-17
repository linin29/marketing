package com.tunicorn.marketing.mapper;

import java.util.List;

import com.tunicorn.marketing.vo.AdminMajorTypeServiceApplyMappingVO;

public interface AdminMajorTypeServiceApplyMappingMapper {

	public void batchInsertMajorTypeApplicationMapping(List<AdminMajorTypeServiceApplyMappingVO> applyMappingVOs);

	public void batchDeleteMajorTypeApplicationMapping(List<AdminMajorTypeServiceApplyMappingVO> applyMappingVOs);
	
	public void deleteMajorTypeApplicationMappingByApplyId(long applyId);
}
