package com.tunicorn.marketing.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tunicorn.common.api.Message;
import com.tunicorn.common.entity.AjaxResponse;
import com.tunicorn.marketing.bo.MajorTypeBO;
import com.tunicorn.marketing.service.MajorTypeService;
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
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		MajorTypeBO majorTypeBO = new MajorTypeBO();

		List<MajorTypeVO> majorTypeVOs = majorTypeService.getMajorTypeListByBO(majorTypeBO);
		int totalCount = majorTypeService.getMajorTypeCount(majorTypeBO);

		model.addAttribute("majorTypes", majorTypeVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", 1);
		return "admin/majortype/major_type";
	}
	
	@RequestMapping(value = "/create", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponse createMajorType(HttpServletRequest request, @RequestBody MajorTypeVO majorType) {
		UserVO user = getCurrentUser(request);
		if (majorTypeService.getMajorTypeByName(majorType.getName()) > 0) {
			Message message = MessageUtils.getInstance().getMessage("dface_area_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		long result = majorTypeService.createMajorType(majorType);
		if (result == 0) {
			Message message = MessageUtils.getInstance().getMessage("dface_area_create_failed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		return AjaxResponse.toSuccess(null);
	}
}
