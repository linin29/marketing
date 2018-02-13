package com.tunicorn.marketing.controller;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.tunicorn.common.api.Message;
import com.tunicorn.common.entity.AjaxResponse;
import com.tunicorn.marketing.api.CommonAjaxResponse;
import com.tunicorn.marketing.bo.AdminServiceApplyBO;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.mapper.AdminMajorTypeServiceApplyMappingMapper;
import com.tunicorn.marketing.service.AdminServiceApplyService;
import com.tunicorn.marketing.service.MajorTypeService;
import com.tunicorn.marketing.service.ProjectService;
import com.tunicorn.marketing.utils.GetDiffUtils;
import com.tunicorn.marketing.vo.AdminMajorTypeServiceApplyMappingVO;
import com.tunicorn.marketing.vo.AdminServiceApplyAssetVO;
import com.tunicorn.marketing.vo.AdminServiceApplyVO;
import com.tunicorn.marketing.vo.AdminUserVO;
import com.tunicorn.marketing.vo.ApproveEmailVO;
import com.tunicorn.marketing.vo.MajorTypeVO;
import com.tunicorn.marketing.vo.ProjectVO;
import com.tunicorn.util.MessageUtils;

@Controller
@RequestMapping("/admin/service")
@EnableAutoConfiguration
public class AdminServiceController extends BaseController {

	@Autowired
	private AdminServiceApplyService adminServiceApplyService;
	@Autowired
	private MajorTypeService majorTypeService;
	
	@Autowired
	private ProjectService projectService;
	@Autowired
	private AdminMajorTypeServiceApplyMappingMapper adminMajorTypeServiceApplyMappingMapper;

