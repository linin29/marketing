package com.tunicorn.marketing.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.tunicorn.marketing.bo.ApiCallingSummaryBO;
import com.tunicorn.marketing.service.MajorTypeService;
import com.tunicorn.marketing.service.ProjectService;
import com.tunicorn.marketing.service.TaskService;
import com.tunicorn.marketing.vo.ApiCallingSummaryVO;
import com.tunicorn.marketing.vo.UserVO;

@Controller
@EnableAutoConfiguration
public class CallingController extends BaseController{

	@Autowired
	private TaskService taskService;
	@Autowired
	private MajorTypeService majorTypeService;
	@Autowired
	private ProjectService projectService;
	
	@RequestMapping(value = "/calling", method = RequestMethod.GET)
	public String calling(HttpServletRequest request, ApiCallingSummaryBO apiCallingSummaryBO, Model model) {
		UserVO user = getCurrentUser(request);
		apiCallingSummaryBO.setUserName(user.getUserName());
		
		if(StringUtils.isBlank(apiCallingSummaryBO.getStartDate())){
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			long startDate = new Date().getTime() - 5 * 24 * 60 * 60 * 1000;
			apiCallingSummaryBO.setStartDate(formatter.format(new Date(startDate)));
		}

		List<ApiCallingSummaryVO> apiCallingCounts = taskService.getApiCallingSummaryList(apiCallingSummaryBO);
		int totalCount = taskService.getApiCallingSummary(apiCallingSummaryBO);
		int callingCount = taskService.getApiCallingSum(apiCallingSummaryBO);

		model.addAttribute("callingCount", callingCount);
		model.addAttribute("callings", apiCallingCounts);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("startDate", apiCallingSummaryBO.getStartDate());
		model.addAttribute("endDate", apiCallingSummaryBO.getEndDate());
		model.addAttribute("projectId", apiCallingSummaryBO.getProjectId());
		model.addAttribute("majorType", apiCallingSummaryBO.getMajorType());
		model.addAttribute("currentPage", apiCallingSummaryBO.getPageNum() + 1);
		
		model.addAttribute("majorTypes", taskService.getMajorTypeVOList(user.getUserName()));
		model.addAttribute("projects",  projectService.getProjectsByUserId(user.getId()));
		return "list/count_list";
	}
	
	@RequestMapping(value = "/admin/calling", method = RequestMethod.GET)
	public String adminCalling(HttpServletRequest request, ApiCallingSummaryBO apiCallingSummaryBO, Model model) {
		if(StringUtils.isBlank(apiCallingSummaryBO.getStartDate())){
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			long startDate = new Date().getTime() - 5 * 24 * 60 * 60 * 1000;
			apiCallingSummaryBO.setStartDate(formatter.format(new Date(startDate)));
		}

		List<ApiCallingSummaryVO> apiCallingCounts = taskService.getApiCallingSummaryList(apiCallingSummaryBO);
		int totalCount = taskService.getApiCallingSummary(apiCallingSummaryBO);
		int callingCount = taskService.getApiCallingSum(apiCallingSummaryBO);

		if(StringUtils.isNotBlank(apiCallingSummaryBO.getApiMethod())){
			model.addAttribute("apiMethod", apiCallingSummaryBO.getApiMethod());
		}
		if(StringUtils.isNotBlank(apiCallingSummaryBO.getApiName())){
			model.addAttribute("apiName", apiCallingSummaryBO.getApiName());
		}
		if(StringUtils.isNotBlank(apiCallingSummaryBO.getUserName())){
			model.addAttribute("userName", apiCallingSummaryBO.getUserName());
		}
		if(StringUtils.isNotBlank(apiCallingSummaryBO.getMajorType())){
			model.addAttribute("majorType", apiCallingSummaryBO.getMajorType());
		}
		if(StringUtils.isNotBlank(apiCallingSummaryBO.getProjectId())){
			model.addAttribute("projectId", apiCallingSummaryBO.getProjectId());
		}
		model.addAttribute("majorTypes", majorTypeService.getAllMajorTypeList());
		model.addAttribute("callingCount", callingCount);
		model.addAttribute("callings", apiCallingCounts);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("startDate", apiCallingSummaryBO.getStartDate());
		model.addAttribute("endDate", apiCallingSummaryBO.getEndDate());
		model.addAttribute("currentPage", apiCallingSummaryBO.getPageNum() + 1);
		
		model.addAttribute("majorTypes", majorTypeService.getAllMajorTypeList());
		model.addAttribute("projects",  projectService.getProjects());
		return "admin/list/count_list";
	}
}
