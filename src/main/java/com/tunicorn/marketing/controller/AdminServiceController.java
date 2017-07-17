package com.tunicorn.marketing.controller;

import java.util.ArrayList;
import java.util.Arrays;
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
import com.tunicorn.marketing.service.AdminServiceApplyService;
import com.tunicorn.marketing.service.AdminUserService;
import com.tunicorn.marketing.service.MajorTypeService;
import com.tunicorn.marketing.vo.AdminServiceApplyAssetVO;
import com.tunicorn.marketing.vo.AdminServiceApplyVO;
import com.tunicorn.marketing.vo.MajorTypeVO;
import com.tunicorn.marketing.vo.UserVO;
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
	private AdminUserService adminUserService;

	@RequestMapping(value = "/apply", method = RequestMethod.GET)
	public String serviceApply(HttpServletRequest request, HttpServletResponse resp, Model model) {
		UserVO user = getCurrentUser(request);

		AdminServiceApplyBO adminServiceApplyBO = new AdminServiceApplyBO();
		adminServiceApplyBO.setCreatorId(Integer.valueOf(user.getId()));
		List<AdminServiceApplyVO> adminServiceApplyVOs = adminServiceApplyService
				.getAdminServiceApplyList(adminServiceApplyBO);
		int totalCount = adminServiceApplyService.getAdminServiceApplyCount(adminServiceApplyBO);
		
		model.addAttribute("majorTypes", majorTypeService.getMajorTypeList());
		model.addAttribute("adminUsers", adminUserService.getAdminUserList());
		model.addAttribute("adminServiceApplys", adminServiceApplyVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", 1);
		return "admin/service/service_apply";
	}
	
	@RequestMapping(value = "/detail/{applyId}", method = RequestMethod.GET)
	@ResponseBody
	public CommonAjaxResponse detail(HttpServletRequest request, @PathVariable("applyId") Long applyId) {
		AdminServiceApplyVO adminServiceApplyVO = adminServiceApplyService.getAdminServiceApplyById(applyId);
		return CommonAjaxResponse.toSuccess(adminServiceApplyVO);
	}


	@RequestMapping(value = "/apply/search", method = RequestMethod.GET)
	public String serviceApplySearch(HttpServletRequest request, HttpServletResponse resp, Model model) {
		UserVO user = getCurrentUser(request);

		AdminServiceApplyBO adminServiceApplyBO = new AdminServiceApplyBO();
		adminServiceApplyBO.setCreatorId(Integer.valueOf(user.getId()));
		if (StringUtils.isNotBlank(request.getParameter("pageNum"))) {
			adminServiceApplyBO.setPageNum(Integer.parseInt(request.getParameter("pageNum")));
		}
		if (StringUtils.isNotBlank(request.getParameter("appBusinessName"))) {
			adminServiceApplyBO.setAppBusinessName(request.getParameter("appBusinessName"));
			model.addAttribute("appBusinessName", request.getParameter("appBusinessName"));
		}
		if (StringUtils.isNotBlank(request.getParameter("applyStatus"))) {
			adminServiceApplyBO.setApplyStatus(request.getParameter("applyStatus"));
			model.addAttribute("applyStatus", request.getParameter("applyStatus"));
		}
		List<AdminServiceApplyVO> adminServiceApplyVOs = adminServiceApplyService
				.getAdminServiceApplyList(adminServiceApplyBO);
		int totalCount = adminServiceApplyService.getAdminServiceApplyCount(adminServiceApplyBO);
		
		model.addAttribute("adminUsers", adminUserService.getAdminUserList());
		model.addAttribute("majorTypes", majorTypeService.getMajorTypeList());
		model.addAttribute("adminServiceApplys", adminServiceApplyVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", adminServiceApplyBO.getPageNum() + 1);
		return "admin/service/service_apply";
	}
	
	@RequestMapping(value = "/create", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponse createService(HttpServletRequest request,
			@RequestParam(value = "images", required = false) List<MultipartFile> images) {
		UserVO user = getCurrentUser(request);
		
		AdminServiceApplyVO adminServiceApplyVO = new AdminServiceApplyVO();
		if(StringUtils.isNotBlank(request.getParameter("appBusinessName"))){
			adminServiceApplyVO.setAppBusinessName(request.getParameter("appBusinessName"));
		}
		if(StringUtils.isNotBlank(request.getParameter("appBusinessAddress"))){
			adminServiceApplyVO.setAppBusinessAddress(request.getParameter("appBusinessAddress"));
		}
		if(StringUtils.isNotBlank(request.getParameter("appBusinessContacts"))){
			adminServiceApplyVO.setAppBusinessContacts(request.getParameter("appBusinessContacts"));
		}
		if(StringUtils.isNotBlank(request.getParameter("appBusinessMobile"))){
			adminServiceApplyVO.setAppBusinessMobile(request.getParameter("appBusinessMobile"));
		}
		if(StringUtils.isNotBlank(request.getParameter("maxCallNumber"))){
			adminServiceApplyVO.setMaxCallNumber(Long.valueOf(request.getParameter("maxCallNumber")));
		}
		if(StringUtils.isNotBlank(request.getParameter("majorTypes"))){
			List<MajorTypeVO> majorTypes = new ArrayList<MajorTypeVO>();
			String[] majortypeArray = request.getParameter("majorTypes").split(",");
			for (String majorTypeId : majortypeArray) {
				MajorTypeVO majorTypeVO = new MajorTypeVO();
				majorTypeVO.setId(Long.valueOf(majorTypeId));
				majorTypes.add(majorTypeVO);
			}
			adminServiceApplyVO.setMajorTypes(majorTypes);
		}
		if(StringUtils.isNotBlank(request.getParameter("username"))){
			adminServiceApplyVO.setUsername(request.getParameter("username"));
		}
		if(StringUtils.isNotBlank(request.getParameter("email"))){
			adminServiceApplyVO.setEmail(request.getParameter("email"));
		}
		adminServiceApplyVO.setCreatorId(Integer.valueOf(user.getId()));
		int result = adminServiceApplyService.createAdminServiceApply(adminServiceApplyVO, images);
		if (result == 0) {
			Message message = MessageUtils.getInstance().getMessage("marketing_major_type_create_failed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		return AjaxResponse.toSuccess(null);
	}
	
	@RequestMapping(value = "/{applyId}/update", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponse updateService(HttpServletRequest request, @PathVariable("applyId") long applyId,
			@RequestBody AdminServiceApplyVO adminServiceApplyVO,
			@RequestParam(value = "images", required = false) List<MultipartFile> images) {
		adminServiceApplyVO.setId(applyId);
		AdminServiceApplyVO applyVO = adminServiceApplyService.getAdminServiceApplyById(applyId);
		if (applyVO == null) {
			Message message = MessageUtils.getInstance().getMessage("marketing_service_apply_not_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		adminServiceApplyService.updateAdminServiceApply(adminServiceApplyVO, images);
		return AjaxResponse.toSuccess(null);
	}

	@RequestMapping(value = "/manage", method = RequestMethod.GET)
	public String serviceManage(HttpServletRequest request, HttpServletResponse resp, Model model) {
		UserVO user = getCurrentUser(request);

		AdminServiceApplyBO adminServiceApplyBO = new AdminServiceApplyBO();
		adminServiceApplyBO.setCreatorId(Integer.valueOf(user.getId()));
		List<AdminServiceApplyVO> adminServiceApplyVOs = adminServiceApplyService
				.getAdminServiceApplyList(adminServiceApplyBO);
		int totalCount = adminServiceApplyService.getAdminServiceApplyCount(adminServiceApplyBO);
		
		model.addAttribute("majorTypes", majorTypeService.getMajorTypeList());
		model.addAttribute("adminUsers", adminUserService.getAdminUserList());
		model.addAttribute("adminServiceApplys", adminServiceApplyVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", 1);
		return "admin/service/service_management";
	}

	@RequestMapping(value = "/manage/search", method = RequestMethod.GET)
	public String serviceManageSearch(HttpServletRequest request, HttpServletResponse resp, Model model) {
		UserVO user = getCurrentUser(request);

		AdminServiceApplyBO adminServiceApplyBO = new AdminServiceApplyBO();
		adminServiceApplyBO.setCreatorId(Integer.valueOf(user.getId()));
		if (StringUtils.isNotBlank(request.getParameter("pageNum"))) {
			adminServiceApplyBO.setPageNum(Integer.parseInt(request.getParameter("pageNum")));
		}
		if (StringUtils.isNotBlank(request.getParameter("appBusinessName"))) {
			adminServiceApplyBO.setAppBusinessName(request.getParameter("appBusinessName"));
			model.addAttribute("appBusinessName", request.getParameter("appBusinessName"));
		}
		if (StringUtils.isNotBlank(request.getParameter("applyStatus"))) {
			adminServiceApplyBO.setApplyStatus(request.getParameter("applyStatus"));
			model.addAttribute("applyStatus", request.getParameter("applyStatus"));
		}
		List<AdminServiceApplyVO> adminServiceApplyVOs = adminServiceApplyService
				.getAdminServiceApplyList(adminServiceApplyBO);
		int totalCount = adminServiceApplyService.getAdminServiceApplyCount(adminServiceApplyBO);
		
		model.addAttribute("adminUsers", adminUserService.getAdminUserList());
		model.addAttribute("majorTypes", majorTypeService.getMajorTypeList());
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
		List<AdminServiceApplyAssetVO> applyAssetVOs = adminServiceApplyService.getAdminServiceApplyAssetList(applyAssetVO);
		return CommonAjaxResponse.toSuccess(applyAssetVOs);
	}
}
