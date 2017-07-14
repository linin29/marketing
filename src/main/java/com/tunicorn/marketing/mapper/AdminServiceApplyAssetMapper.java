package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

import com.tunicorn.marketing.vo.AdminServiceApplyAssetVO;

public interface AdminServiceApplyAssetMapper {
	
	public void batchInsertServiceApplyAsset(List<AdminServiceApplyAssetVO> adminServiceApplyAssetVOs);
	
	@Update("Update admin_service_apply_asset set status='deleted' where id=#{applyAssetId}")
	public void deleteAdminServiceApplyAsset(@Param("applyAssetId") long applyAssetId);

	public List<AdminServiceApplyAssetVO> getAdminServiceApplyAssetList(
			AdminServiceApplyAssetVO adminServiceApplyAssetVO);
	
	public void deleteAdminServiceApplyAssetByApplyId(@Param("applyId") long applyId);
}
