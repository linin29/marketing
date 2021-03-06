package com.tunicorn.marketing.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
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
import com.tunicorn.marketing.mapper.AdminUserMapper;
import com.tunicorn.marketing.mapper.ApplicationMapper;
import com.tunicorn.marketing.mapper.MajorTypeMapper;
import com.tunicorn.marketing.mapper.ProjectMapper;
import com.tunicorn.marketing.mapper.UserMapper;
import com.tunicorn.marketing.mapper.UserRoleMapper;
import com.tunicorn.marketing.utils.ConfigUtils;
import com.tunicorn.marketing.utils.MarketingStorageUtils;
import com.tunicorn.marketing.vo.AdminMajorTypeServiceApplyMappingVO;
import com.tunicorn.marketing.vo.AdminServiceApplyAssetVO;
import com.tunicorn.marketing.vo.AdminServiceApplyVO;
import com.tunicorn.marketing.vo.AdminUserVO;
import com.tunicorn.marketing.vo.ApplicationVO;
import com.tunicorn.marketing.vo.ApproveEmailVO;
import com.tunicorn.marketing.vo.MajorTypeApplicationMappingVO;
import com.tunicorn.marketing.vo.MajorTypeVO;
import com.tunicorn.marketing.vo.ProjectVO;
import com.tunicorn.marketing.vo.UserRoleVO;
import com.tunicorn.marketing.vo.UserVO;
import com.tunicorn.util.EmailUtils;
import com.tunicorn.util.SecurityUtils;

@Service
public class AdminServiceApplyService {
	private static Logger logger = Logger.getLogger(AdminServiceApplyService.class);
	private static String bcc = ConfigUtils.getInstance().getConfigValue("email.bcc.address");
	@Autowired
	private AdminServiceApplyMapper adminServiceApplyMapper;
	@Autowired
	private AdminServiceApplyAssetMapper adminServiceApplyAssetMapper;
	@Autowired
	private AdminMajorTypeServiceApplyMappingMapper adminMajorTypeServiceApplyMappingMapper;
	@Autowired
	private MajorTypeMapper majorTypeMapper;
	@Autowired
	private ApplicationMapper applicationMapper;
	@Autowired
	private UserMapper userMapper;
	@Autowired
	private AdminUserMapper adminUserMapper;
	@Autowired
	private UserRoleMapper userRoleMapper;
	@Autowired
	private ProjectMapper projectMapper;

	@Transactional
	public int createAdminServiceApply(AdminServiceApplyVO adminServiceApplyVO, ProjectVO projectVO,
			List<MultipartFile> images, int userId) {
		createProject(projectVO);
		adminServiceApplyVO.setProjectId(projectVO.getId());
		int result = adminServiceApplyMapper.createAdminServiceApply(adminServiceApplyVO);
		addApplyAsset(adminServiceApplyVO.getId(), images, userId);
		createAdminMajorTypeServiceApplyMapping(adminServiceApplyVO);
		logger.info("result of createAdminServiceApply method: " + result);
		return result;
	}

	public void sendApplyEmail(AdminServiceApplyVO adminServiceApplyVO, ProjectVO projectVO) {
		StringBuffer text = new StringBuffer();
		text.append("<h3>项目名称：").append(projectVO.getName()).append("</h3>").append("<p>申请服务：");
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
		text.append("</p>").append("<p>调用次数：").append(projectVO.getCallNumber()).append("</p>");
		AdminUserVO adminUserVO = adminUserMapper.getUserByUserName(MarketingConstants.ADMIN_USER_NAME);
		EmailUtils.sendHtmlMail(new String[] { adminUserVO.getEmail(), adminServiceApplyVO.getEmail() }, bcc, "服务申请",
				text.toString());
	}

	public void sendApproveEmail(ApproveEmailVO approveEmailVO) {
		StringBuffer text = new StringBuffer();
		String subject = "";
		if (StringUtils.equals(MarketingConstants.APPLY_OPENED_STATUS, approveEmailVO.getApplyStatus())) {
			subject = "服务已开通";
			text.append("<p>登录地址：").append(ConfigUtils.getInstance().getConfigValue("marketing.login.url"))
					.append("</p>");
			text.append("<p>用户名：").append(approveEmailVO.getUsername()).append("</p>").append("</p>");
			text.append("<p>密码：").append(MarketingConstants.TIANNUO_PASSWORD).append("</p>");
			text.append("<p>appKey：").append(approveEmailVO.getAppKey()).append("</p>");
			text.append("<p>appSecret：").append(approveEmailVO.getAppSecret()).append("</p>");
		} else if (StringUtils.equals(MarketingConstants.APPLY_REJECTED_STATUS, approveEmailVO.getApplyStatus())) {
			subject = "服务已驳回";
			text.append("</p>").append("<p>驳回原因：").append(approveEmailVO.getRejectReason()).append("</p>");
		}
		AdminUserVO adminUserVO = adminUserMapper.getUserByUserName(MarketingConstants.ADMIN_USER_NAME);
		EmailUtils.sendHtmlMail(new String[] { adminUserVO.getEmail(), approveEmailVO.getUserEmail() }, bcc, subject,
				text.toString());
	}

