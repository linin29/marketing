package com.tunicorn.marketing.controller;

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
		return "admin/service/service_management";
	}

	@RequestMapping(value = "/manage/search", method = RequestMethod.GET)
	public String serviceManageSearch(HttpServletRequest request, HttpServletResponse resp, Model model) {
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
