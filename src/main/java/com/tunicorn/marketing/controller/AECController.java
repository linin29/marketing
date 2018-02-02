package com.tunicorn.marketing.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.tunicorn.marketing.api.CommonAjaxResponse;
import com.tunicorn.marketing.bo.AecBO;
import com.tunicorn.marketing.bo.TaskBO;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.service.ProjectService;
import com.tunicorn.marketing.service.TaskService;
import com.tunicorn.marketing.utils.ZipUtils;
import com.tunicorn.marketing.vo.TaskVO;
import com.tunicorn.marketing.vo.UserVO;

@Controller
@EnableAutoConfiguration
public class AECController extends BaseController {

	private static Logger logger = Logger.getLogger(AECController.class);
	
	@Autowired
	private TaskService taskService;
	@Autowired
	private ProjectService projectService;

	@RequestMapping(value = "/aec", method = RequestMethod.GET)
	public String aec(HttpServletRequest request, Model model) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		TaskBO taskBO = new TaskBO();
		taskBO.setUserId(user.getId());
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();
		taskBO.setEndTime(sdFormat.format(date));
		Date before2Day = getBefore2Day(date);
		taskBO.setStartTime(sdFormat.format(before2Day));
		taskBO.setTaskStatus(MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS);

		List<TaskVO> taskVOs = taskService.getTaskList(taskBO);
		int totalCount = taskService.getTaskCount(taskBO);

		model.addAttribute("majorTypes", taskService.getMajorTypeVOList(user.getUserName()));
		model.addAttribute("projects",  projectService.getProjectsByUserId(user.getId()));
		model.addAttribute("tasks", taskVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", taskBO.getPageNum() + 1);
		return "aec/aec";
	}

	@RequestMapping(value = "/aec/search", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse searchTask(HttpServletRequest request, @RequestBody TaskBO taskBO) {
		UserVO user = getCurrentUser(request);
		Map<String, Object> results = new HashMap<String, Object>();

		taskBO.setUserId(user.getId());
		taskBO.setTaskStatus(MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS);

		List<TaskVO> tasks = new ArrayList<TaskVO>();
		int totalCount = 0;

		tasks = taskService.getTaskList(taskBO);
		totalCount = taskService.getTaskCount(taskBO);

		results.put("tasks", tasks);
		results.put("totalCount", totalCount);

		return CommonAjaxResponse.toSuccess(results);
	}

	@RequestMapping(value = "/aec/download", method = RequestMethod.GET)
	public void download(HttpServletRequest request, HttpServletResponse response) throws Exception {
		SimpleDateFormat dfs = new SimpleDateFormat("yyyyMMddHHmmss");
		Date time = new Date();
		String formatTime = dfs.format(time);
		String zipName = "aec_" + formatTime + ".zip";

		String taskIdStr = request.getParameter("taskIds");
		String[] taskIds = taskIdStr.split(",");
		List<AecBO> fileList = taskService.getAecsByTaskIds(taskIds);

		response.setHeader("contentType", "text/html; charset=utf-8");
		response.setHeader("Content-Disposition", "attachment; filename=" + zipName);

		response.setContentType("application/octet-stream");

		ZipOutputStream out = new ZipOutputStream(response.getOutputStream());
		try {
			for (AecBO aecBO : fileList) {
				ZipUtils.doCompress(aecBO.getImage(), out);
				ZipUtils.doCompress(aecBO.getAnnotationXML(), out);

				/*
				 * File imageFile = new File(aecBO.getImage()); File xmlFile =
				 * new File(aecBO.getAnnotationXML());
				 * 
				 * imageFile.delete(); xmlFile.delete();
				 */

				response.flushBuffer();
			}
		} catch (Exception e) {
			logger.info("aec download file zip fail, cause by " + e.getMessage());
		} finally {
			out.close();
		}

	}

	@RequestMapping(value = "/aec/upload", method = RequestMethod.POST)
	@ResponseBody
	public String upload(HttpServletRequest request,
			@RequestParam(value = "zipFile", required = false) MultipartFile zipFile, HttpServletResponse response) {
		String failFilePath = taskService.aecUpload(zipFile);
		return failFilePath;
	}

	@RequestMapping(value = "/aec/uploadResult/download", method = RequestMethod.GET)
	public void uploadResultdownload(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String filePath = request.getParameter("filePath");
		if (StringUtils.isNotBlank(filePath)) {
			int index = filePath.lastIndexOf(File.separator);
			response.setHeader("contentType", "text/html; charset=utf-8");
			response.setHeader("Content-Disposition", "attachment; filename=" + filePath.substring(index + 1));

			response.setContentType("application/octet-stream");
			BufferedInputStream in = null;
			BufferedOutputStream out = null;
			try {
				File file = new File(filePath);
				in = new BufferedInputStream(new FileInputStream(file));
				out = new BufferedOutputStream(response.getOutputStream());
				byte[] data = new byte[1024];
				int len = 0;
				while ((len = in.read(data)) != -1) {
					out.write(data, 0, len);
				}
			} catch (Exception e) {
				logger.info("download aec upload result fail, cause by " + e.getMessage());
			} finally {
				if (in != null) {
					in.close();
				}
				if (out != null) {
					out.close();
				}
			}
		}
	}
}
