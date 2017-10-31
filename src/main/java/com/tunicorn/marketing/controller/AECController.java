package com.tunicorn.marketing.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.output.FileWriterWithEncoding;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tunicorn.marketing.api.CommonAjaxResponse;
import com.tunicorn.marketing.bo.TaskBO;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.service.TaskService;
import com.tunicorn.marketing.vo.TaskVO;
import com.tunicorn.marketing.vo.UserVO;

@Controller
@EnableAutoConfiguration
public class AECController extends BaseController {

	@Autowired
	private TaskService taskService;

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
		model.addAttribute("tasks", taskVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", taskBO.getPageNum() + 1);
		return "aec/aec";
	}

	@RequestMapping(value = "/aec/search", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse searchTask(HttpServletRequest request, @RequestBody TaskBO taskBO) {
		Map<String, Object> results = new HashMap<String, Object>();

		taskBO.setTaskStatus(MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS);

		List<TaskVO> tasks = new ArrayList<TaskVO>();
		int totalCount = 0;

		tasks = taskService.getTaskList(taskBO);
		totalCount = taskService.getTaskCount(taskBO);

		results.put("tasks", tasks);
		results.put("totalCount", totalCount);

		return CommonAjaxResponse.toSuccess(results);
	}

	@RequestMapping(value = "/aec/download", method = RequestMethod.POST)
	@ResponseBody
	public String download(HttpServletRequest request, HttpServletResponse response) throws Exception {
		UserVO user = getCurrentUser(request);
		String majorType = request.getParameter("taskIds");
		String startTime = request.getParameter("startTime");
		String endTime = request.getParameter("endTime");
		List<String> dataList = taskService.getTaskExportData(majorType, startTime, endTime, user.getId());
		response.setCharacterEncoding("UTF-8");
		SimpleDateFormat dfs = new SimpleDateFormat("yyyyMMddHHmmss");
		Date time = new Date();
		String formatTime = dfs.format(time);
		String fileName = majorType + "_" + formatTime + ".csv";

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
				throw e;
			}
		}
		file.delete();
		return null;
	}
}
