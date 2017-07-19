package com.tunicorn.marketing.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.tunicorn.common.entity.UploadFile;
import com.tunicorn.marketing.bo.AdminServiceApplyBO;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.mapper.AdminMajorTypeServiceApplyMappingMapper;
import com.tunicorn.marketing.mapper.AdminServiceApplyAssetMapper;
import com.tunicorn.marketing.mapper.AdminServiceApplyMapper;
import com.tunicorn.marketing.mapper.MajorTypeMapper;
import com.tunicorn.marketing.utils.ConfigUtils;
import com.tunicorn.marketing.utils.MarketingStorageUtils;
import com.tunicorn.marketing.utils.SendMailUtils;
import com.tunicorn.marketing.vo.AdminMajorTypeServiceApplyMappingVO;
import com.tunicorn.marketing.vo.AdminServiceApplyAssetVO;
import com.tunicorn.marketing.vo.AdminServiceApplyVO;
import com.tunicorn.marketing.vo.MajorTypeApplicationMappingVO;
import com.tunicorn.marketing.vo.MajorTypeVO;

@Service
public class AdminServiceApplyService {

	@Autowired
	private AdminServiceApplyMapper adminServiceApplyMapper;

	@Autowired
	private AdminServiceApplyAssetMapper adminServiceApplyAssetMapper;

	@Autowired
	private AdminMajorTypeServiceApplyMappingMapper adminMajorTypeServiceApplyMappingMapper;

	@Autowired
	MajorTypeMapper majorTypeMapper;

	@Transactional
	public int createAdminServiceApply(AdminServiceApplyVO adminServiceApplyVO, List<MultipartFile> images) {
		int result = adminServiceApplyMapper.createAdminServiceApply(adminServiceApplyVO);
		addApplyAsset(adminServiceApplyVO.getId(), images);
		this.createAdminMajorTypeServiceApplyMapping(adminServiceApplyVO);
		StringBuffer text = new StringBuffer();
		text.append("<h3>应用商：").append(adminServiceApplyVO.getAppBusinessName()).append("</h3>").append("<p>申请服务：");
		List<MajorTypeVO> majorTypeVOs = adminServiceApplyVO.getMajorTypes();
		if (majorTypeVOs != null && majorTypeVOs.size() > 0) {
			for (MajorTypeVO majorTypeVO : majorTypeVOs) {
				MajorTypeVO tempMajorTypeVO = majorTypeMapper.getMajorTypeById(majorTypeVO.getId());
				if (tempMajorTypeVO != null) {
					text.append(tempMajorTypeVO.getName()).append(",");
				}
			}
			text.deleteCharAt(text.length() - 1);
		}
		text.append("</p>").append("<p>调用次数：").append(adminServiceApplyVO.getMaxCallNumber()).append("</p>");
		SendMailUtils.sendTextWithHtml("服务申请", text.toString());
		return result;
	}

	@Transactional
	public int updateAdminServiceApply(AdminServiceApplyVO adminServiceApplyVO) {
		int result = adminServiceApplyMapper.updateAdminServiceApply(adminServiceApplyVO);
		adminMajorTypeServiceApplyMappingMapper.deleteMajorTypeApplicationMappingByApplyId(adminServiceApplyVO.getId());
		this.createAdminMajorTypeServiceApplyMapping(adminServiceApplyVO);
		return result;
	}

	@Transactional
	public int approveAdminServiceApply(AdminServiceApplyVO adminServiceApplyVO) {
		int result = adminServiceApplyMapper.updateAdminServiceApply(adminServiceApplyVO);
		return result;
	}

	public List<AdminServiceApplyVO> getAdminServiceApplyList(AdminServiceApplyBO adminServiceApplyBO) {
		return adminServiceApplyMapper.getAdminServiceApplyList(adminServiceApplyBO);
	}

	public int getAdminServiceApplyCount(AdminServiceApplyBO adminServiceApplyBO) {
		return adminServiceApplyMapper.getAdminServiceApplyCount(adminServiceApplyBO);
	}

	public int updateMajorTypeApplicationMapping(MajorTypeApplicationMappingVO applicationMappingVO) {
		return adminServiceApplyMapper.updateMajorTypeApplicationMapping(applicationMappingVO);
	}

	public AdminServiceApplyVO getAdminServiceApplyById(long id) {
		return adminServiceApplyMapper.getAdminServiceApplyById(id);
	}

	public List<AdminServiceApplyAssetVO> getAdminServiceApplyAssetList(
			AdminServiceApplyAssetVO adminServiceApplyAssetVO) {
		return adminServiceApplyAssetMapper.getAdminServiceApplyAssetList(adminServiceApplyAssetVO);
	}

	@Transactional
	public int deleteAdminServiceApply(AdminServiceApplyVO adminServiceApplyVO) {
		adminServiceApplyVO.setStatus(MarketingConstants.STATUS_DELETED);
		int result = adminServiceApplyMapper.updateAdminServiceApply(adminServiceApplyVO);
		adminMajorTypeServiceApplyMappingMapper.deleteMajorTypeApplicationMappingByApplyId(adminServiceApplyVO.getId());
		adminServiceApplyAssetMapper.deleteAdminServiceApplyAssetByApplyId(adminServiceApplyVO.getId());
		return result;
	}

	public void deleteAdminServiceApplyAsset(long applyAssetId) {
		adminServiceApplyAssetMapper.deleteAdminServiceApplyAsset(applyAssetId);
	}

	public void addApplyAsset(long applyId, List<MultipartFile> images) {
		List<AdminServiceApplyAssetVO> assets = new ArrayList<AdminServiceApplyAssetVO>();
		if (images != null && images.size() > 0) {
			for (MultipartFile image : images) {
				AdminServiceApplyAssetVO asset = new AdminServiceApplyAssetVO();
				UploadFile file = MarketingStorageUtils.getUploadFile(image, String.valueOf(applyId),
						ConfigUtils.getInstance().getConfigValue("marketing.image.sub.dir"), false);
				asset.setServiceApplyId(applyId);
				asset.setFilePath(file.getPath());
				asset.setFileExt(file.getExtension());
				asset.setDisplayName(file.getName());
				asset.setFileSize(file.getSize());
				assets.add(asset);
			}
			adminServiceApplyAssetMapper.batchInsertServiceApplyAsset(assets);
		}
	}

	private void createAdminMajorTypeServiceApplyMapping(AdminServiceApplyVO adminServiceApplyVO) {
		List<AdminMajorTypeServiceApplyMappingVO> applyMappings = new ArrayList<AdminMajorTypeServiceApplyMappingVO>();
		long serviceApplyId = adminServiceApplyVO.getId();
		List<MajorTypeVO> majorTypeVOs = adminServiceApplyVO.getMajorTypes();
		if (majorTypeVOs != null && majorTypeVOs.size() > 0) {
			for (MajorTypeVO majorTypeVO : majorTypeVOs) {
				AdminMajorTypeServiceApplyMappingVO applyMappingVO = new AdminMajorTypeServiceApplyMappingVO();
				applyMappingVO.setServiceApplyId(serviceApplyId);
				applyMappingVO.setMajorTypeId(majorTypeVO.getId());
				applyMappings.add(applyMappingVO);
			}
		}
		adminMajorTypeServiceApplyMappingMapper.batchInsertMajorTypeApplicationMapping(applyMappings);
	}
}
