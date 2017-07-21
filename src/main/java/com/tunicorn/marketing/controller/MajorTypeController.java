package com.tunicorn.marketing.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tunicorn.common.api.Message; 
import com.tunicorn.common.entity.AjaxResponse;
import com.tunicorn.marketing.bo.MajorTypeBO;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.service.MajorTypeService;
import com.tunicorn.marketing.vo.AdminUserVO;
import com.tunicorn.marketing.vo.MajorTypeVO;
import com.tunicorn.marketing.vo.UserVO;
import com.tunicorn.util.MessageUtils;

@Controller
@RequestMapping("/admin/majortype")
@EnableAutoConfiguration
public class MajorTypeController extends BaseController {

	@Autowired
	private MajorTypeService majorTypeService;

	@RequestMapping(value = "", method = RequestMethod.GET)
	public String majorType(HttpServletRequest request, Model model) {
		AdminUserVO user = getCurrentAdminUser(request);
		model.addAttribute("user", user);

		MajorTypeBO majorTypeBO = new MajorTypeBO();
		if (StringUtils.isNotBlank(request.getParameter("pageNum"))) {
			majorTypeBO.setPageNum(Integer.parseInt(request.getParameter("pageNum")));
		}
		List<MajorTypeVO> majorTypeVOs = majorTypeService.getMajorTypeListByBO(majorTypeBO);
		int totalCount = majorTypeService.getMajorTypeCount(majorTypeBO);

		model.addAttribute("majorTypes", majorTypeVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", majorTypeBO.getPageNum() + 1);
		return "admin/majortype/major_type";
	}

	@RequestMapping(value = "/create", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponse createMajorType(HttpServletRequest request, @RequestBody MajorTypeVO majorType) {
		if (majorTypeService.getMajorTypeCountByName(majorType.getName()) > 0) {
			Message message = MessageUtils.getInstance().getMessage("marketing_major_type_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		long result = majorTypeService.createMajorType(majorType);
		if (result == 0) {
			Message message = MessageUtils.getInstance().getMessage("marketing_major_type_create_failed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		return AjaxResponse.toSuccess(null);
	}

	@RequestMapping(value = "/{majorTypeId}/update", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponse updateMajorType(HttpServletRequest request, @PathVariable("majorTypeId") long majorTypeId,
			@RequestBody MajorTypeVO majorType) {
		majorType.setId(majorTypeId);
		MajorTypeVO majorTypeVO = majorTypeService.getMajorTypeById(majorTypeId);
		if (majorTypeVO == null) {
			Message message = MessageUtils.getInstance().getMessage("marketing_major_type_not_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		if (!StringUtils.equals(majorType.getName(), majorTypeVO.getName())
				&& majorTypeService.getMajorTypeCountByName(majorType.getName()) > 0) {
			Message message = MessageUtils.getInstance().getMessage("marketing_major_type_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		majorTypeService.updateMajorType(majorType);
		return AjaxResponse.toSuccess(null);
	}

	@RequestMapping(value = "/{majorTypeId}", method = RequestMethod.DELETE)
	@ResponseBody
	public AjaxResponse deleteMajorType(HttpServletRequest request, @PathVariable("majorTypeId") long majorTypeId) {
		MajorTypeVO majorTypeVO = majorTypeService.getMajorTypeById(majorTypeId);
		if (majorTypeVO == null) {
			Message message = MessageUtils.getInstance().getMessage("marketing_major_type_not_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		majorTypeVO.setStatus(MarketingConstants.STATUS_DELETED);
		majorTypeService.updateMajorType(majorTypeVO);
		return AjaxResponse.toSuccess(null);
	}
}
