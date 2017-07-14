package com.tunicorn.marketing.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.tunicorn.marketing.bo.AdminServiceApplyBO;
import com.tunicorn.marketing.service.AdminServiceApplyService;
import com.tunicorn.marketing.vo.AdminServiceApplyVO;
import com.tunicorn.marketing.vo.UserVO;

@Controller
@RequestMapping("/admin/service")
@EnableAutoConfiguration
public class AdminServiceController extends BaseController{

	@Autowired
	private AdminServiceApplyService adminServiceApplyService;
	
	@RequestMapping(value = "/apply", method = RequestMethod.GET)
	public String serviceApply(HttpServletRequest request, HttpServletResponse resp, Model model) {
		
		AdminServiceApplyBO adminServiceApplyBO = new AdminServiceApplyBO();
		List<AdminServiceApplyVO>  adminServiceApplyVOs = adminServiceApplyService.getAdminServiceApplyList(adminServiceApplyBO);
		int totalCount = adminServiceApplyService.getAdminServiceApplyCount(adminServiceApplyBO);

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
		}
		if (StringUtils.isNotBlank(request.getParameter("applyStatus"))) {
			adminServiceApplyBO.setApplyStatus(request.getParameter("applyStatus"));
		}
		List<AdminServiceApplyVO>  adminServiceApplyVOs = adminServiceApplyService.getAdminServiceApplyList(adminServiceApplyBO);
		int totalCount = adminServiceApplyService.getAdminServiceApplyCount(adminServiceApplyBO);

		model.addAttribute("adminServiceApplys", adminServiceApplyVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", adminServiceApplyBO.getPageNum() + 1);
		return "admin/service/service_apply";
	}
	
	@RequestMapping(value = "/manage", method = RequestMethod.GET)
	public String serviceManage(HttpServletRequest request, HttpServletResponse resp, Model model) {
		UserVO user = getCurrentUser(request);
		return "admin/service/service_management";
	}
}
