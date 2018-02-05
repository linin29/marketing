package com.tunicorn.marketing.resource;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tunicorn.common.api.Message;
import com.tunicorn.common.entity.AjaxResponse;
import com.tunicorn.marketing.api.CommonAjaxResponse;
import com.tunicorn.marketing.api.ImageListAjaxResponse;
import com.tunicorn.marketing.api.TaskListAjaxResponse;
import com.tunicorn.marketing.bo.OrderBO;
import com.tunicorn.marketing.bo.ServiceResponseBO;
import com.tunicorn.marketing.bo.TaskBO;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.service.MajorTypeService;
import com.tunicorn.marketing.service.TaskService;
import com.tunicorn.marketing.vo.GoodsSkuVO;
import com.tunicorn.marketing.vo.MajorTypeApiVO;
import com.tunicorn.marketing.vo.TaskImagesVO;
import com.tunicorn.marketing.vo.TaskVO;
import com.tunicorn.marketing.vo.TokenVO;
import com.tunicorn.util.MessageUtils;

import net.sf.json.JSONObject;

@RestController
@EnableAutoConfiguration
@RequestMapping(value = "/api/v1/marketing", produces = "application/json;charset=utf-8")
@Validated
public class TaskResource extends BaseResource {
	private static Logger logger = Logger.getLogger(TaskResource.class);

	@Autowired
	private TaskService taskService;
	@Autowired
	private MajorTypeService majorTypeService;

