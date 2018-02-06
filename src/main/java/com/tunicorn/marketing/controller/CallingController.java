package com.tunicorn.marketing.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.output.FileWriterWithEncoding;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tunicorn.marketing.api.CommonAjaxResponse;
import com.tunicorn.marketing.bo.ApiCallingSummaryBO;
import com.tunicorn.marketing.service.CallingService;
import com.tunicorn.marketing.service.MajorTypeService;
import com.tunicorn.marketing.service.ProjectService;
import com.tunicorn.marketing.service.TaskService;
import com.tunicorn.marketing.vo.ApiCallingSummaryVO;
import com.tunicorn.marketing.vo.UserVO;

@Controller
@EnableAutoConfiguration
public class CallingController extends BaseController {
	private static Logger logger = Logger.getLogger(CallingController.class);
	@Autowired
	private TaskService taskService;
	@Autowired
	private MajorTypeService majorTypeService;
	@Autowired
	private ProjectService projectService;
	@Autowired
	private CallingService callingService;

	@RequestMapping(value = "/calling", method = RequestMethod.GET)
	public String calling(HttpServletRequest request, ApiCallingSummaryBO apiCallingSummaryBO, Model model) {
		UserVO user = getCurrentUser(request);
		apiCallingSummaryBO.setUserName(user.getUserName());

		if (StringUtils.isBlank(apiCallingSummaryBO.getStartDate())) {
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
		model.addAttribute("projects", projectService.getProjectsByUserId(user.getId()));
		return "list/count_list";
	}

	@RequestMapping(value = "/admin/calling", method = RequestMethod.GET)
	public String adminCalling(HttpServletRequest request, ApiCallingSummaryBO apiCallingSummaryBO, Model model) {
		if (StringUtils.isBlank(apiCallingSummaryBO.getStartDate())) {
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			long startDate = new Date().getTime() - 5 * 24 * 60 * 60 * 1000;
			apiCallingSummaryBO.setStartDate(formatter.format(new Date(startDate)));
		}

		List<ApiCallingSummaryVO> apiCallingCounts = taskService.getApiCallingSummaryList(apiCallingSummaryBO);
		int totalCount = taskService.getApiCallingSummary(apiCallingSummaryBO);
		int callingCount = taskService.getApiCallingSum(apiCallingSummaryBO);

		if (StringUtils.isNotBlank(apiCallingSummaryBO.getApiMethod())) {
			model.addAttribute("apiMethod", apiCallingSummaryBO.getApiMethod());
		}
		if (StringUtils.isNotBlank(apiCallingSummaryBO.getApiName())) {
			model.addAttribute("apiName", apiCallingSummaryBO.getApiName());
		}
		if (StringUtils.isNotBlank(apiCallingSummaryBO.getUserName())) {
			model.addAttribute("userName", apiCallingSummaryBO.getUserName());
		}
		if (StringUtils.isNotBlank(apiCallingSummaryBO.getMajorType())) {
			model.addAttribute("majorType", apiCallingSummaryBO.getMajorType());
		}
		if (StringUtils.isNotBlank(apiCallingSummaryBO.getProjectId())) {
			model.addAttribute("projectId", apiCallingSummaryBO.getProjectId());
		}
		model.addAttribute("majorTypes", majorTypeService.getAllMajorTypeList());
		model.addAttribute("callingCount", callingCount);
		model.addAttribute("callings", apiCallingCounts);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("startDate", apiCallingSummaryBO.getStartDate());
		model.addAttribute("endDate", apiCallingSummaryBO.getEndDate());
		model.addAttribute("currentPage", apiCallingSummaryBO.getPageNum() + 1);

		model.addAttribute("projects", projectService.getProjects());
		return "admin/list/count_list";
	}

	@RequestMapping(value = { "/calling/count", "/admin/calling/count" }, method = RequestMethod.GET)
	@ResponseBody
	public CommonAjaxResponse callingCount(HttpServletRequest request) {
		UserVO user = getCurrentUser(request);

		ApiCallingSummaryBO apiCallingSummaryBO = new ApiCallingSummaryBO();
		if (user != null) {
			apiCallingSummaryBO.setUserName(user.getUserName());
		}
		if (StringUtils.isNotBlank(request.getParameter("projectId"))) {
			String projectId = request.getParameter("projectId");
			apiCallingSummaryBO.setProjectId(projectId);
		}
		if (StringUtils.isNotBlank(request.getParameter("majorType"))) {
			String majorType = request.getParameter("majorType");
			apiCallingSummaryBO.setMajorType(majorType);
		}
		if (StringUtils.isNotBlank(request.getParameter("startTime"))) {
			String startTime = request.getParameter("startTime");
			apiCallingSummaryBO.setStartDate(startTime);
		}
		if (StringUtils.isNotBlank(request.getParameter("endTime"))) {
			String endTime = request.getParameter("endTime");
			apiCallingSummaryBO.setEndDate(endTime);
		}
		int totalCount = taskService.getApiCallingSummary(apiCallingSummaryBO);

		return CommonAjaxResponse.toSuccess(totalCount);
	}

	@ResponseBody
	@RequestMapping({ "/calling/exportData", "/admin/calling/exportData" })
	public String exportIpMac(HttpServletRequest request, HttpServletResponse response) throws Exception {
		UserVO user = getCurrentUser(request);
		String projectId = request.getParameter("projectId");
		String majorType = request.getParameter("majorType");
		String startTime = request.getParameter("startTime");
		String endTime = request.getParameter("endTime");
		List<String> dataList = callingService.getCallingExportData(projectId, majorType, startTime, endTime,
				user.getUserName());
		response.setCharacterEncoding("UTF-8");
		SimpleDateFormat dfs = new SimpleDateFormat("yyyyMMddHHmmss");
		Date time = new Date();
		String formatTime = dfs.format(time);
		String fileName = "统计数据_" + formatTime + ".csv";
		fileName = URLEncoder.encode(fileName, "UTF-8");

		response.setHeader("contentType", "text/html; charset=utf-8");
		response.setContentType("application/octet-stream");
		response.addHeader("Content-Disposition", "attachment; filename=" + fileName);

		String realPath = request.getSession().getServletContext().getRealPath("/");
		String path = realPath + "/" + fileName;
		File file = new File(path);
		BufferedInputStream bis = null;
		BufferedOutputStream out = null;
		FileWriterWithEncoding fwwe = new FileWriterWithEncoding(file, "UTF-8");
		fwwe.write(new String(new byte[] { (byte) 0xEF, (byte) 0xBB, (byte) 0xBF }));
		BufferedWriter bw = new BufferedWriter(fwwe);
		if (dataList != null && !dataList.isEmpty()) {
			for (String data : dataList) {
				bw.write(data);
				bw.write("\n");
			}
		}
		bw.close();
		fwwe.close();
		try {
			bis = new BufferedInputStream(new FileInputStream(file));
			out = new BufferedOutputStream(response.getOutputStream());
			byte[] buff = new byte[2048];
			while (true) {
				int bytesRead;
				if (-1 == (bytesRead = bis.read(buff, 0, buff.length))) {
					break;
				}
				out.write(buff, 0, bytesRead);
			}
		} catch (IOException e) {
			logger.info("export data fail, cause by " + e.getMessage());
			throw e;
		} finally {
			try {
				if (bis != null) {
					bis.close();
				}
				if (out != null) {
					out.flush();
					out.close();
				}
			} catch (IOException e) {
				logger.info("stream close fail, cause by " + e.getMessage());
				throw e;
			}
		}
		file.delete();
		return null;
	}
}