	@Transactional
	public int updateAdminServiceApply(AdminServiceApplyVO adminServiceApplyVO, ProjectVO projectVO) {
		adminServiceApplyVO.setApplyStatus(MarketingConstants.APPLY_CREATED_STATUS);
		int result = adminServiceApplyMapper.updateAdminServiceApply(adminServiceApplyVO);
		adminMajorTypeServiceApplyMappingMapper.deleteMajorTypeApplicationMappingByApplyId(adminServiceApplyVO.getId());
		createAdminMajorTypeServiceApplyMapping(adminServiceApplyVO);
		updateProject(projectVO);
		logger.info("serviceApplyId:" + adminServiceApplyVO.getId() + ", result of updateAdminServiceApply: " + result);
		return result;
	}

	@Transactional
	public int approveAdminServiceApply(AdminServiceApplyVO adminServiceApplyVO) {
		int result = adminServiceApplyMapper.updateAdminServiceApply(adminServiceApplyVO);
		if (StringUtils.equals(MarketingConstants.APPLY_OPENED_STATUS, adminServiceApplyVO.getApplyStatus())) {

			UserVO user = userMapper.getUserByUserName(adminServiceApplyVO.getUsername());
			String userId = null;
			if (user == null) {
				UserVO userVO = new UserVO();
				userVO.setUserName(adminServiceApplyVO.getUsername());
				userVO.setEmail(adminServiceApplyVO.getEmail());
				userVO.setName(adminServiceApplyVO.getUsername());
				userVO.setId((Long.toHexString(new Date().getTime()) + RandomStringUtils.randomAlphanumeric(13))
						.toLowerCase());
				userVO.setPassword(SecurityUtils.generateHashPassword(MarketingConstants.TIANNUO_PASSWORD));
				userMapper.createUser(userVO);

				userId = userVO.getId();
				UserRoleVO userRole = new UserRoleVO();
				userRole.setUserId(userVO.getId());
				userRole.setRoleId(1);
				userRoleMapper.createUserRoleMapping(userRole);
			} else {
				userId = user.getId();
			}

			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
			ApplicationVO applicationVO = new ApplicationVO();
			applicationVO.setUserId(userId);
			applicationVO.setName(userId + "-" + sdf.format(new Date()));
			applicationVO.setDescription(userId + "-" + sdf.format(new Date()));
			UUID uuid = UUID.randomUUID();
			applicationVO.setAppKey(uuid.toString());
			adminServiceApplyVO.setAppKey(uuid.toString());
			uuid = UUID.randomUUID();
			applicationVO.setAppSecret(uuid.toString());
			adminServiceApplyVO.setAppSecret(uuid.toString());
			applicationVO.setPrivacy(MarketingConstants.APPLICATION_PRIVACY_PUBLIC);
			applicationMapper.createApplication(applicationVO);
		}
		logger.info(
				"serviceApplyId:" + adminServiceApplyVO.getId() + ", result of approveAdminServiceApply: " + result);
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
	public int closeAdminServiceApply(AdminServiceApplyVO adminServiceApplyVO) {
		adminServiceApplyVO.setApplyStatus(MarketingConstants.APPLY_CLOSED_STATUS);
		int result = adminServiceApplyMapper.updateAdminServiceApply(adminServiceApplyVO);
		adminMajorTypeServiceApplyMappingMapper
				.inactiveMajorTypeApplicationMappingByApplyId(adminServiceApplyVO.getId());
		adminServiceApplyAssetMapper.inactiveAdminServiceApplyAssetByApplyId(adminServiceApplyVO.getId());

		ProjectVO projectVO = new ProjectVO();
		projectVO.setId(adminServiceApplyVO.getProjectId());
		projectVO.setStatus(MarketingConstants.STATUS_INACTIVE);
		projectMapper.updateProject(projectVO);

		logger.info("serviceApplyId:" + adminServiceApplyVO.getId() + ", result of deleteAdminServiceApply: " + result);
		return result;
	}

	public void deleteAdminServiceApplyAsset(long applyAssetId) {
		adminServiceApplyAssetMapper.deleteAdminServiceApplyAsset(applyAssetId);
	}

	public void addApplyAsset(long applyId, List<MultipartFile> images, int userId) {
		List<AdminServiceApplyAssetVO> assets = new ArrayList<AdminServiceApplyAssetVO>();
		if (images != null && images.size() > 0) {
			for (MultipartFile image : images) {
				AdminServiceApplyAssetVO asset = new AdminServiceApplyAssetVO();
				UploadFile file = MarketingStorageUtils.getUploadFile(image, String.valueOf(userId),
						String.valueOf(applyId), new Date(),
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

	private void createProject(ProjectVO projectVO) {
		projectVO.setId(UUID.randomUUID().toString());
		projectMapper.createProject(projectVO);
	}

	private void updateProject(ProjectVO projectVO) {
		projectMapper.updateProject(projectVO);
	}
}
