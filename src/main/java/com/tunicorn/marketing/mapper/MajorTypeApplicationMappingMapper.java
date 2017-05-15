package com.tunicorn.marketing.mapper;

import java.util.List;

import com.tunicorn.marketing.vo.MajorTypeApplicationMappingVO;

public interface MajorTypeApplicationMappingMapper {
	
	public void batchInsertMajorTypeApplicationMapping(List<MajorTypeApplicationMappingVO> applicationMappingVOs);
	
	public void batchDeleteMajorTypeApplicationMapping(List<MajorTypeApplicationMappingVO> applicationMappingVOs);
}
