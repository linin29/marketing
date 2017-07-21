package com.tunicorn.marketing.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.output.FileWriterWithEncoding;
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

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tunicorn.common.api.Message;
import com.tunicorn.marketing.api.CommonAjaxResponse;
import com.tunicorn.marketing.bo.CropBO;
import com.tunicorn.marketing.bo.OrderBO;
import com.tunicorn.marketing.bo.ServiceResponseBO;
import com.tunicorn.marketing.bo.StitcherBO;
import com.tunicorn.marketing.bo.TaskBO;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.service.TaskService;
import com.tunicorn.marketing.vo.GoodsSkuVO;
import com.tunicorn.marketing.vo.TaskImagesVO;
import com.tunicorn.marketing.vo.TaskVO;
import com.tunicorn.marketing.vo.UserVO;
import com.tunicorn.util.MessageUtils;

@Controller
@EnableAutoConfiguration
public class TaskController extends BaseController {

	@Autowired
	private TaskService taskService;

	@RequestMapping(value = "/export", method = RequestMethod.GET)
	public String export(HttpServletRequest request, Model model) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);
		
		TaskBO taskBO = new TaskBO();
		taskBO.setUserId(user.getId());
		SimpleDateFormat sdFormat = new SimpleDateFormat("yyy-MM-dd HH:mm:ss");
		Date date = new Date();
		taskBO.setEndTime(sdFormat.format(date));
		Date before2Day = getBefore2Day(date);
		taskBO.setStartTime(sdFormat.format(before2Day));
		taskBO.setTaskStatus(MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS);
		
		model.addAttribute("majorTypes", taskService.getMajorTypeVOList());
		model.addAttribute("taskStatus", MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS);
		model.addAttribute("totalCount", 0);
		model.addAttribute("currentPage", 1);
		return "list/exportData";
	}
	
	@RequestMapping(value = "/export/search", method = RequestMethod.GET)
	public String searchExport(HttpServletRequest request, Model model) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		TaskBO taskBO = new TaskBO();
		taskBO.setUserId(user.getId());
		if (StringUtils.isNotBlank(request.getParameter("pageNum"))) {
			taskBO.setPageNum(Integer.parseInt(request.getParameter("pageNum")));
		}
		if (StringUtils.isNotBlank(request.getParameter("majorType"))) {
			String majorType = request.getParameter("majorType");
			taskBO.setMajorType(majorType);
			model.addAttribute("majorType", majorType);
		}
		if (StringUtils.isNotBlank(request.getParameter("startTime"))) {
			String startTime = request.getParameter("startTime");
			model.addAttribute("startTime", startTime);
			taskBO.setStartTime(startTime);
		}
		if (StringUtils.isNotBlank(request.getParameter("endTime"))) {
			String endTime = request.getParameter("endTime");
			model.addAttribute("endTime", endTime);
			taskBO.setEndTime(endTime);
		}
		if (StringUtils.isNotBlank(request.getParameter("taskStatus"))) {
			String taskStatus = request.getParameter("taskStatus");
			model.addAttribute("taskStatus", taskStatus);
			taskBO.setTaskStatus(taskStatus);
		}
		List<TaskVO> taskVOs = taskService.getTaskList(taskBO);
		int totalCount = taskService.getTaskCount(taskBO);
		
		model.addAttribute("majorTypes", taskService.getMajorTypeVOList());
		model.addAttribute("tasks", taskVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", taskBO.getPageNum() + 1);
		return "list/exportData";
	}
	
	@RequestMapping(value = "/task/count", method = RequestMethod.GET)
	@ResponseBody
	public CommonAjaxResponse taskCount(HttpServletRequest request) {
		UserVO user = getCurrentUser(request);

		TaskBO taskBO = new TaskBO();
		taskBO.setUserId(user.getId());
		if (StringUtils.isNotBlank(request.getParameter("majorType"))) {
			String majorType = request.getParameter("majorType");
			taskBO.setMajorType(majorType);
		}
		if (StringUtils.isNotBlank(request.getParameter("startTime"))) {
			String startTime = request.getParameter("startTime");
			taskBO.setStartTime(startTime);
		}
		if (StringUtils.isNotBlank(request.getParameter("endTime"))) {
			String endTime = request.getParameter("endTime");
			taskBO.setEndTime(endTime);
		}
		taskBO.setTaskStatus(MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS);

		int totalCount = taskService.getTaskCount(taskBO);
		
		return CommonAjaxResponse.toSuccess(totalCount);
	}
	
	@ResponseBody
	@RequestMapping("/exportData")
	public String exportIpMac(HttpServletRequest request, HttpServletResponse response) throws Exception {
		UserVO user = getCurrentUser(request);
		String majorType = request.getParameter("majorType");
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
	
	@RequestMapping(value = "/task", method = RequestMethod.GET)
	public String task(HttpServletRequest request, Model model) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		TaskBO taskBO = new TaskBO();
		taskBO.setUserId(user.getId());

		List<TaskVO> taskVOs = taskService.getTaskList(taskBO);
		int totalCount = taskService.getTaskCount(taskBO);

		model.addAttribute("tasks", taskVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", 1);
		return "list/task_list";
	}

	@RequestMapping(value = "/showTask/{taskId}", method = RequestMethod.GET)
	public String task(HttpServletRequest request, Model model, @PathVariable("taskId") String taskId) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		TaskVO taskVO = taskService.getTaskById(taskId);
		List<TaskImagesVO> imagesVOs = taskService.getTaskImagesListByTaskId(taskId);

		if (taskVO != null) {
			if (StringUtils.endsWith(MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS, taskVO.getTaskStatus())
					&& StringUtils.isNotBlank(taskVO.getRows())) {
				String rowsStr = taskVO.getRows();
				if (rowsStr.charAt(rowsStr.length() - 1) == MarketingConstants.COMMA) {
					model.addAttribute("rows", rowsStr.substring(0, rowsStr.length() - 1));
				} else {
					model.addAttribute("rows", rowsStr);
				}
				model.addAttribute("stitchBorderImagePath", taskService.getBorderImagePath(taskVO));
			}

			if (StringUtils.endsWith(MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS, taskVO.getTaskStatus())
					&& taskVO.getResult() != null) {
				model.addAttribute("goodResults", taskService.getResultList(taskVO));
				String resultStr = (String) taskVO.getResult();
				if (StringUtils.isNotBlank(resultStr)) {
					ObjectMapper mapper = new ObjectMapper();
					ObjectNode nodeResult;
					try {
						nodeResult = (ObjectNode) mapper.readTree(resultStr);
						JsonNode jsonNode = nodeResult.findValue("total_area");
						if (jsonNode != null) {
							model.addAttribute("totalArea", jsonNode.asText());
						}
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
			if (StringUtils.endsWith(MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS, taskVO.getTaskStatus())) {
				model.addAttribute("goodsSkus", taskService.getGoods(taskVO.getMajorType()));
			}
			if (StringUtils.isNotBlank(taskVO.getStitchImagePath())) {
				model.addAttribute("stitchImagePath", taskVO.getStitchImagePath() + "?random=" + new Date().getTime());
			}
		}
		model.addAttribute("majorTypes", taskService.getMajorTypeVOList());
		model.addAttribute("task", taskVO);
		model.addAttribute("images", imagesVOs);
		return "list/new_list";
	}
	
	@RequestMapping(value = "/showView/{taskId}", method = RequestMethod.GET)
	public String viewTask(HttpServletRequest request, Model model, @PathVariable("taskId") String taskId) {
		TaskVO taskVO = taskService.getTaskById(taskId);
		List<TaskImagesVO> imagesVOs = taskService.getTaskImagesListByTaskId(taskId);

		if (taskVO != null) {
			if (StringUtils.endsWith(MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS, taskVO.getTaskStatus())
					&& StringUtils.isNotBlank(taskVO.getRows())) {
				String rowsStr = taskVO.getRows();
				if (rowsStr.charAt(rowsStr.length() - 1) == MarketingConstants.COMMA) {
					model.addAttribute("rows", rowsStr.substring(0, rowsStr.length() - 1));
				} else {
					model.addAttribute("rows", rowsStr);
				}
				model.addAttribute("stitchBorderImagePath", taskService.getBorderImagePath(taskVO));
			}

			if (StringUtils.endsWith(MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS, taskVO.getTaskStatus())
					&& taskVO.getResult() != null) {
				model.addAttribute("goodResults", taskService.getResultList(taskVO));
				String resultStr = (String) taskVO.getResult();
				if (StringUtils.isNotBlank(resultStr)) {
					ObjectMapper mapper = new ObjectMapper();
					ObjectNode nodeResult;
					try {
						nodeResult = (ObjectNode) mapper.readTree(resultStr);
						JsonNode jsonNode = nodeResult.findValue("total_area");
						if (jsonNode != null) {
							model.addAttribute("totalArea", jsonNode.asText());
						}
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
			if (StringUtils.endsWith(MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS, taskVO.getTaskStatus())) {
				model.addAttribute("goodsSkus", taskService.getGoods(taskVO.getMajorType()));
			}
			if (StringUtils.isNotBlank(taskVO.getStitchImagePath())) {
				model.addAttribute("stitchImagePath", taskVO.getStitchImagePath() + "?random=" + new Date().getTime());
			}
		}
		
		
		model.addAttribute("majorTypes", taskService.getMajorTypeVOList());
		model.addAttribute("task", taskVO);
		model.addAttribute("images", imagesVOs);
		return "list/task_view";
	}

	@RequestMapping(value = "/taskResult/{taskId}", method = RequestMethod.GET)
	@ResponseBody
	public CommonAjaxResponse taskResult(HttpServletRequest request, @PathVariable("taskId") String taskId) {
		ObjectNode node = taskService.getTaskResult(taskId);
		return CommonAjaxResponse.toSuccess(node);
	}

	@RequestMapping(value = "/task/search", method = RequestMethod.GET)
	public String searchTask(HttpServletRequest request, Model model) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		TaskBO taskBO = new TaskBO();
		taskBO.setUserId(user.getId());
		if (StringUtils.isNotBlank(request.getParameter("pageNum"))) {
			taskBO.setPageNum(Integer.parseInt(request.getParameter("pageNum")));
		}
		if (StringUtils.isNotBlank(request.getParameter("taskName"))) {
			String taskName = request.getParameter("taskName");
			taskBO.setName(taskName);
			model.addAttribute("taskName", taskName);
		}
		if (StringUtils.isNotBlank(request.getParameter("taskId"))) {
			String taskId = request.getParameter("taskId");
			model.addAttribute("taskId", taskId);
			taskBO.setId(taskId);
		}
		List<TaskVO> taskVOs = taskService.getTaskList(taskBO);
		int totalCount = taskService.getTaskCount(taskBO);

		model.addAttribute("tasks", taskVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", taskBO.getPageNum() + 1);
		return "list/task_list";
	}

	@RequestMapping(value = "/task/create", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse createTask(HttpServletRequest request,
			@RequestParam(value = "images", required = false) List<MultipartFile> images,
			@RequestParam(value = "taskLabel") String taskName, Model model) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		ServiceResponseBO response = taskService.createTask(user.getId(), taskName, images);
		if (response.isSuccess()) {
			return CommonAjaxResponse.toSuccess(response.getResult());
		} else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}

	@RequestMapping(value = "/images/upload", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse uploadImages(HttpServletRequest request,
			@RequestParam(value = "images", required = false) List<MultipartFile> images,
			@RequestParam(value = "taskId") String taskId, Model model) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		ServiceResponseBO response = taskService.taskImages(images, taskId, user.getId());
		if (response.isSuccess()) {
			return CommonAjaxResponse.toSuccess(response.getResult());
		} else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}

	@RequestMapping(value = "/{taskId}/status", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse status(HttpServletRequest request, @PathVariable("taskId") String taskId, Model model) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		ServiceResponseBO response = taskService.taskStatus(taskId);
		if (response.isSuccess()) {
			return CommonAjaxResponse.toSuccess(response.getResult());
		} else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}

	@RequestMapping(value = "/{taskId}/stitcher", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse taskStitcher(HttpServletRequest request, @RequestBody StitcherBO stitcherBO,
			@PathVariable("taskId") String taskId, Model model) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		ServiceResponseBO response = taskService.taskStitcher(taskId, stitcherBO.getNeedStitch(),
				stitcherBO.getMajorType(), user.getId());
		if (response.isSuccess()) {
			return CommonAjaxResponse.toSuccess(response.getResult());
		} else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}

//	@RequestMapping(value = "/{taskId}/identify", method = RequestMethod.POST)
//	@ResponseBody
//	public IdentifyAjaxResponse taskIdentify(HttpServletRequest request, @PathVariable("taskId") String taskId,
//			Model model) {
//		UserVO user = getCurrentUser(request);
//		model.addAttribute("user", user);
//
//		ServiceResponseBO response = taskService.taskIdentify(taskId, user.getId());
//		if (response.isSuccess()) {
//			return IdentifyAjaxResponse.toSuccess(((ObjectNode) response.getResult()).get("data"),
//					((ObjectNode) response.getResult()).get("rows"), (ArrayNode)(((ObjectNode) response.getResult()).get("crops")),
//					(ArrayNode)(((ObjectNode) response.getResult()).get("rows_length")),
//					((ObjectNode) response.getResult()).get("results_border").asText(),
//					((ObjectNode) response.getResult()).get("total_area").asLong());
//		} else {
//			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
//			return IdentifyAjaxResponse.toFailure(message.getCode(), message.getMessage());
//		}
//	}

	@RequestMapping(value = "/{taskId}/order", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse taskOrder(HttpServletRequest request, @PathVariable("taskId") String taskId, Model model,
			@RequestBody List<OrderBO> orderBO) {

		ServiceResponseBO response = taskService.taskOrder(orderBO, taskId);
		if (response.isSuccess()) {
			return CommonAjaxResponse.toSuccess(response.getResult());
		} else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}

	@RequestMapping(value = "/{taskId}/images/{taskImagesId}", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse deleteImage(HttpServletRequest request, @PathVariable("taskId") String taskId,
			@PathVariable("taskImagesId") String taskImagesId, Model model) {
		ServiceResponseBO response = taskService.deleteImage(taskId, taskImagesId);
		if (response.isSuccess()) {
			return CommonAjaxResponse.toSuccess(response.getResult());
		} else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}

	@RequestMapping(value = "/{taskId}/images", method = RequestMethod.GET)
	@ResponseBody
	public List<TaskImagesVO> taskImagesList(@PathVariable("taskId") String taskId) {
		List<TaskImagesVO> imagesVOs = taskService.getTaskImagesListByTaskId(taskId);
		return imagesVOs;
	}

	@RequestMapping(value = "/{taskId}/crops/{produceId}", method = RequestMethod.GET)
	@ResponseBody
	public List<CropBO> taskIdentifyCrops(@PathVariable("taskId") String taskId,
			@PathVariable("produceId") Integer produceId) {
		return taskService.getTaskIdentifyCrops(taskId, produceId);
	}

	@RequestMapping(value = "/goodsSkus", method = RequestMethod.GET)
	@ResponseBody
	public List<GoodsSkuVO> getGoodsSkuList(HttpServletRequest request) {
		return taskService.getGoods(request.getParameter("majorType"));
	}
	
	private Date getBefore2Day(Date date) {  
        Calendar calendar = Calendar.getInstance();  
        calendar.setTime(date);  
        calendar.add(Calendar.DAY_OF_MONTH, -2);  
        date = calendar.getTime();  
        return date;  
    } 
}