	@RequestMapping(value = "/apply", method = RequestMethod.GET)
	public String serviceApply(HttpServletRequest request, HttpServletResponse resp, Model model) {
		AdminServiceApplyBO adminServiceApplyBO = new AdminServiceApplyBO();
		List<AdminServiceApplyVO> adminServiceApplyVOs = adminServiceApplyService
				.getAdminServiceApplyList(adminServiceApplyBO);
		int totalCount = adminServiceApplyService.getAdminServiceApplyCount(adminServiceApplyBO);

		model.addAttribute("majorTypes", majorTypeService.getAllMajorTypeList());
		model.addAttribute("adminServiceApplys", adminServiceApplyVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", 1);
		return "admin/service/service_apply";
	}

	@RequestMapping(value = "/apply/search", method = RequestMethod.GET)
	public String serviceApplySearch(HttpServletRequest request, HttpServletResponse resp, Model model) {
		AdminServiceApplyBO adminServiceApplyBO = new AdminServiceApplyBO();
		if (StringUtils.isNotBlank(request.getParameter("pageNum"))) {
			adminServiceApplyBO.setPageNum(Integer.parseInt(request.getParameter("pageNum")));
		}
		if (StringUtils.isNotBlank(request.getParameter("projectName"))) {
			adminServiceApplyBO.setName(request.getParameter("projectName"));
			model.addAttribute("projectName", request.getParameter("projectName"));
		}
		if (StringUtils.isNotBlank(request.getParameter("applyStatus"))) {
			adminServiceApplyBO.setApplyStatus(request.getParameter("applyStatus"));
			model.addAttribute("applyStatus", request.getParameter("applyStatus"));
		}
		if (StringUtils.isNotBlank(request.getParameter("projectId"))) {
			adminServiceApplyBO.setProjectId(request.getParameter("projectId"));
			model.addAttribute("projectId", request.getParameter("projectId"));
		}
		if (StringUtils.isNotBlank(request.getParameter("projectType"))) {
			adminServiceApplyBO.setProjectType(request.getParameter("projectType"));
			model.addAttribute("projectType", request.getParameter("projectType"));
		}
		List<AdminServiceApplyVO> adminServiceApplyVOs = adminServiceApplyService
				.getAdminServiceApplyList(adminServiceApplyBO);
		int totalCount = adminServiceApplyService.getAdminServiceApplyCount(adminServiceApplyBO);

		model.addAttribute("majorTypes", majorTypeService.getAllMajorTypeList());
		model.addAttribute("adminServiceApplys", adminServiceApplyVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", adminServiceApplyBO.getPageNum() + 1);
		return "admin/service/service_apply";
	}

	@RequestMapping(value = "/detail/{applyId}", method = RequestMethod.GET)
	@ResponseBody
	public CommonAjaxResponse detail(HttpServletRequest request, @PathVariable("applyId") Long applyId) {
		AdminServiceApplyVO adminServiceApplyVO = adminServiceApplyService.getAdminServiceApplyById(applyId);
		return CommonAjaxResponse.toSuccess(adminServiceApplyVO);
	}

	@RequestMapping(value = "/create", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponse createService(HttpServletRequest request,
			@RequestParam(value = "images", required = false) List<MultipartFile> images) {
		AdminUserVO user = getCurrentAdminUser(request);

		AdminServiceApplyVO adminServiceApplyVO = new AdminServiceApplyVO();
		ProjectVO projectVO = new ProjectVO();
		setServiceApplyAndProjectVO(request, adminServiceApplyVO, projectVO);
		adminServiceApplyVO.setCreatorId(user.getId());

		/*********** 输入验证开始 *************/
		List<String> serviceValidate = validate(adminServiceApplyVO);
		List<String> projectValidate = validate(projectVO);

		Message mess = MessageUtils.getInstance().getMessage("bad_request");
		String errorMessage = mess.getMessage() + ":";
		if (serviceValidate.size() > 0) {
			for (int i = 0; i < serviceValidate.size(); i++) {
				errorMessage += serviceValidate.get(i).toString() + ";";
			}
		}
		if (projectValidate.size() > 0) {
			for (int i = 0; i < projectValidate.size(); i++) {
				errorMessage += projectValidate.get(i).toString() + ";";
			}
		}
		if (serviceValidate.size() > 0 || projectValidate.size() > 0) {
			return AjaxResponse.toFailure(mess.getCode(), errorMessage);
		}
		/*********** 输入验证结束 *************/

		//项目名称不能重复
		ProjectVO po = projectService.getProjectByName(projectVO.getName().trim());
		if (po!=null) {//项目已存在
			Message message = MessageUtils.getInstance().getMessage("marketing_major_type_create_failed");
			return AjaxResponse.toFailure(mess.getCode(), mess.getMessage() + ":项目名称已存在,请更换项目名称");
		}
		int result = adminServiceApplyService.createAdminServiceApply(adminServiceApplyVO, projectVO, images,
				user.getId());
		if (result == 0) {
			Message message = MessageUtils.getInstance().getMessage("marketing_major_type_create_failed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		return AjaxResponse.toSuccess(null);
	}

	@RequestMapping(value = "/{applyId}/update", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponse updateService(HttpServletRequest request, @PathVariable("applyId") long applyId) {
		AdminServiceApplyVO adminServiceApplyVO = new AdminServiceApplyVO();
		ProjectVO projectVO = new ProjectVO();
		setServiceApplyAndProjectVO(request, adminServiceApplyVO, projectVO);
		adminServiceApplyVO.setId(applyId);

		/*********** 输入验证开始 *************/
		List<String> serviceValidate = validate(adminServiceApplyVO);
		List<String> projectValidate = validate(projectVO);

		Message mess = MessageUtils.getInstance().getMessage("bad_request");
		String errorMessage = mess.getMessage() + ":";
		if (serviceValidate.size() > 0) {
			for (int i = 0; i < serviceValidate.size(); i++) {
				errorMessage += serviceValidate.get(i).toString() + ";";
			}
		}
		if (projectValidate.size() > 0) {
			for (int i = 0; i < projectValidate.size(); i++) {
				errorMessage += projectValidate.get(i).toString() + ";";
			}
		}
		if (serviceValidate.size() > 0 || projectValidate.size() > 0) {
			return AjaxResponse.toFailure(mess.getCode(), errorMessage);
		}
		/*********** 输入验证结束 *************/

		AdminServiceApplyVO applyVO = adminServiceApplyService.getAdminServiceApplyById(applyId);
		if (applyVO == null) {
			Message message = MessageUtils.getInstance().getMessage("marketing_service_apply_not_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		projectVO.setId(applyVO.getProjectId());
		adminServiceApplyService.updateAdminServiceApply(adminServiceApplyVO, projectVO);
		return AjaxResponse.toSuccess(null);
	}

	@RequestMapping(value = "/{applyId}/approve", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponse approveService(HttpServletRequest request, @PathVariable("applyId") long applyId,
			@RequestBody AdminServiceApplyVO adminServiceApplyVO) {
		adminServiceApplyVO.setId(applyId);
		AdminServiceApplyVO applyVO = adminServiceApplyService.getAdminServiceApplyById(applyId);
		if (applyVO == null) {
			Message message = MessageUtils.getInstance().getMessage("marketing_service_apply_not_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}

		adminServiceApplyService.approveAdminServiceApply(adminServiceApplyVO);
		/****************weixiaokai添加于2018-02-13*start***************/
		//更新majorTypes字段  
		//待删除
		List<Long> deleteIds = GetDiffUtils.getDiffMajorTypeVO(applyVO.getMajorTypes(), adminServiceApplyVO.getMajorTypes());
		adminMajorTypeServiceApplyMappingMapper.deleteMajorTypeApplicationMappingByApplyIdAndMajorType(applyId, deleteIds);
		//待插入
		List<Long> insertIds = GetDiffUtils.getDiffMajorTypeVO(adminServiceApplyVO.getMajorTypes(), applyVO.getMajorTypes());
		List<AdminMajorTypeServiceApplyMappingVO> applyMappingVOs = new ArrayList<AdminMajorTypeServiceApplyMappingVO>();
		for(Long id:insertIds){
			AdminMajorTypeServiceApplyMappingVO ad = new AdminMajorTypeServiceApplyMappingVO();
			ad.setMajorTypeId(id);
			ad.setServiceApplyId(applyId);
		}
		adminMajorTypeServiceApplyMappingMapper.batchInsertMajorTypeApplicationMapping(applyMappingVOs);
		/****************weixiaokai添加于2018-02-13*end***************/
		applyVO.setAppKey(adminServiceApplyVO.getAppKey());
		applyVO.setAppSecret(adminServiceApplyVO.getAppSecret());
		return AjaxResponse.toSuccess(applyVO);
	}

	@RequestMapping(value = "/{applyId}", method = RequestMethod.DELETE)
	@ResponseBody
	public AjaxResponse closeService(HttpServletRequest request, @PathVariable("applyId") long applyId) {
		AdminServiceApplyVO adminServiceApplyVO = new AdminServiceApplyVO();
		adminServiceApplyVO.setId(applyId);
		AdminServiceApplyVO applyVO = adminServiceApplyService.getAdminServiceApplyById(applyId);
		if (applyVO == null) {
			Message message = MessageUtils.getInstance().getMessage("marketing_service_apply_not_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		adminServiceApplyVO.setProjectId(applyVO.getProjectId());
		adminServiceApplyService.closeAdminServiceApply(adminServiceApplyVO);
		return AjaxResponse.toSuccess(null);
	}

	@RequestMapping(value = "/manage", method = RequestMethod.GET)
	public String serviceManage(HttpServletRequest request, HttpServletResponse resp, Model model) {
		AdminServiceApplyBO adminServiceApplyBO = new AdminServiceApplyBO();
		List<AdminServiceApplyVO> adminServiceApplyVOs = adminServiceApplyService
				.getAdminServiceApplyList(adminServiceApplyBO);
		int totalCount = adminServiceApplyService.getAdminServiceApplyCount(adminServiceApplyBO);

		model.addAttribute("majorTypes", majorTypeService.getAllMajorTypeList());
		model.addAttribute("adminServiceApplys", adminServiceApplyVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", 1);
		return "admin/service/service_management";
	}

	@RequestMapping(value = "/manage/search", method = RequestMethod.GET)
	public String serviceManageSearch(HttpServletRequest request, HttpServletResponse resp, Model model) {
		AdminServiceApplyBO adminServiceApplyBO = new AdminServiceApplyBO();
		if (StringUtils.isNotBlank(request.getParameter("pageNum"))) {
			adminServiceApplyBO.setPageNum(Integer.parseInt(request.getParameter("pageNum")));
		}
		if (StringUtils.isNotBlank(request.getParameter("projectName"))) {
			adminServiceApplyBO.setName(request.getParameter("projectName"));
			model.addAttribute("projectName", request.getParameter("projectName"));
		}
		if (StringUtils.isNotBlank(request.getParameter("applyStatus"))) {
			adminServiceApplyBO.setApplyStatus(request.getParameter("applyStatus"));
			model.addAttribute("applyStatus", request.getParameter("applyStatus"));
		}
		if (StringUtils.isNotBlank(request.getParameter("projectId"))) {
			adminServiceApplyBO.setProjectId(request.getParameter("projectId"));
			model.addAttribute("projectId", request.getParameter("projectId"));
		}
		if (StringUtils.isNotBlank(request.getParameter("projectType"))) {
			adminServiceApplyBO.setProjectType(request.getParameter("projectType"));
			model.addAttribute("projectType", request.getParameter("projectType"));
		}
		List<AdminServiceApplyVO> adminServiceApplyVOs = adminServiceApplyService
				.getAdminServiceApplyList(adminServiceApplyBO);
		int totalCount = adminServiceApplyService.getAdminServiceApplyCount(adminServiceApplyBO);

		model.addAttribute("majorTypes", majorTypeService.getAllMajorTypeList());
		model.addAttribute("adminServiceApplys", adminServiceApplyVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", adminServiceApplyBO.getPageNum() + 1);
		return "admin/service/service_management";
	}

	@RequestMapping(value = "/applyAsset", method = RequestMethod.GET)
	@ResponseBody
	public CommonAjaxResponse applyAsset(HttpServletRequest request, HttpServletResponse resp, Model model) {
		AdminServiceApplyAssetVO applyAssetVO = new AdminServiceApplyAssetVO();
		if (StringUtils.isNotBlank(request.getParameter("applyId"))) {
			applyAssetVO.setServiceApplyId(Long.valueOf(request.getParameter("applyId")));
		}
		List<AdminServiceApplyAssetVO> applyAssetVOs = adminServiceApplyService
				.getAdminServiceApplyAssetList(applyAssetVO);
		return CommonAjaxResponse.toSuccess(applyAssetVOs);
	}

	@RequestMapping(value = "/applyAsset/create", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse createApplyAsset(HttpServletRequest request,
			@RequestParam(value = "images", required = false) List<MultipartFile> images) {
		AdminUserVO user = getCurrentAdminUser(request);
		if (StringUtils.isNotBlank(request.getParameter("applyId"))) {
			adminServiceApplyService.addApplyAsset(Long.valueOf(request.getParameter("applyId")), images, user.getId());
		}
		return CommonAjaxResponse.toSuccess(null);
	}

	@RequestMapping(value = "/applyAsset/{assetId}", method = RequestMethod.PUT)
	@ResponseBody
	public CommonAjaxResponse deleteApplyAsset(HttpServletRequest request, @PathVariable("assetId") long assetId) {
		adminServiceApplyService.deleteAdminServiceApplyAsset(assetId);
		return CommonAjaxResponse.toSuccess(null);
	}

	@RequestMapping(value = "/sendEmail", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse sendEmail(HttpServletRequest request) {
		if (StringUtils.equals(MarketingConstants.APPLY_CREATED_STATUS, request.getParameter("applyStatus"))) {
			sendApplyEmail(request);
		} else {
			sendApproveEmail(request);
		}
		return CommonAjaxResponse.toSuccess(null);
	}

	private void sendApplyEmail(HttpServletRequest request) {
		AdminServiceApplyVO adminServiceApplyVO = new AdminServiceApplyVO();
		ProjectVO projectVO = new ProjectVO();
		setServiceApplyAndProjectVO(request, adminServiceApplyVO, projectVO);
		adminServiceApplyService.sendApplyEmail(adminServiceApplyVO, projectVO);
	}

	private void sendApproveEmail(HttpServletRequest request) {
		ApproveEmailVO approveEmailVO = new ApproveEmailVO();
		if (StringUtils.isNotBlank(request.getParameter("applyStatus"))) {
			approveEmailVO.setApplyStatus(request.getParameter("applyStatus"));
		}
		if (StringUtils.isNotBlank(request.getParameter("username"))) {
			approveEmailVO.setUsername(request.getParameter("username"));
		}
		if (StringUtils.isNotBlank(request.getParameter("rejectReason"))) {
			approveEmailVO.setRejectReason(request.getParameter("rejectReason"));
		}
		if (StringUtils.isNotBlank(request.getParameter("appKey"))) {
			approveEmailVO.setAppKey(request.getParameter("appKey"));
		}
		if (StringUtils.isNotBlank(request.getParameter("appSecret"))) {
			approveEmailVO.setAppSecret(request.getParameter("appSecret"));
		}
		if (StringUtils.isNotBlank(request.getParameter("email"))) {
			approveEmailVO.setUserEmail(request.getParameter("email"));
		}
		adminServiceApplyService.sendApproveEmail(approveEmailVO);
	}

	private void setServiceApplyAndProjectVO(HttpServletRequest request, AdminServiceApplyVO adminServiceApplyVO,
			ProjectVO projectVO) {
		if (StringUtils.isNotBlank(request.getParameter("name"))) {
			projectVO.setName(request.getParameter("name"));
		}
		if (StringUtils.isNotBlank(request.getParameter("address"))) {
			projectVO.setAddress(request.getParameter("address"));
		}
		if (StringUtils.isNotBlank(request.getParameter("contacts"))) {
			projectVO.setContacts(request.getParameter("contacts"));
		}
		if (StringUtils.isNotBlank(request.getParameter("mobile"))) {
			projectVO.setMobile(request.getParameter("mobile"));
		}
		if (StringUtils.isNotBlank(request.getParameter("maxCallNumber"))) {
			projectVO.setCallNumber(Integer.valueOf(request.getParameter("maxCallNumber")));
		}
		if (StringUtils.isNotBlank(request.getParameter("storeNumber"))) {
			projectVO.setStoreNumber(Integer.valueOf(request.getParameter("storeNumber")));
		}
		if (StringUtils.isNotBlank(request.getParameter("imageNumber"))) {
			projectVO.setImageNumber(Integer.valueOf(request.getParameter("imageNumber")));
		}
		if (StringUtils.isNotBlank(request.getParameter("projectType"))) {
			projectVO.setType(request.getParameter("projectType"));
		}
		if (StringUtils.isNotBlank(request.getParameter("threshhold"))) {
			projectVO.setThreshhold(Float.valueOf(request.getParameter("threshhold")));
		}
		if (StringUtils.isNotBlank(request.getParameter("majorTypes"))) {
			List<MajorTypeVO> majorTypes = new ArrayList<MajorTypeVO>();
			String[] majortypeArray = request.getParameter("majorTypes").split(",");
			for (String majorTypeId : majortypeArray) {
				MajorTypeVO majorTypeVO = new MajorTypeVO();
				majorTypeVO.setId(Long.valueOf(majorTypeId));
				majorTypes.add(majorTypeVO);
			}
			adminServiceApplyVO.setMajorTypes(majorTypes);
		}
		if (StringUtils.isNotBlank(request.getParameter("startTime"))) {
			adminServiceApplyVO.setStartTime(Timestamp.valueOf(request.getParameter("startTime")));
		}
		if (StringUtils.isNotBlank(request.getParameter("endTime"))) {
			adminServiceApplyVO.setEndTime(Timestamp.valueOf(request.getParameter("endTime")));
		}
		if (StringUtils.isNotBlank(request.getParameter("contractedValue"))) {
			adminServiceApplyVO.setContractedValue(Float.valueOf(request.getParameter("contractedValue")));
		}
		if (StringUtils.isNotBlank(request.getParameter("contractedNo"))) {
			adminServiceApplyVO.setContractedNo(request.getParameter("contractedNo"));
		}
		if (StringUtils.isNotBlank(request.getParameter("username"))) {
			adminServiceApplyVO.setUsername(request.getParameter("username"));
		}
		if (StringUtils.isNotBlank(request.getParameter("username"))) {
			adminServiceApplyVO.setUsername(request.getParameter("username"));
		}
		if (StringUtils.isNotBlank(request.getParameter("email"))) {
			adminServiceApplyVO.setEmail(request.getParameter("email"));
		}
	}
}
