package com.tunicorn.marketing.controller;

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
import com.tunicorn.marketing.service.AdminServiceApplyService;
import com.tunicorn.marketing.service.MajorTypeService;
import com.tunicorn.marketing.vo.AdminServiceApplyAssetVO;
import com.tunicorn.marketing.vo.AdminServiceApplyVO;
import com.tunicorn.marketing.vo.AdminUserVO;
import com.tunicorn.marketing.vo.ApproveEmailVO;
import com.tunicorn.marketing.vo.MajorTypeVO;
import com.tunicorn.util.MessageUtils;

@Controller
@RequestMapping("/admin/service")
@EnableAutoConfiguration
public class AdminServiceController extends BaseController {

	@Autowired
	private AdminServiceApplyService adminServiceApplyService;
	@Autowired
	private MajorTypeService majorTypeService;

	@RequestMapping(value = "/apply", method = RequestMethod.GET)
	public String serviceApply(HttpServletRequest request, HttpServletResponse resp, Model model) {
		AdminServiceApplyBO adminServiceApplyBO = new AdminServiceApplyBO();
		List<AdminServiceApplyVO> adminServiceApplyVOs = adminServiceApplyService
				.getAdminServiceApplyList(adminServiceApplyBO);
		int totalCount = adminServiceApplyService.getAdminServiceApplyCount(adminServiceApplyBO);

		model.addAttribute("majorTypes", majorTypeService.getMajorTypeList());
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

		model.addAttribute("majorTypes", majorTypeService.getMajorTypeList());
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
		if (StringUtils.isNotBlank(request.getParameter("appBusinessName"))) {
			adminServiceApplyVO.setAppBusinessName(request.getParameter("appBusinessName"));
		}
		if (StringUtils.isNotBlank(request.getParameter("appBusinessAddress"))) {
			adminServiceApplyVO.setAppBusinessAddress(request.getParameter("appBusinessAddress"));
		}
		if (StringUtils.isNotBlank(request.getParameter("appBusinessContacts"))) {
			adminServiceApplyVO.setAppBusinessContacts(request.getParameter("appBusinessContacts"));
		}
		if (StringUtils.isNotBlank(request.getParameter("appBusinessMobile"))) {
			adminServiceApplyVO.setAppBusinessMobile(request.getParameter("appBusinessMobile"));
		}
		if (StringUtils.isNotBlank(request.getParameter("maxCallNumber"))) {
			adminServiceApplyVO.setMaxCallNumber(Long.valueOf(request.getParameter("maxCallNumber")));
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
		if (StringUtils.isNotBlank(request.getParameter("username"))) {
			adminServiceApplyVO.setUsername(request.getParameter("username"));
		}
		if (StringUtils.isNotBlank(request.getParameter("email"))) {
			adminServiceApplyVO.setEmail(request.getParameter("email"));
		}
		adminServiceApplyVO.setCreatorId(user.getId());
		int result = adminServiceApplyService.createAdminServiceApply(adminServiceApplyVO, images);
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
		if (StringUtils.isNotBlank(request.getParameter("appBusinessName"))) {
			adminServiceApplyVO.setAppBusinessName(request.getParameter("appBusinessName"));
		}
		if (StringUtils.isNotBlank(request.getParameter("appBusinessAddress"))) {
			adminServiceApplyVO.setAppBusinessAddress(request.getParameter("appBusinessAddress"));
		}
		if (StringUtils.isNotBlank(request.getParameter("appBusinessContacts"))) {
			adminServiceApplyVO.setAppBusinessContacts(request.getParameter("appBusinessContacts"));
		}
		if (StringUtils.isNotBlank(request.getParameter("appBusinessMobile"))) {
			adminServiceApplyVO.setAppBusinessMobile(request.getParameter("appBusinessMobile"));
		}
		if (StringUtils.isNotBlank(request.getParameter("maxCallNumber"))) {
			adminServiceApplyVO.setMaxCallNumber(Long.valueOf(request.getParameter("maxCallNumber")));
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
		if (StringUtils.isNotBlank(request.getParameter("username"))) {
			adminServiceApplyVO.setUsername(request.getParameter("username"));
		}
		if (StringUtils.isNotBlank(request.getParameter("email"))) {
			adminServiceApplyVO.setEmail(request.getParameter("email"));
		}
		adminServiceApplyVO.setId(applyId);
		AdminServiceApplyVO applyVO = adminServiceApplyService.getAdminServiceApplyById(applyId);
		if (applyVO == null) {
			Message message = MessageUtils.getInstance().getMessage("marketing_service_apply_not_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		adminServiceApplyService.updateAdminServiceApply(adminServiceApplyVO);
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
		return AjaxResponse.toSuccess(applyVO);
	}

	@RequestMapping(value = "/{applyId}", method = RequestMethod.DELETE)
	@ResponseBody
	public AjaxResponse deleteService(HttpServletRequest request, @PathVariable("applyId") long applyId) {
		AdminServiceApplyVO adminServiceApplyVO = new AdminServiceApplyVO();
		adminServiceApplyVO.setId(applyId);
		AdminServiceApplyVO applyVO = adminServiceApplyService.getAdminServiceApplyById(applyId);
		if (applyVO == null) {
			Message message = MessageUtils.getInstance().getMessage("marketing_service_apply_not_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		adminServiceApplyService.deleteAdminServiceApply(adminServiceApplyVO);
		return AjaxResponse.toSuccess(null);
	}

	@RequestMapping(value = "/manage", method = RequestMethod.GET)
	public String serviceManage(HttpServletRequest request, HttpServletResponse resp, Model model) {
		AdminServiceApplyBO adminServiceApplyBO = new AdminServiceApplyBO();
		List<AdminServiceApplyVO> adminServiceApplyVOs = adminServiceApplyService
				.getAdminServiceApplyList(adminServiceApplyBO);
		int totalCount = adminServiceApplyService.getAdminServiceApplyCount(adminServiceApplyBO);

		model.addAttribute("majorTypes", majorTypeService.getMajorTypeList());
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
		List<AdminServiceApplyAssetVO> applyAssetVOs = adminServiceApplyService
				.getAdminServiceApplyAssetList(applyAssetVO);
		return CommonAjaxResponse.toSuccess(applyAssetVOs);
	}

	@RequestMapping(value = "/applyAsset/create", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse createApplyAsset(HttpServletRequest request,
			@RequestParam(value = "images", required = false) List<MultipartFile> images) {
		if (StringUtils.isNotBlank(request.getParameter("applyId"))) {
			adminServiceApplyService.addApplyAsset(Long.valueOf(request.getParameter("applyId")), images);
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
		if (StringUtils.isNotBlank(request.getParameter("appBusinessName"))) {
			adminServiceApplyVO.setAppBusinessName(request.getParameter("appBusinessName"));
		}
		if (StringUtils.isNotBlank(request.getParameter("appBusinessAddress"))) {
			adminServiceApplyVO.setAppBusinessAddress(request.getParameter("appBusinessAddress"));
		}
		if (StringUtils.isNotBlank(request.getParameter("appBusinessContacts"))) {
			adminServiceApplyVO.setAppBusinessContacts(request.getParameter("appBusinessContacts"));
		}
		if (StringUtils.isNotBlank(request.getParameter("appBusinessMobile"))) {
			adminServiceApplyVO.setAppBusinessMobile(request.getParameter("appBusinessMobile"));
		}
		if (StringUtils.isNotBlank(request.getParameter("maxCallNumber"))) {
			adminServiceApplyVO.setMaxCallNumber(Long.valueOf(request.getParameter("maxCallNumber")));
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
		adminServiceApplyService.sendApplyEmail(adminServiceApplyVO);
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
		adminServiceApplyService.sendApproveEmail(approveEmailVO);
	}
}
