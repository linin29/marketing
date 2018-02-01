package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.bo.AdminServiceApplyBO;
import com.tunicorn.marketing.vo.AdminServiceApplyVO;
import com.tunicorn.marketing.vo.MajorTypeApplicationMappingVO;

public interface AdminServiceApplyMapper {

	public int createAdminServiceApply(AdminServiceApplyVO adminServiceApplyVO);

	public int updateAdminServiceApply(AdminServiceApplyVO adminServiceApplyVO);

	public List<AdminServiceApplyVO> getAdminServiceApplyList(AdminServiceApplyBO adminServiceApplyBO);

	public int getAdminServiceApplyCount(AdminServiceApplyBO adminServiceApplyBO);

	public int updateMajorTypeApplicationMapping(MajorTypeApplicationMappingVO applicationMappingVO);
 
	public AdminServiceApplyVO getAdminServiceApplyById(@Param("id") long id);
	
	@Select("select email,username from admin_service_apply where project_id=#{projectId}")
	public AdminServiceApplyVO getServiceByProjectId(String projectId);
}
