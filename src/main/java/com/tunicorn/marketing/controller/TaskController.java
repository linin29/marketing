package com.tunicorn.marketing.controller;

import java.util.Date;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tunicorn.common.api.Message;
import com.tunicorn.marketing.api.CommonAjaxResponse;
import com.tunicorn.marketing.api.IdentifyAjaxResponse;
import com.tunicorn.marketing.bo.ApiCallingSummaryBO;
import com.tunicorn.marketing.bo.CropBO;
import com.tunicorn.marketing.bo.OrderBO;
import com.tunicorn.marketing.bo.ServiceResponseBO;
import com.tunicorn.marketing.bo.StitcherBO;
import com.tunicorn.marketing.bo.TaskBO;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.service.TaskService;
import com.tunicorn.marketing.vo.ApiCallingSummaryVO;
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

	@RequestMapping(value = "/calling", method = RequestMethod.GET)
	public String calling(HttpServletRequest request, Model model) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		ApiCallingSummaryBO apiCallingSummaryBO = new ApiCallingSummaryBO();
		apiCallingSummaryBO.setUserName(user.getUserName());

		List<ApiCallingSummaryVO> apiCallingCounts = taskService.getApiCallingSummaryList(apiCallingSummaryBO);
		int totalCount = taskService.getApiCallingSummary(apiCallingSummaryBO);

		int callingCount = 0;
		if (apiCallingCounts != null && apiCallingCounts.size() > 0) {
			for (ApiCallingSummaryVO apiCallingCountVO : apiCallingCounts) {
				callingCount += apiCallingCountVO.getCallingTimes();
			}
		}

		model.addAttribute("callingCount", callingCount);
		model.addAttribute("callings", apiCallingCounts);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", 1);
		return "list/count_list";
	}

	@RequestMapping(value = "/calling/search", method = RequestMethod.GET)
	public String searchCalling(HttpServletRequest request, Model model) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		ApiCallingSummaryBO apiCallingSummaryBO = new ApiCallingSummaryBO();
		apiCallingSummaryBO.setUserName(user.getUserName());
		if (StringUtils.isNotBlank(request.getParameter("pageNum"))) {
			apiCallingSummaryBO.setPageNum(Integer.parseInt(request.getParameter("pageNum")));
		}

		List<ApiCallingSummaryVO> apiCallingCounts = taskService.getApiCallingSummaryList(apiCallingSummaryBO);
		int totalCount = taskService.getApiCallingSummary(apiCallingSummaryBO);

		int callingCount = 0;
		if (apiCallingCounts != null && apiCallingCounts.size() > 0) {
			for (ApiCallingSummaryVO apiCallingCountVO : apiCallingCounts) {
				callingCount += apiCallingCountVO.getCallingTimes();
			}
		}

		model.addAttribute("callingCount", callingCount);
		model.addAttribute("callings", apiCallingCounts);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", apiCallingSummaryBO.getPageNum() + 1);
		return "list/count_list";
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
			}
			if (StringUtils.endsWith(MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS, taskVO.getTaskStatus())
					&& taskVO.getResult()!=null) {
				model.addAttribute("goodResults", taskService.getResultList(taskVO));
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

	@RequestMapping(value = "/{taskId}/identify", method = RequestMethod.POST)
	@ResponseBody
	public IdentifyAjaxResponse taskIdentify(HttpServletRequest request, @PathVariable("taskId") String taskId,
			Model model) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		ServiceResponseBO response = taskService.taskIdentify(taskId, user.getId());
		if (response.isSuccess()) {
			return IdentifyAjaxResponse.toSuccess(((ObjectNode) response.getResult()).get("data"),
					((ObjectNode) response.getResult()).get("rows"), (ArrayNode)(((ObjectNode) response.getResult()).get("crops")),
					(ArrayNode)(((ObjectNode) response.getResult()).get("rows_length")));
		} else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return IdentifyAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}

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
}