	@RequestMapping(value = "/tasks", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse tasks(HttpServletRequest request,
			@RequestParam(value = "images", required = false) List<MultipartFile> images,
			@RequestParam(value = "taskLabel") String taskName, @RequestParam(value="projectId") String projectId, 
			@RequestParam(value="storeCode") String storeCode) {

		AjaxResponse tokenStatus = checkToken(request);
		if (!tokenStatus.getSuccess()) {
			logger.info(tokenStatus.getErrorMessage());
			return CommonAjaxResponse.toFailure(tokenStatus.getErrorCode(), tokenStatus.getErrorMessage());
		}

		TokenVO token = (TokenVO) tokenStatus.getData();

//		ServiceResponseBO response = taskService.createTask(token.getUserId(), taskName, images);
		ServiceResponseBO response = taskService.createTask(token.getUserId(), taskName,projectId, storeCode, images);
		if (response.isSuccess()) {
			return CommonAjaxResponse.toSuccess(response.getResult());
		} else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}

	@RequestMapping(value = "/taskimages", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse taskImages(HttpServletRequest request, @RequestParam("images") List<MultipartFile> images,
			@RequestParam("taskId") String taskId) {

		AjaxResponse tokenStatus = checkToken(request);
		if (!tokenStatus.getSuccess()) {
			return CommonAjaxResponse.toFailure(tokenStatus.getErrorCode(), tokenStatus.getErrorMessage());
		}

		TokenVO token = (TokenVO) tokenStatus.getData();

		ServiceResponseBO response = taskService.taskImages(images, taskId, token.getUserId());
		if (response.isSuccess()) {
			return CommonAjaxResponse.toSuccess(response.getResult());
		} else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}

	@RequestMapping(value = "/{taskId}/stitcher", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse stitcher(HttpServletRequest request, @PathVariable("taskId") String taskId,
			@RequestParam(value = "needStitch", required = false) Boolean needStitch,
			@RequestParam("majorType") String majorType) {

		AjaxResponse tokenStatus = checkToken(request);
		if (!tokenStatus.getSuccess()) {
			return CommonAjaxResponse.toFailure(tokenStatus.getErrorCode(), tokenStatus.getErrorMessage());
		}

		TokenVO token = (TokenVO) tokenStatus.getData();

		ServiceResponseBO response = taskService.taskStitcher(taskId, needStitch, majorType, token.getUserId());
		if (response.isSuccess()) {
			return CommonAjaxResponse.toSuccess(response.getResult());
		} else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}

	// @RequestMapping(value = "/{taskId}/identify", method =
	// RequestMethod.POST)
	// @ResponseBody
	// public IdentifyAjaxResponse identify(HttpServletRequest request,
	// @PathVariable("taskId") String taskId) {
	//
	// AjaxResponse tokenStatus = checkToken(request);
	// if (!tokenStatus.getSuccess()) {
	// return IdentifyAjaxResponse.toFailure(tokenStatus.getErrorCode(),
	// tokenStatus.getErrorMessage());
	// }
	//
	// TokenVO token = (TokenVO) tokenStatus.getData();
	//
	// ServiceResponseBO response = taskService.taskIdentify(taskId,
	// token.getUserId());
	// if (response.isSuccess()) {
	// return IdentifyAjaxResponse.toSuccess(((ObjectNode)
	// response.getResult()).get("data"),
	// ((ObjectNode) response.getResult()).get("rows"),
	// (ArrayNode)(((ObjectNode) response.getResult()).get("crops")),
	// (ArrayNode)(((ObjectNode) response.getResult()).get("rows_length")),
	// ((ObjectNode) response.getResult()).get("results_border").asText(),
	// ((ObjectNode) response.getResult()).get("total_area").asLong());
	// } else {
	// Message message =
	// MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
	// return IdentifyAjaxResponse.toFailure(message.getCode(),
	// message.getMessage());
	// }
	// }

	@RequestMapping(value = "/{taskId}/status", method = RequestMethod.GET)
	@ResponseBody
	public CommonAjaxResponse status(HttpServletRequest request, @PathVariable("taskId") String taskId) {

		AjaxResponse tokenStatus = checkToken(request);
		if (!tokenStatus.getSuccess()) {
			return CommonAjaxResponse.toFailure(tokenStatus.getErrorCode(), tokenStatus.getErrorMessage());
		}

		ServiceResponseBO response = taskService.taskStatus(taskId);
		if (response.isSuccess()) {
			return CommonAjaxResponse.toSuccess(response.getResult());
		} else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}

	@RequestMapping(value = "/{taskId}/images", method = RequestMethod.GET)
	@ResponseBody
	public ImageListAjaxResponse taskImagesForAPI(HttpServletRequest request, @PathVariable("taskId") String taskId) {

		AjaxResponse tokenStatus = checkToken(request);
		if (!tokenStatus.getSuccess()) {
			return ImageListAjaxResponse.toFailure(tokenStatus.getErrorCode(), tokenStatus.getErrorMessage());
		}

		List<TaskImagesVO> imagesVOs = taskService.getTaskImagesListByTaskId(taskId);

		if (imagesVOs != null && imagesVOs.size() > 0) {
			for (TaskImagesVO taskImagesVO : imagesVOs) {
				taskImagesVO.setResourceId(taskImagesVO.getId());
				taskImagesVO.setImageUrl("/marketing" + taskImagesVO.getImagePath());
				taskImagesVO.setOrder_no(taskImagesVO.getOrderNo());
			}
			return ImageListAjaxResponse.toSuccess(imagesVOs, imagesVOs.size());
		} else {
			Message message = MessageUtils.getInstance().getMessage("marketing_db_not_found");
			return ImageListAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}

	@RequestMapping(value = "/{taskId}/images/{resourceId}", method = RequestMethod.DELETE)
	@ResponseBody
	public CommonAjaxResponse deleteImage(HttpServletRequest request, @PathVariable("taskId") String taskId,
			@PathVariable("resourceId") String taskImagesId) {

		AjaxResponse tokenStatus = checkToken(request);
		if (!tokenStatus.getSuccess()) {
			return CommonAjaxResponse.toFailure(tokenStatus.getErrorCode(), tokenStatus.getErrorMessage());
		}

		ServiceResponseBO response = taskService.deleteImage(taskId, taskImagesId);
		if (response.isSuccess()) {
			return CommonAjaxResponse.toSuccess(response.getResult());
		} else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}

	@RequestMapping(value = "/{taskId}/sort", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse saveOrder(HttpServletRequest request, @PathVariable("taskId") String taskId,
			@RequestBody List<OrderBO> imagesVOs) {

		AjaxResponse tokenStatus = checkToken(request);
		if (!tokenStatus.getSuccess()) {
			return CommonAjaxResponse.toFailure(tokenStatus.getErrorCode(), tokenStatus.getErrorMessage());
		}

		ServiceResponseBO response = taskService.taskOrder(imagesVOs, taskId);
		if (response.isSuccess()) {
			return CommonAjaxResponse.toSuccess(response.getResult());
		} else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}

	@RequestMapping(value = "/{taskId}/replace", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse replace(HttpServletRequest request, @PathVariable("taskId") String taskId,
			@RequestParam("resourceId") String taskImageId, @RequestParam("image") MultipartFile image) {

		AjaxResponse tokenStatus = checkToken(request);
		if (!tokenStatus.getSuccess()) {
			return CommonAjaxResponse.toFailure(tokenStatus.getErrorCode(), tokenStatus.getErrorMessage());
		}

		TokenVO token = (TokenVO) tokenStatus.getData();

		ServiceResponseBO response = taskService.replace(taskId, taskImageId, image, token.getAppId(),
				token.getUserId());
		if (response.isSuccess()) {
			return CommonAjaxResponse.toSuccess(response.getResult());
		} else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}

	@RequestMapping(value = "/list", method = RequestMethod.GET)
	@ResponseBody
	public TaskListAjaxResponse taskList(HttpServletRequest request,
			@RequestParam(value = "page", required = false) Integer page,
			@RequestParam(value = "taskId", required = false) String taskId,
			@RequestParam(value = "taskLabel", required = false) String taskName) {

		AjaxResponse tokenStatus = checkToken(request);
		if (!tokenStatus.getSuccess()) {
			return TaskListAjaxResponse.toFailure(tokenStatus.getErrorCode(), tokenStatus.getErrorMessage());
		}

		TokenVO token = (TokenVO) tokenStatus.getData();
		int currentPage = 0;
		TaskBO taskBO = new TaskBO();
		taskBO.setUserId(token.getUserId());
		if (StringUtils.isNotBlank(request.getParameter("pageNum"))) {
			currentPage = Integer.parseInt(request.getParameter("pageNum"));
			taskBO.setPageNum(Integer.parseInt(request.getParameter("pageNum")));
		}
		if (StringUtils.isNotBlank(taskName)) {
			taskBO.setName(taskName);
		}
		if (StringUtils.isNotBlank(taskId)) {
			taskBO.setId(taskId);
		}
		List<TaskVO> taskVOs = taskService.getTaskList(taskBO);
		if (taskVOs == null) {
			Message message = MessageUtils.getInstance().getMessage("marketing_db_error");
			return TaskListAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}

		for (TaskVO taskVO : taskVOs) {
			if (taskVO.getResult() != null) {
				ObjectMapper mapper = new ObjectMapper();
				JsonNode nodeResult;
				try {
					nodeResult = mapper.readTree((String) taskVO.getResult());
					taskVO.setResult(nodeResult);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		int totalCount = taskService.getTaskCount(taskBO);
		int pages = (int) Math.ceil((float) totalCount / MarketingConstants.PAGINATION_ITEMS_PER_PAGE);
		return TaskListAjaxResponse.toSuccess(taskVOs, totalCount, currentPage == 0 ? 1 : currentPage, pages);
	}

	@RequestMapping(value = "/majorTypes", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse majorTypeList(HttpServletRequest request) {

		AjaxResponse tokenStatus = checkToken(request);
		if (!tokenStatus.getSuccess()) {
			return CommonAjaxResponse.toFailure(tokenStatus.getErrorCode(), tokenStatus.getErrorMessage());
		}

		List<MajorTypeApiVO> majorTypes = majorTypeService.getMajorTypeListForApi();
		return CommonAjaxResponse.toSuccess(majorTypes);
	}

	@RequestMapping(value = "/skues", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse skuList(HttpServletRequest request, @RequestParam("majorType") String majorType) {

		AjaxResponse tokenStatus = checkToken(request);
		if (!tokenStatus.getSuccess()) {
			return CommonAjaxResponse.toFailure(tokenStatus.getErrorCode(), tokenStatus.getErrorMessage());
		}

		List<GoodsSkuVO> skuList = taskService.getGoods(majorType);
		return CommonAjaxResponse.toSuccess(skuList);
	}
	
	@RequestMapping(value = "/showView/{taskId}", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse showView(HttpServletRequest request, @PathVariable("taskId") String taskId) {

		AjaxResponse tokenStatus = checkToken(request);
		if (!tokenStatus.getSuccess()) {
			return CommonAjaxResponse.toFailure(tokenStatus.getErrorCode(), tokenStatus.getErrorMessage());
		}

		ServiceResponseBO response = taskService.showViewByTaskId(taskId);
		return CommonAjaxResponse.toSuccess(response.getResult());
	}
	
	/**
	 * @Description 创建在线比对任务
	 * @auther weixiaokai
	 * @date 2018年1月18日 下午3:38:26
	 * @param request
	 * @param images 上传图片最多不能超过20个
	 * @param taskName 任务名称
	 * @return
	 */
	@RequestMapping(value = "/synchro/tasks", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse synchroTasks(HttpServletRequest request,
			@RequestParam(value = "images", required = false) List<MultipartFile> images,
			@RequestParam(value = "taskLabel") String taskName, @RequestParam("majorType") String majorType) {

		AjaxResponse tokenStatus = checkToken(request);
		if (!tokenStatus.getSuccess()) {
			logger.info(tokenStatus.getErrorMessage());
			return CommonAjaxResponse.toFailure(tokenStatus.getErrorCode(), tokenStatus.getErrorMessage());
		}

		TokenVO token = (TokenVO) tokenStatus.getData();

		ServiceResponseBO response = taskService.createTask(token.getUserId(), taskName, images);	//创建task任务
		if (response.isSuccess()) {
			ObjectNode node = (ObjectNode) response.getResult();
			ServiceResponseBO serviceResponseBO = taskService.taskStitcherSync(node.get(MarketingConstants.TASK_ID).asText(), true, majorType, token.getUserId());
			JSONObject jsonObject = new JSONObject();
			if (serviceResponseBO.isSuccess()) {
				jsonObject.put("taskId", node.get(MarketingConstants.TASK_ID).asText());
				return CommonAjaxResponse.toSuccess(jsonObject);
			}else{
				Message mess = MessageUtils.getInstance().getMessage(String.valueOf(serviceResponseBO.getResult()));
				return CommonAjaxResponse.toFailure(mess.getCode(), mess.getMessage());
			}
		}else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}
	
	@RequestMapping(value = "/{taskId}/stitchImage", method = RequestMethod.GET)
	@ResponseBody
	public CommonAjaxResponse stitchImage(HttpServletRequest request, @PathVariable("taskId") String taskId) {

		AjaxResponse tokenStatus = checkToken(request);
		if (!tokenStatus.getSuccess()) {
			return CommonAjaxResponse.toFailure(tokenStatus.getErrorCode(), tokenStatus.getErrorMessage());
		}

		ServiceResponseBO response = taskService.getStitchImageByTaskId(taskId);
		if (response.isSuccess()) {
			return CommonAjaxResponse.toSuccess(response.getResult());
		} else {
			Message message = MessageUtils.getInstance().getMessage(String.valueOf(response.getResult()));
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
	}
}
