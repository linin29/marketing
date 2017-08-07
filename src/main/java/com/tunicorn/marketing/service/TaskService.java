package com.tunicorn.marketing.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tunicorn.common.api.Message;
import com.tunicorn.common.entity.UploadFile;
import com.tunicorn.marketing.api.CommonAjaxResponse;
import com.tunicorn.marketing.api.MarketingAPI;
import com.tunicorn.marketing.api.param.MarketingIdentifyMockRequestParam;
import com.tunicorn.marketing.api.param.MarketingIdentifyRequestParam;
import com.tunicorn.marketing.api.param.MarketingPullDataRequestParam;
import com.tunicorn.marketing.api.param.MarketingRectifyRequestParam;
import com.tunicorn.marketing.api.param.MarketingStitcherRequestParam;
import com.tunicorn.marketing.bo.ApiCallingSummaryBO;
import com.tunicorn.marketing.bo.CropBO;
import com.tunicorn.marketing.bo.GoodsBO;
import com.tunicorn.marketing.bo.GoodsSkuBO;
import com.tunicorn.marketing.bo.IdentifyUpdateParamBO;
import com.tunicorn.marketing.bo.ImageCropBO;
import com.tunicorn.marketing.bo.OrderBO;
import com.tunicorn.marketing.bo.ServiceResponseBO;
import com.tunicorn.marketing.bo.StitcherUpdateParamBO;
import com.tunicorn.marketing.bo.TaskBO;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.mapper.ApiCallingDetailMapper;
import com.tunicorn.marketing.mapper.ApiCallingSummaryMapper;
import com.tunicorn.marketing.mapper.GoodsSkuMapper;
import com.tunicorn.marketing.mapper.MajorTypeMapper;
import com.tunicorn.marketing.mapper.TaskDumpMapper;
import com.tunicorn.marketing.mapper.TaskImagesMapper;
import com.tunicorn.marketing.mapper.TaskMapper;
import com.tunicorn.marketing.mapper.UserMapper;
import com.tunicorn.marketing.utils.ConfigUtils;
import com.tunicorn.marketing.utils.MarketingStorageUtils;
import com.tunicorn.marketing.vo.ApiCallingDetailVO;
import com.tunicorn.marketing.vo.ApiCallingSummaryVO;
import com.tunicorn.marketing.vo.GoodsSkuVO;
import com.tunicorn.marketing.vo.MajorTypeVO;
import com.tunicorn.marketing.vo.TaskImagesVO;
import com.tunicorn.marketing.vo.TaskVO;
import com.tunicorn.marketing.vo.UserVO;
import com.tunicorn.util.JsonUtil;
import com.tunicorn.util.MessageUtils;

@Service
public class TaskService {
	private static Logger logger = Logger.getLogger(TaskService.class);
	@Autowired
	private TaskMapper taskMapper;
	@Autowired
	private TaskDumpMapper taskDumpMapper;
	@Autowired
	private TaskImagesMapper taskImagesMapper;
	@Autowired
	private UserMapper userMapper;
	@Autowired
	private ApiCallingSummaryMapper apiCallingSummaryMapper;
	@Autowired
	private ApiCallingDetailMapper apiCallingDetailMapper;
	@Autowired
	private MajorTypeMapper majorTypeMapper;
	@Autowired
	private GoodsSkuMapper goodsSkuMapper;

	@Transactional
	public ServiceResponseBO createTask(String userId, String taskName, List<MultipartFile> images) {
		TaskVO taskVO = taskMapper.getTaskByNameAndUserId(taskName, userId);
		if (taskVO != null) {
			return new ServiceResponseBO(false, "marketing_task_existed");
		}

		if (StringUtils.isBlank(taskName)) {
			return new ServiceResponseBO(false, "marketing_task_name_not_null");
		}
		if (images != null && images.size() > MarketingConstants.IMAGE_MAX_COUNT) {
			return new ServiceResponseBO(false, "marketing_image_max_count");
		}
		if (images != null && images.size() > 0) {
			for (int i = 0; i < images.size(); i++) {
				MultipartFile file = images.get(i);
				if (StringUtils.isNotBlank(file.getOriginalFilename())) {
					String fileName = file.getOriginalFilename();
					int index = fileName.lastIndexOf(MarketingConstants.POINT);
					if (!this.getImageTypeList().contains(fileName.substring(index + 1))) {
						return new ServiceResponseBO(false, "marketing_type_invalid");
					}
				}
			}
		}
		// create task
		TaskVO createTaskVO = new TaskVO();
		createTaskVO.setId(
				(Long.toHexString(new Date().getTime()) + RandomStringUtils.randomAlphanumeric(13)).toLowerCase());
		createTaskVO.setName(taskName);
		createTaskVO.setUserId(userId);
		createTaskVO.setTaskStatus(MarketingConstants.TASK_INIT_STATUS);
		taskMapper.createTask(createTaskVO);
		if (images != null && images.size() > 0) {
			List<TaskImagesVO> taskImagesVOs = new ArrayList<TaskImagesVO>();
			for (int i = 0; i < images.size(); i++) {
				TaskImagesVO taskImagesVO = new TaskImagesVO();
				UploadFile file = MarketingStorageUtils.getUploadFile(images.get(i), createTaskVO.getId(),
						ConfigUtils.getInstance().getConfigValue("marketing.image.sub.dir"), false);
				if (file == null) {
					return new ServiceResponseBO(false, "marketing_save_upload_file_error");
				}
				taskImagesVO.setId((Long.toHexString(new Date().getTime()) + RandomStringUtils.randomAlphanumeric(13))
						.toLowerCase());
				taskImagesVO.setName(file.getName());
				taskImagesVO.setUserId(createTaskVO.getUserId());
				taskImagesVO.setTaskId(createTaskVO.getId());
				int index = file.getPath().indexOf(MarketingConstants.MARKETING);
				String imagePath = file.getPath().substring(index + MarketingConstants.MARKETING.length());
				taskImagesVO.setImagePath(imagePath);
				taskImagesVO.setFullPath(file.getPath());
				taskImagesVO.setOrderNo(i + 1);
				taskImagesVOs.add(taskImagesVO);
			}
			taskImagesMapper.batchInsertTaskImages(taskImagesVOs);
			taskMapper.updateTaskStatus(createTaskVO.getId(), MarketingConstants.TASK_STATUS_IMAGE_UPLOADED);
		}

		ObjectMapper mapper = new ObjectMapper();
		ObjectNode node = mapper.createObjectNode();
		node.put(MarketingConstants.TASK_ID, createTaskVO.getId());
		if (images != null && images.size() > 0) {
			node.put("length", images.size());
		}
		return new ServiceResponseBO(node);
	}

	@Transactional
	public ServiceResponseBO taskImages(List<MultipartFile> images, String taskId, String userId) {
		if (images != null && images.size() > MarketingConstants.IMAGE_MAX_COUNT) {
			return new ServiceResponseBO(false, "marketing_image_max_count");
		}
		int imageCount = taskImagesMapper.getTaskImagesCountByTaskId(taskId);
		if (images != null && (images.size() + imageCount > MarketingConstants.IMAGE_MAX_COUNT)) {
			return new ServiceResponseBO(false, "marketing_image_max_count");
		}
		if (images != null && images.size() > 0) {
			for (int i = 0; i < images.size(); i++) {
				MultipartFile file = images.get(i);
				if (StringUtils.isNotBlank(file.getOriginalFilename())) {
					String fileName = file.getOriginalFilename();
					int index = fileName.lastIndexOf(MarketingConstants.POINT);
					if (!this.getImageTypeList().contains(fileName.substring(index + 1))) {
						return new ServiceResponseBO(false, "marketing_type_invalid");
					}
				}
			}
		}
		int result = this.addImages(taskId, userId, images);

		if (result > 0) {
			ObjectMapper mapper = new ObjectMapper();
			ObjectNode node = mapper.createObjectNode();
			node.put(MarketingConstants.TASK_ID, taskId);
			node.put("length", images.size());
			return new ServiceResponseBO(node);
		} else if (result == -1) {
			return new ServiceResponseBO(false, "marketing_save_upload_file_error");
		} else {
			return new ServiceResponseBO(false, "marketing_db_error");
		}
	}

	@SuppressWarnings("deprecation")
	public ServiceResponseBO taskStatus(String taskId) {
		TaskVO taskVO = taskMapper.getTaskById(taskId);
		if (taskVO != null) {
			ObjectMapper mapper = new ObjectMapper();
			ObjectNode newNode = mapper.createObjectNode();
			newNode.put("task_status", taskVO.getTaskStatus());
			newNode.put("success", true);
			if (StringUtils.equals(taskVO.getTaskStatus(), MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS)) {
				if (taskVO.getResult() != null) {
					newNode = this.getObjectNode(taskVO);
				}
			} else if (StringUtils.equals(taskVO.getTaskStatus(), MarketingConstants.TASK_STATUS_IDENTIFY_FAILURE)) {
				Message message = MessageUtils.getInstance().getMessage("marketing_identify_failure");
				ObjectNode objectNode = mapper.createObjectNode();
				objectNode.put("errcode", message.getCode());
				objectNode.put("errmsg", message.getMessage());
				newNode.put("result", objectNode);
			} else if (StringUtils.equals(taskVO.getTaskStatus(), MarketingConstants.TASK_STATUS_STITCH_FAILURE)) {
				Message message = MessageUtils.getInstance().getMessage("marketing_stitch_failure");
				String rows = taskVO.getRows();
				String result = (String) taskVO.getResult();
				newNode.put("image", MarketingConstants.PIC_MARKETING + taskVO.getStitchImagePath());
				newNode.put("rows", 0);
				newNode.put("totalArea", 0);
				if (StringUtils.isNotBlank(rows)) {
					newNode.put("rows", rows.substring(0, rows.length() - 1));
				}
				if (StringUtils.isNotBlank(result) && result.contains("errorIndices")) {
					ObjectNode nodeResult;
					try {
						nodeResult = (ObjectNode) mapper.readTree(result);
						ArrayNode jsonNodes = (ArrayNode) nodeResult.findValue("errorIndices");
						newNode.put("errorIndices", jsonNodes.toString());
					} catch (IOException e) {
						logger.info("获取任务返回goodResults结果失败");
					}
				}
				ObjectNode objectNode = mapper.createObjectNode();
				objectNode.put("errcode", message.getCode());
				objectNode.put("errmsg", message.getMessage());
				newNode.put("result", objectNode);
			} else if (StringUtils.equals(taskVO.getTaskStatus(), MarketingConstants.TASK_STATUS_STITCH_SUCCESS)) {
				newNode.put("image", MarketingConstants.PIC_MARKETING + taskVO.getStitchImagePath());
				String rows = taskVO.getRows();
				newNode.put("rows", 0);
				newNode.put("totalArea", 0);
				if (StringUtils.isNotBlank(rows)) {
					newNode.put("rows", rows.substring(0, rows.length() - 1));
				}
				String resultStr = (String) taskVO.getResult();
				if (StringUtils.isNotBlank(resultStr)) {
					ObjectMapper tempMapper = new ObjectMapper();
					ObjectNode nodeResult;
					try {
						nodeResult = (ObjectNode) tempMapper.readTree(resultStr);
						JsonNode jsonNode = nodeResult.findValue("total_area");
						if (jsonNode != null) {
							newNode.put("totalArea", jsonNode.asText());
						}
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
			return new ServiceResponseBO(newNode);
		} else {
			return new ServiceResponseBO(false, "marketing_task_not_existed");
		}
	}

	public ServiceResponseBO taskStitcher(String taskId, Boolean needStitch, String majorType, String userId) {
		TaskVO taskVO = taskMapper.getTaskById(taskId);
		UserVO userVO = userMapper.getUserByID(userId);
		if (taskVO == null) {
			return new ServiceResponseBO(false, "marketing_task_not_existed");
		}
		if (!StringUtils.endsWith(taskVO.getTaskStatus(), MarketingConstants.TASK_STATUS_IMAGE_UPLOADED)) {
			return new ServiceResponseBO(false, "marketing_status_invalid");
		}
		List<TaskImagesVO> imagesVOs = taskImagesMapper.getTaskImagesListByTaskId(taskId);
		if (imagesVOs == null || imagesVOs.size() == 0) {
			return new ServiceResponseBO(false, "marketing_db_not_found");
		}
		MarketingStitcherRequestParam param = new MarketingStitcherRequestParam();
		if (needStitch == null) {
			needStitch = true;
		}
		if (!this.getMajorTypeList(userVO.getUserName()).contains(majorType)) {
			return new ServiceResponseBO(false, "marketing_type_invalid");
		}
		String apiName = MarketingConstants.API_MARKETING + taskId + "/stitcher";
		String apiMethod = MarketingConstants.POST;
		String status = MarketingConstants.TASK_STATUS_PENDING;

		StitcherUpdateParamBO updateParam = new StitcherUpdateParamBO();
		updateParam.setApiMethod(apiMethod);
		updateParam.setApiName(apiName);
		updateParam.setMajorType(majorType);
		updateParam.setStatus(status);
		updateParam.setTaskId(taskId);
		updateParam.setUserId(userId);
		this.updateTaskStatusByStitcher(updateParam);

		param.setNeed_stitch(needStitch);
		param.setMajor_type(majorType);
		param.setTask_id(taskId);
		CommonAjaxResponse result = MarketingAPI.stitcher(param);

		if (!result.getSuccess()) {
			return new ServiceResponseBO(false, "marketing_call_service_failure");
		} else {
			ObjectNode fResults = this.updateApiCalling(updateParam);
			if (fResults != null) {
				return new ServiceResponseBO(fResults);
			} else {
				return new ServiceResponseBO(false, "marketing_stitch_failure");
			}
		}
	}

	@Transactional
	public ServiceResponseBO taskIdentify(String taskId, String userId) {
		TaskVO taskVO = taskMapper.getTaskById(taskId);
		if (taskVO != null && taskVO.getStitchImagePath() != null
				&& (taskVO.getTaskStatus().equals(MarketingConstants.TASK_STATUS_STITCH_SUCCESS)
						|| taskVO.getTaskStatus().equals(MarketingConstants.TASK_STATUS_STITCH_FAILURE))) {
			CommonAjaxResponse result = null;
			Boolean isMock = false;

			// *************mock begin*************
			String USE_IDENTIFY_MOCK = ConfigUtils.getInstance().getConfigValue("use.identify.mock");
			String[] mock_major_type = ConfigUtils.getInstance().getConfigValue("identify.mock.type").split(":");
			List<String> tempList = Arrays.asList(mock_major_type);
			if (USE_IDENTIFY_MOCK.equals("true") && tempList.contains(taskVO.getMajorType())) {
				String origin_file = getOriginFile(taskVO.getId());
				if (origin_file != null) {
					// String[] fileNameInfo =
					// getFileNameByStitcherImage(origin_file);
					logger.info("origin_file: " + origin_file);
					String[] fileNameInfo = getFileNameMD5(origin_file);
					if (fileNameInfo != null) {
						String fileName = fileNameInfo[0];
						String score = fileNameInfo[1];
						logger.info("score: " + score);
						String data = getResultByFileName(fileName, Double.parseDouble(score));
						if (!StringUtils.isBlank(data)) {
							logger.info("use mock with file: " + fileNameInfo[0]);
							ObjectNode node = JsonUtil.toObjectNode(data);
							result = CommonAjaxResponse.toSuccess(node);
							isMock = true;
						}
					}
				}
			}
			// *************mock end*************

			if (!isMock) {
				logger.info("call service");
				MarketingIdentifyRequestParam param = new MarketingIdentifyRequestParam();
				param.setMajor_type(taskVO.getMajorType());
				param.setTask_id(taskId);
				result = MarketingAPI.identify(param);
			}

			String apiName = MarketingConstants.API_MARKETING + taskId + "/identify";
			String apiMethod = MarketingConstants.POST;
			String status = MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS;
			if (!result.getSuccess()) {
				status = MarketingConstants.TASK_STATUS_IDENTIFY_FAILURE;

			}
			IdentifyUpdateParamBO updateParam = new IdentifyUpdateParamBO();
			updateParam.setApiMethod(apiMethod);
			updateParam.setApiName(apiName);
			updateParam.setMajorType(taskVO.getMajorType());
			updateParam.setStatus(status);
			updateParam.setTaskId(taskId);
			updateParam.setUserId(userId);
			updateParam.setResultStr(result.getData() != null ? result.getData().toString() : "");
			ObjectNode fResults = this.updateTaskStatusByIdentify(updateParam);
			if (fResults != null) {
				return new ServiceResponseBO(fResults);
			} else {
				return new ServiceResponseBO(false, "marketing_identify_failure");
			}
		} else {
			return new ServiceResponseBO(false, "marketing_miss_condition");
		}
	}

	@Transactional
	public ServiceResponseBO deleteImage(String taskId, String taskImagesId) {

		if (StringUtils.isBlank(taskId) || StringUtils.isBlank(taskImagesId)) {
			return new ServiceResponseBO(false, "marketing_parameter_invalid");
		}
		TaskVO taskVO = taskMapper.getTaskById(taskId);
		if (taskVO == null) {
			return new ServiceResponseBO(false, "marketing_db_not_found");
		}
		TaskImagesVO imagesVO = taskImagesMapper.getTaskImagesById(taskImagesId);
		int result = 0;
		if (imagesVO != null) {
			imagesVO.setStatus(MarketingConstants.STATUS_DELETED);
			int updateResult = taskImagesMapper.updateTaskImage(imagesVO);
			if (updateResult > 0) {
				File file = new File(imagesVO.getFullPath());
				if (file.exists()) {
					file.delete();
				}
				result = taskMapper.updateTaskStatus(taskId, MarketingConstants.TASK_STATUS_IMAGE_UPLOADED);
			}
		} else {
			return new ServiceResponseBO(false, "marketing_db_not_found");
		}
		if (result > 0) {
			ObjectMapper mapper = new ObjectMapper();
			ObjectNode node = mapper.createObjectNode();
			node.put("resourceId", taskImagesId);
			return new ServiceResponseBO(node);
		} else {
			return new ServiceResponseBO(false, "marketing_image_delete_failure");
		}
	}

	public ServiceResponseBO replace(String taskId, String taskImageId, MultipartFile image, int appId) {

		if (StringUtils.isBlank(taskId) || StringUtils.isBlank(taskImageId) || image == null) {
			return new ServiceResponseBO(false, "marketing_parameter_invalid");
		}
		int result = 0;
		TaskVO taskVO = taskMapper.getTaskById(taskId);
		if (taskVO == null) {
			return new ServiceResponseBO(false, "marketing_db_not_found");
		}
		TaskImagesVO tempImagesVO = taskImagesMapper.getTaskImagesById(taskImageId);
		if (tempImagesVO == null) {
			return new ServiceResponseBO(false, "marketing_db_not_found");
		}
		UploadFile file = MarketingStorageUtils.getUploadFile(image, taskVO.getId(),
				ConfigUtils.getInstance().getConfigValue("marketing.image.sub.dir"), false);
		TaskImagesVO imagesVO = new TaskImagesVO();
		int index = file.getPath().indexOf(MarketingConstants.MARKETING);
		String imagePath = file.getPath().substring(index + MarketingConstants.MARKETING.length());
		imagesVO.setImagePath(imagePath);
		imagesVO.setFullPath(file.getPath());
		imagesVO.setName(file.getName());
		imagesVO.setId(taskImageId);
		taskImagesMapper.updateTaskImage(imagesVO);

		result = taskMapper.updateTaskStatus(taskId, MarketingConstants.TASK_STATUS_IMAGE_UPLOADED);
		if (result > 0) {
			ObjectMapper mapper = new ObjectMapper();
			ObjectNode node = mapper.createObjectNode();
			node.put("resourceId", taskImageId);
			return new ServiceResponseBO(node);
		} else {
			return new ServiceResponseBO(false, "marketing_image_delete_failure");
		}
	}

	@Transactional
	public ServiceResponseBO taskOrder(List<OrderBO> imagesVOs, String taskId) {

		if (imagesVOs != null && imagesVOs.size() > 0) {
			Collections.sort(imagesVOs, new Comparator<OrderBO>() {
				@Override
				public int compare(OrderBO o1, OrderBO o2) {
					int one = o1.getResourceOrder();
					int two = o2.getResourceOrder();
					return one - two;
				}
			});
			for (int i = 0; i < imagesVOs.size(); i++) {
				OrderBO imagesVO = imagesVOs.get(i);
				imagesVO.setResourceOrder(i + 1);
			}
			int updateResult = taskImagesMapper.batchUpdateTaskImages(imagesVOs);
			if (updateResult > 0) {
				taskMapper.updateTaskStatus(taskId, MarketingConstants.TASK_STATUS_IMAGE_UPLOADED);
				ObjectMapper mapper = new ObjectMapper();
				ObjectNode node = mapper.createObjectNode();
				node.put(MarketingConstants.TASK_ID, taskId);
				return new ServiceResponseBO(node);
			} else {
				return new ServiceResponseBO(false, "marketing_parameter_invalid");
			}
		} else {
			return new ServiceResponseBO(false, "marketing_parameter_invalid");
		}
	}

	public String getBorderImagePath(TaskVO taskVO) {
		ObjectMapper mapper = new ObjectMapper();
		if (taskVO.getResult() != null) {
			String resultStr = (String) taskVO.getResult();
			try {
				ObjectNode nodeResult = (ObjectNode) mapper.readTree(resultStr);
				if (nodeResult.get("results_border") != null) {
					return nodeResult.get("results_border").asText();
				} else {
					return "";
				}
			} catch (Exception e) {
				logger.info("parse json fail, " + e);
			}
		}
		return "";
	}

	public List<GoodsBO> getResultList(TaskVO taskVO) {
		ObjectMapper mapper = new ObjectMapper();
		List<GoodsBO> goodsResult = new ArrayList<GoodsBO>();
		if (taskVO.getResult() != null) {
			String resultStr = (String) taskVO.getResult();
			try {
				ObjectNode nodeResult = (ObjectNode) mapper.readTree(resultStr);
				List<GoodsSkuVO> goodArr = getGoods(taskVO.getMajorType());
				if (nodeResult != null) {
					ArrayNode jsonNodes = (ArrayNode) nodeResult.findValue("goodResults");
					if (jsonNodes != null && jsonNodes.size() > 0) {
						for (int i = 0; i < jsonNodes.size(); i++) {
							ObjectNode oNode = (ObjectNode) jsonNodes.get(i);
							BigDecimal b = new BigDecimal(Float.parseFloat(oNode.get("ratio").toString()) * 100);
							double f1 = b.setScale(1, BigDecimal.ROUND_HALF_UP).doubleValue();
							GoodsSkuVO goodsSkuVO = goodArr.get(i);

							GoodsBO goods = new GoodsBO();
							goods.setGoods_name(goodsSkuVO.getName());
							goods.setGoods_desc(goodsSkuVO.getDescription());
							goods.setNum(oNode.get("num").toString());
							goods.setRatio(f1 + "%");
							goods.setIsShow(goodsSkuVO.getIsShow());
							ArrayNode jsonNodesCrops = (ArrayNode) nodeResult.findValue("crops");
							if (jsonNodesCrops != null && jsonNodesCrops.size() > 0) {
								int totalOriArea = 0;
								for (int j = 0; j < jsonNodesCrops.size(); j++) {
									ObjectNode oNodeCrops = (ObjectNode) jsonNodesCrops.get(j);
									if (oNodeCrops != null && oNodeCrops.get("produce") != null
											&& oNodeCrops.get("produce").asInt() == (i + 1)
											&& oNodeCrops.get("ori_area") != null) {
										totalOriArea += oNodeCrops.get("ori_area").asInt();
									}
								}
								goods.setOri_area(String.valueOf(totalOriArea));
							}
							if (oNode.get("list_rows") != null) {
								String rows = oNode.get("list_rows").toString();
								goods.setRows(rows.substring(1, rows.length() - 1));
							}
							goodsResult.add(goods);
						}
					}
				}
			} catch (IOException e) {
				logger.info("获取任务返回goodResults结果失败");
			}
		}
		return goodsResult;
	}

	public void batchUpdateTaskImages(List<TaskImagesVO> imagesVOs) {
		taskImagesMapper.batchInsertTaskImages(imagesVOs);
	}

	public TaskVO getTaskByNameAndUserId(String taskName, String userId) {
		return taskMapper.getTaskByNameAndUserId(taskName, userId);
	}

	public List<TaskVO> getTaskList(TaskBO taskBO) {
		return taskMapper.getTaskList(taskBO);
	}

	public int getTaskCount(TaskBO taskBO) {
		return taskMapper.getTaskCount(taskBO);
	}

	public TaskVO getTaskById(String taskId) {
		return taskMapper.getTaskById(taskId);
	}

	public int getTaskImagesCountByTaskId(String taskId) {
		return taskImagesMapper.getTaskImagesCountByTaskId(taskId);
	}

	public List<TaskImagesVO> getTaskImagesListByTaskId(String taskId) {
		return taskImagesMapper.getTaskImagesListByTaskId(taskId);
	}

	public TaskImagesVO getTaskImagesById(String taskImageId) {
		return taskImagesMapper.getTaskImagesById(taskImageId);
	}

	public int updateTaskImage(TaskImagesVO imagesVO) {
		return taskImagesMapper.updateTaskImage(imagesVO);
	}

	public List<ApiCallingSummaryVO> getApiCallingSummaryList(ApiCallingSummaryBO apiCallingSummaryBO) {
		return apiCallingSummaryMapper.getApiCallingSummaryList(apiCallingSummaryBO);
	}

	public int getApiCallingSummary(ApiCallingSummaryBO apiCallingSummaryBO) {
		return apiCallingSummaryMapper.getApiCallingSummary(apiCallingSummaryBO);
	}

	public int getApiCallingSum(ApiCallingSummaryBO apiCallingSummaryBO) {
		return apiCallingSummaryMapper.getApiCallingSum(apiCallingSummaryBO);
	}

	public List<MajorTypeVO> getMajorTypeVOList(String username) {
		return majorTypeMapper.getMajorTypeList(username);
	}

	public List<CropBO> getTaskImageCrops(String taskId, Integer imageOrderNo) {
		List<CropBO> cropBOs = new ArrayList<CropBO>();
		TaskVO taskVO = taskMapper.getTaskById(taskId);
		if (taskVO != null) {
			String result = (String) taskVO.getResult();
			if (StringUtils.isNotBlank(result)) {
				ObjectMapper mapper = new ObjectMapper();
				ObjectNode nodeResult;
				try {
					nodeResult = (ObjectNode) mapper.readTree(result);
					ArrayNode jsonNodes = (ArrayNode) nodeResult.findValue("goodInfo");
					if (jsonNodes != null && jsonNodes.size() > 0) {
						JsonNode tempNode = jsonNodes.get(imageOrderNo - 1);
						if (tempNode != null && tempNode.get("rect") != null) {
							ArrayNode tempArrayNode = (ArrayNode) tempNode.get("rect");
							for (int i = 0; i < tempArrayNode.size(); i++) {
								ObjectNode oNode = (ObjectNode) tempArrayNode.get(i);
								CropBO cropBO = new CropBO();
								cropBO.setId(i + 1);
								cropBO.setX(oNode.get("x").asInt());
								cropBO.setY(oNode.get("y").asInt());
								cropBO.setHeight(oNode.get("height").asInt());
								cropBO.setWidth(oNode.get("width").asInt());
								cropBO.setLabel(oNode.get("label").asInt());
								cropBOs.add(cropBO);
							}
						}
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

		return cropBOs;
	}

	public List<CropBO> getTaskIdentifyCrops(String taskId, Integer produceId) {
		List<CropBO> cropBOs = new ArrayList<CropBO>();
		TaskVO taskVO = taskMapper.getTaskById(taskId);
		if (taskVO != null) {
			String result = (String) taskVO.getResult();
			if (StringUtils.isNotBlank(result)) {
				ObjectMapper mapper = new ObjectMapper();
				ObjectNode nodeResult;
				try {
					nodeResult = (ObjectNode) mapper.readTree(result);
					ArrayNode jsonNodes = (ArrayNode) nodeResult.findValue("crops");
					if (jsonNodes != null && jsonNodes.size() > 0) {
						for (int i = 0; i < jsonNodes.size(); i++) {
							CropBO cropBO = new CropBO();
							ObjectNode oNode = (ObjectNode) jsonNodes.get(i);
							if (oNode.get("produce") != null && oNode.get("produce").asInt() == produceId) {
								cropBO.setX(oNode.get("x").asInt());
								cropBO.setY(oNode.get("y").asInt());
								cropBO.setHeight(oNode.get("height").asInt());
								cropBO.setWidth(oNode.get("width").asInt());
								cropBOs.add(cropBO);
							}
						}
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

		return cropBOs;
	}

	public TaskImagesVO getPreOrderTaskImage(String taskId, int order) {
		return taskImagesMapper.getPreOrderTaskImage(taskId, order);
	}

	public TaskImagesVO getNextOrderTaskImage(String taskId, int order) {
		return taskImagesMapper.getNextOrderTaskImage(taskId, order);
	}

	private int updateTaskStatusByStitcher(StitcherUpdateParamBO updateParam) {
		TaskVO taskVO = new TaskVO();
		taskVO.setId(updateParam.getTaskId());
		taskVO.setTaskStatus(updateParam.getStatus());
		taskVO.setMajorType(updateParam.getMajorType());
		int result = taskMapper.updateTask(taskVO);
		return result;
	}

	private ObjectNode updateTaskStatusByIdentify(IdentifyUpdateParamBO updateParam) {
		TaskVO taskVO = new TaskVO();
		taskVO.setId(updateParam.getTaskId());
		taskVO.setTaskStatus(updateParam.getStatus());
		taskVO.setResult(updateParam.getResultStr());
		int result = taskMapper.updateTask(taskVO);

		ObjectMapper mapper = new ObjectMapper();
		ObjectNode node = mapper.createObjectNode();

		if (result > 0) {
			TaskVO tempTaskVO = taskMapper.getTaskById(updateParam.getTaskId());
			if (tempTaskVO != null) {
				node = getObjectNode(node, updateParam.getResultStr(), tempTaskVO);
			}
			StitcherUpdateParamBO stitcherUpdateParam = new StitcherUpdateParamBO();
			stitcherUpdateParam.setApiMethod(updateParam.getApiMethod());
			stitcherUpdateParam.setApiName(updateParam.getApiName());
			stitcherUpdateParam.setMajorType(updateParam.getMajorType());
			stitcherUpdateParam.setStatus(updateParam.getStatus());
			stitcherUpdateParam.setTaskId(updateParam.getTaskId());
			stitcherUpdateParam.setUserId(updateParam.getUserId());
			this.updateApiCalling(stitcherUpdateParam);
		}

		return node;
	}

	private ObjectNode updateApiCalling(StitcherUpdateParamBO updateParam) {
		int taskImagesCount = taskImagesMapper.getTaskImagesCountByTaskId(updateParam.getTaskId());
		UserVO userVO = userMapper.getUserByID(updateParam.getUserId());
		String userName = "";
		if (userVO != null) {
			userName = userVO.getUserName();
		}
		String callingStatus = "Failure";
		if (taskImagesCount > 0) {
			callingStatus = "Success";
		}
		int callingTimes = taskImagesCount / MarketingConstants.FIVE_IMAGES;
		int mod = taskImagesCount % MarketingConstants.FIVE_IMAGES; // one step
																	// per five
																	// images
		if (mod > 0) {
			callingTimes += 1;
		}
		callingTimes *= 2; // stitch and identify
		ApiCallingSummaryVO apiCallingSummaryVO = new ApiCallingSummaryVO();
		apiCallingSummaryVO.setApiMethod(updateParam.getApiMethod());
		String newApiName = "";
		if (StringUtils.isNotBlank(updateParam.getApiName())) {
			String apiName = updateParam.getApiName();
			int index = apiName.lastIndexOf('/');
			newApiName = apiName.substring(index + 1);
			apiCallingSummaryVO.setApiName(newApiName);
		}

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String Datestr = sdf.format(date);
		apiCallingSummaryVO.setCallingDay(Datestr);
		apiCallingSummaryVO.setUserName(userName);

		List<ApiCallingSummaryVO> tempApiCallingSummaryVO = apiCallingSummaryMapper
				.getApiCallingSummaryListByVO(apiCallingSummaryVO);
		if (tempApiCallingSummaryVO != null && tempApiCallingSummaryVO.size() > 0) {
			apiCallingSummaryVO.setId(tempApiCallingSummaryVO.get(0).getId());
			apiCallingSummaryVO.setCallingTimes(callingTimes + tempApiCallingSummaryVO.get(0).getCallingTimes());
			apiCallingSummaryMapper.updateApiCallingSummary(apiCallingSummaryVO);
		} else {
			apiCallingSummaryVO.setCallingTimes(callingTimes);
			apiCallingSummaryVO.setUserName(userName);
			apiCallingSummaryMapper.insertApiCallingSummary(apiCallingSummaryVO);
		}

		ApiCallingDetailVO apiCallingDetailVO = new ApiCallingDetailVO();
		apiCallingDetailVO.setApiMethod(updateParam.getApiMethod());
		apiCallingDetailVO.setApiName(updateParam.getApiName());
		apiCallingDetailVO.setCallingStatus(callingStatus);
		apiCallingDetailVO.setPictures((int) taskImagesCount);
		apiCallingDetailVO.setUserName(userName);
		apiCallingDetailMapper.insertApiCallingDetail(apiCallingDetailVO);
		ObjectMapper mapper = new ObjectMapper();
		ObjectNode node = mapper.createObjectNode();
		node.put(MarketingConstants.TASK_ID, updateParam.getTaskId());
		return node;
	}

	public List<GoodsSkuVO> getGoods(String majorType) {
		return goodsSkuMapper.getGoodsSkuListByMajorType(majorType);

	}

	@Transactional
	public void saveGoodsInfo(String taskId) {
		TaskVO taskVO = taskMapper.getTaskById(taskId);
		if (taskVO != null) {
			String result = (String) taskVO.getResult();
			String goodInfo = taskVO.getGoodsInfo();
			if (StringUtils.isNotBlank(result) && StringUtils.isBlank(goodInfo)) {
				ObjectMapper mapper = new ObjectMapper();
				ObjectNode nodeResult;
				try {
					nodeResult = (ObjectNode) mapper.readTree(result);
					if (nodeResult.findValue("goodInfo") != null) {
						ArrayNode jsonNodes = (ArrayNode) nodeResult.findValue("goodInfo");
						taskVO.setGoodsInfo(jsonNodes.toString());
						taskMapper.updateTask(taskVO);
					}

				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}

	}

	public CommonAjaxResponse rectify(String taskId) {
		TaskVO taskVO = taskMapper.getTaskById(taskId);
		MarketingRectifyRequestParam param = new MarketingRectifyRequestParam();
		param.setTaskId(taskId);
		param.setMajorType(taskVO.getMajorType());
		CommonAjaxResponse result = MarketingAPI.rectify(param);
		return result;
	}

	public CommonAjaxResponse pullData(String taskId) {
		MarketingPullDataRequestParam param = new MarketingPullDataRequestParam();
		param.setTaskId(taskId);
		CommonAjaxResponse result = MarketingAPI.pullData(param);
		return result;
	}

	public List<String> getTaskExportData(String majorType, String startTime, String endTime, String userId) {
		List<String> result = new ArrayList<String>();
		TaskVO taskVO = new TaskVO();
		taskVO.setTaskStatus(MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS);
		taskVO.setMajorType(majorType);
		taskVO.setUserId(userId);
		if (StringUtils.isNotBlank(startTime)) {
			taskVO.setStartTime(startTime);
		}
		if (StringUtils.isNotBlank(endTime)) {
			taskVO.setEndTime(endTime);
		}
		List<TaskVO> tasks = taskMapper.getTaskListByVO(taskVO);
		if (tasks != null && tasks.size() > 0) {
			String goodSkuHead = getGoodSkuHead(majorType);
			result.add(goodSkuHead);
			for (TaskVO tempTask : tasks) {
				String resultStr = (String) tempTask.getResult();
				if (StringUtils.isNotBlank(resultStr)) {
					StringBuffer taskBodyBuffer = new StringBuffer();
					String rows = tempTask.getRows();
					String newRows = "";
					if (StringUtils.isNotBlank(rows) && StringUtils.equals(String.valueOf(MarketingConstants.COMMA),
							rows.substring(rows.length() - 1))) {
						newRows = rows.substring(0, rows.length() - 1);
					} else {
						newRows = rows;
					}
					newRows = newRows.replaceAll(",", "，");
					taskBodyBuffer.append(tempTask.getId()).append(",").append(tempTask.getName())
							.append(getGoodSkuStr(resultStr, newRows));
					result.add(taskBodyBuffer.toString());
				}
			}
		}
		return result;
	}

	@SuppressWarnings("deprecation")
	public ObjectNode getTaskResult(String taskId) {
		TaskVO taskVO = this.getTaskById(taskId);
		ObjectMapper tempMapper = new ObjectMapper();
		ObjectNode node = tempMapper.createObjectNode();
		ArrayNode jsonNodes = tempMapper.createArrayNode();

		if (taskVO != null) {
			if (StringUtils.endsWith(MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS, taskVO.getTaskStatus())
					&& StringUtils.isNotBlank(taskVO.getRows())) {
				String rowsStr = taskVO.getRows();
				if (rowsStr.charAt(rowsStr.length() - 1) == MarketingConstants.COMMA) {
					node.put("rows", rowsStr.substring(0, rowsStr.length() - 1));
				} else {
					node.put("rows", rowsStr);
				}
			}
			if (StringUtils.endsWith(MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS, taskVO.getTaskStatus())
					&& taskVO.getResult() != null) {
				node.put("goodResults", jsonNodes.addPOJO(this.getResultList(taskVO)).get(0));

				String resultStr = (String) taskVO.getResult();
				if (StringUtils.isNotBlank(resultStr)) {
					ObjectMapper mapper = new ObjectMapper();
					ObjectNode nodeResult = null;
					try {
						nodeResult = (ObjectNode) mapper.readTree(resultStr);
						JsonNode jsonNode = nodeResult.findValue("total_area");
						node.put("resultsBorder", nodeResult.findValue("results_border"));
						if (jsonNode != null) {
							node.put("totalArea", jsonNode.asText());
						}
					} catch (IOException e) {
						e.printStackTrace();
					}
					node.put("crops", (ArrayNode) nodeResult.findValue("crops"));
				}
			}
		}
		return node;
	}

	@SuppressWarnings("deprecation")
	public void saveTaskImageCrop(String taskId, Integer imageOrder, ArrayNode goodsInfoArray) {
		TaskVO taskVO = taskMapper.getTaskById(taskId);
		if (taskVO != null) {
			String result = (String) taskVO.getResult();
			if (StringUtils.isNotBlank(result)) {
				ObjectMapper mapper = new ObjectMapper();
				ObjectNode nodeResult;
				try {
					nodeResult = (ObjectNode) mapper.readTree(result);
					ArrayNode jsonNodes = (ArrayNode) nodeResult.findValue("goodInfo");
					if (jsonNodes != null && jsonNodes.size() > 0) {
						ObjectNode objectNode = (ObjectNode) jsonNodes.get(imageOrder - 1);
						objectNode.put("rect", goodsInfoArray);
						// jsonNodes.removeAll();
						// jsonNodes.addAll(cropResult);
						// nodeResult.put("goodInfo", jsonNodes);
						taskVO.setResult(nodeResult.toString());
					}
					taskMapper.updateTask(taskVO);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

	public void generateFile(ImageCropBO cropBO) {
		// String filenameTemp = "D:\\" + cropBO.getImageId() + ".txt";
		String filenameTempDir = File.separator + "mnt" + File.separator + cropBO.getMajorType();
		String filenameTemp = File.separator + "mnt" + File.separator + cropBO.getMajorType() + File.separator
				+ cropBO.getImageId() + ".txt";
		File file = new File(filenameTemp);
		File fileDir = new File(filenameTempDir);
		file.setWritable(true, false);
		fileDir.setWritable(true, false);
		TaskImagesVO imagesVO = taskImagesMapper.getTaskImagesById(cropBO.getImageId());
		if (imagesVO != null && imagesVO.getFullPath() != null) {
			/*
			 * try { int bytesum = 0; int byteread = 0; File oldfile = new
			 * File(imagesVO.getFullPath()); if (oldfile.exists()) { // 文件存在时
			 * InputStream inStream = new
			 * FileInputStream(imagesVO.getFullPath()); // 读入原文件
			 * FileOutputStream fs = new FileOutputStream("/mnt/" +
			 * cropBO.getMajorType()+"/" + cropBO.getImageId() + ".jpeg");
			 * byte[] buffer = new byte[1444]; int length; while ((byteread =
			 * inStream.read(buffer)) != -1) { bytesum += byteread; // 字节数 文件大小
			 * System.out.println(bytesum); fs.write(buffer, 0, byteread); }
			 * inStream.close(); } } catch (Exception e) { e.printStackTrace();
			 * }
			 */
		}
		try {
			if (!fileDir.isDirectory()) {
				file.mkdir	();
			}
			if (!file.exists()) {
				file.createNewFile();
				writeFileContent(filenameTemp, cropBO);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@SuppressWarnings("unused")
	private boolean writeFileContent(String filepath, ImageCropBO cropBO) throws IOException {
		Boolean bool = false;
		String temp = "";

		FileInputStream fis = null;
		InputStreamReader isr = null;
		BufferedReader br = null;
		FileOutputStream fos = null;
		PrintWriter pw = null;
		try {
			File file = new File(filepath);

			fis = new FileInputStream(file);
			isr = new InputStreamReader(fis);
			br = new BufferedReader(isr);

			fos = new FileOutputStream(file);
			pw = new PrintWriter(fos, true);
			StringBuffer buffer = new StringBuffer();
			if (cropBO != null && cropBO.getImageCrop() != null && cropBO.getImageCrop().size() > 0) {
				ArrayNode arrayNode = cropBO.getImageCrop();
				for (int j = 0; j < arrayNode.size(); j++) {
					ObjectNode nodeResult = (ObjectNode) arrayNode.get(j);
					String labelName = "Others";
					GoodsSkuBO goodsSkuBO = new GoodsSkuBO();
					goodsSkuBO.setOrder(nodeResult.get("label").asInt() - 1);
					goodsSkuBO.setMajorType(cropBO.getMajorType());
					List<GoodsSkuVO> goodsSkuVOs = goodsSkuMapper.getGoodsSkuListByBO(goodsSkuBO);
					if (goodsSkuVOs != null && goodsSkuVOs.size() > 0) {
						labelName = goodsSkuVOs.get(0).getName();
					}
					String fileIn = nodeResult.get("x") + "," + nodeResult.get("y") + "," + nodeResult.get("width")
							+ "," + nodeResult.get("height") + "," + labelName;
					pw.write(fileIn);
					pw.write("\r\n");
				}
			}
			pw.flush();
			bool = true;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pw != null) {
				pw.close();
			}
			if (fos != null) {
				fos.close();
			}
			if (br != null) {
				br.close();
			}
			if (isr != null) {
				isr.close();
			}
			if (fis != null) {
				fis.close();
			}
		}
		return bool;
	}

	private int addImages(String taskId, String userId, List<MultipartFile> images) {
		int result = 0;
		if (images != null && images.size() > 0) {
			List<TaskImagesVO> taskImagesVOs = new ArrayList<TaskImagesVO>();
			List<TaskImagesVO> imagesVOs = taskImagesMapper.getTaskImagesListByTaskId(taskId);
			int orderNo = 0;
			if (imagesVOs != null && imagesVOs.size() > 0) {
				orderNo = imagesVOs.get(imagesVOs.size() - 1).getOrderNo();
			}
			for (int i = 0; i < images.size(); i++) {
				TaskImagesVO taskImagesVO = new TaskImagesVO();
				UploadFile file = MarketingStorageUtils.getUploadFile(images.get(i), taskId,
						ConfigUtils.getInstance().getConfigValue("marketing.image.sub.dir"), false);
				if (file == null) {
					logger.error("Save form-data file failure");
					return -1;
				}
				taskImagesVO.setId((Long.toHexString(new Date().getTime()) + RandomStringUtils.randomAlphanumeric(13))
						.toLowerCase());
				taskImagesVO.setName(file.getName());
				taskImagesVO.setUserId(userId);
				taskImagesVO.setTaskId(taskId);
				int index = file.getPath().indexOf(MarketingConstants.MARKETING);
				String imagePath = file.getPath().substring(index + MarketingConstants.MARKETING.length());
				taskImagesVO.setImagePath(imagePath);
				taskImagesVO.setFullPath(file.getPath());
				taskImagesVO.setOrderNo(i + orderNo + 1);
				taskImagesVOs.add(taskImagesVO);
			}
			taskImagesMapper.batchInsertTaskImages(taskImagesVOs);
			result = taskMapper.updateTaskStatus(taskId, MarketingConstants.TASK_STATUS_IMAGE_UPLOADED);
		}
		return result;
	}

	@SuppressWarnings("deprecation")
	private ObjectNode getObjectNode(ObjectNode node, String resultStr, TaskVO tempTaskVO) {
		ObjectMapper mapper = new ObjectMapper();
		if (StringUtils.isNotBlank(resultStr)) {
			try {
				ObjectNode nodeResult = (ObjectNode) mapper.readTree(resultStr);
				if (nodeResult != null) {
					ArrayNode jsonNodes = (ArrayNode) nodeResult.findValue("goodResults");
					if (jsonNodes != null && jsonNodes.size() > 0) {

						node.put("data", getArrayNode(jsonNodes, tempTaskVO.getMajorType()));
						String rowsStr = tempTaskVO.getRows();
						if (rowsStr.charAt(rowsStr.length() - 1) == MarketingConstants.COMMA) {
							node.put("rows", rowsStr.substring(0, rowsStr.length() - 1));
						} else {
							node.put("rows", rowsStr);
						}
					}
					node.put("crops", (ArrayNode) nodeResult.findValue("crops"));
					node.put("rows_length", (ArrayNode) nodeResult.findValue("Rowslength"));
					node.put("results_border", nodeResult.get("results_border").asText());
					node.put("total_area", nodeResult.get("total_area").asLong());
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		} else {
			node = null;
		}
		return node;
	}

	@SuppressWarnings("deprecation")
	private ObjectNode getObjectNode(TaskVO tempTaskVO) {
		ObjectMapper mapper = new ObjectMapper();
		ObjectNode node = mapper.createObjectNode();
		node.put("task_status", tempTaskVO.getTaskStatus());
		node.put("success", true);
		String resultStr = (String) tempTaskVO.getResult();
		if (StringUtils.isNotBlank(resultStr)) {
			try {
				JsonNode nodeResult = mapper.readTree(resultStr);
				if (nodeResult != null) {
					ArrayNode jsonNodes = (ArrayNode) nodeResult.findValue("goodResults");
					if (jsonNodes != null && jsonNodes.size() > 0) {
						node.put("result", getArrayNode(jsonNodes, tempTaskVO.getMajorType()));
						String rowsStr = tempTaskVO.getRows();
						if (rowsStr.charAt(rowsStr.length() - 1) == MarketingConstants.COMMA) {
							node.put("rows", rowsStr.substring(0, rowsStr.length() - 1));
						} else {
							node.put("rows", rowsStr);
						}
					}
					node.put("crops", (ArrayNode) nodeResult.findValue("crops"));
					node.put("rows_length", (ArrayNode) nodeResult.findValue("Rowslength"));
					node.put("total_area", nodeResult.findValue("total_area"));
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return node;
	}

	@SuppressWarnings("deprecation")
	private ArrayNode getArrayNode(ArrayNode jsonNodes, String majorType) {

		ObjectMapper mapperResult = JsonUtil.objectMapper;
		ArrayNode jsonNodesResult = mapperResult.createArrayNode();
		List<GoodsSkuVO> goodArr = getGoods(majorType);

		for (int i = 0; i < jsonNodes.size(); i++) {
			ObjectNode oNode = (ObjectNode) jsonNodes.get(i);
			BigDecimal b = new BigDecimal(Float.parseFloat(oNode.get("ratio").toString()) * 100);
			double f1 = b.setScale(1, BigDecimal.ROUND_HALF_UP).doubleValue();

			ObjectMapper tempMapper = new ObjectMapper();
			ObjectNode tempNode = tempMapper.createObjectNode();
			GoodsSkuVO goodsSkuVO = goodArr.get(i);

			tempNode.put("goods_name", goodsSkuVO.getName());
			tempNode.put("goods_desc", goodsSkuVO.getDescription());
			tempNode.put("ratio", f1 + "%");
			tempNode.put("num", oNode.get("num").toString());
			tempNode.put("isShow", goodsSkuVO.getIsShow());
			tempNode.put("list_rows", oNode.get("list_rows"));
			tempNode.put("produce", i + 1);
			jsonNodesResult.add(tempNode);
		}
		return jsonNodesResult;
	}

	private List<String> getImageTypeList() {
		List<String> imageTypeList = new ArrayList<String>();
		imageTypeList.add("png");
		imageTypeList.add("jpeg");
		imageTypeList.add("bmp");
		imageTypeList.add("jpg");
		return imageTypeList;
	}

	private List<String> getMajorTypeList(String username) {
		List<String> majorTypeList = new ArrayList<String>();
		List<MajorTypeVO> list = majorTypeMapper.getMajorTypeList(username);
		if (list != null && list.size() > 0) {
			for (MajorTypeVO majorTypeVO : list) {
				majorTypeList.add(majorTypeVO.getName());
			}
		}
		return majorTypeList;
	}

	/*
	 * the follow section is a mock for testing. will be remove in feature
	 */
	@SuppressWarnings("unused")
	private String[] getFileNameByStitcherImage(String stitcherImagePath) {
		MarketingIdentifyMockRequestParam param = new MarketingIdentifyMockRequestParam();
		param.setImagePath(stitcherImagePath);
		CommonAjaxResponse result = MarketingAPI.identifyMock(param);
		if (result.getSuccess()) {
			ObjectNode node = (ObjectNode) result.getData();
			String filePath = node.findValue("imagePath").asText();
			String score = node.findValue("score").asText();
			int idx = filePath.lastIndexOf("/");
			return new String[] { filePath.substring(idx + 1), score };
		} else {
			return null;
		}
	}

	private String[] getFileNameMD5(String stitcherImagePath) {
		FileInputStream fis;
		String md5String = "";
		try {
			fis = new FileInputStream(stitcherImagePath);
			md5String = DigestUtils.md5Hex(IOUtils.toByteArray(fis));
			IOUtils.closeQuietly(fis);
			logger.info("---MD5---" + md5String);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return new String[] { md5String, "10000" };
	}

	private String getResultByFileName(String fileName, Double score) {
		if (!StringUtils.isBlank(fileName)) {
			String data = taskDumpMapper.getResultByMD5(fileName);
			if (!StringUtils.isBlank(data)) {
				return data;
			} else {
				return null;
			}
		} else {
			return null;
		}
	}

	private String getOriginFile(String taskId) {
		List<TaskImagesVO> images = taskImagesMapper.getTaskImagesListByTaskId(taskId);
		if (images.size() != 1) {
			return null;
		} else {
			return images.get(0).getFullPath();
		}
	}

	private String getGoodSkuHead(String majorType) {
		List<GoodsSkuVO> goodArr = getGoods(majorType);

		StringBuffer ratioBuffer = new StringBuffer();
		StringBuffer numBuffer = new StringBuffer();
		StringBuffer oriAreaBuffer = new StringBuffer();
		StringBuffer rowsBuffer = new StringBuffer();
		StringBuffer result = new StringBuffer();

		for (GoodsSkuVO goodsSku : goodArr) {
			ratioBuffer.append(",").append(goodsSku.getName()).append("货架占比");
			numBuffer.append(",").append(goodsSku.getName()).append("牌面数");
			oriAreaBuffer.append(",").append(goodsSku.getName()).append("像素面积");
			rowsBuffer.append(",").append(goodsSku.getName()).append("货架位置");
		}

		return result.append("任务ID").append(",任务名").append(ratioBuffer).append(numBuffer).append(oriAreaBuffer)
				.append(rowsBuffer).append(",货架总面积").append(",货架总层数").toString();
	}

	private String getGoodSkuStr(String resultStr, String rows) {
		StringBuffer result = new StringBuffer();
		StringBuffer ratioBuffer = new StringBuffer();
		StringBuffer numBuffer = new StringBuffer();
		StringBuffer oriAreaBuffer = new StringBuffer();
		StringBuffer rowsBuffer = new StringBuffer();
		ObjectMapper mapper = new ObjectMapper();
		ObjectNode nodeResult;
		String totalArea = "";

		try {
			nodeResult = (ObjectNode) mapper.readTree(resultStr);
			if (nodeResult != null) {
				ArrayNode jsonNodes = (ArrayNode) nodeResult.findValue("goodResults");
				if (jsonNodes != null && jsonNodes.size() > 0) {
					for (int i = 0; i < jsonNodes.size(); i++) {
						ObjectNode oNode = (ObjectNode) jsonNodes.get(i);
						BigDecimal b = new BigDecimal(Float.parseFloat(oNode.get("ratio").toString()) * 100);
						double f1 = b.setScale(1, BigDecimal.ROUND_HALF_UP).doubleValue();

						ratioBuffer.append(",").append(f1 + "%");
						numBuffer.append(",").append(oNode.get("num").toString());
						JsonNode listRows = oNode.get("list_rows");
						rowsBuffer.append(",");
						if (listRows != null && listRows.size() > 0) {
							for (int k = 0; k < listRows.size(); k++) {
								String row = listRows.get(k).asText();
								rowsBuffer.append(row).append("，");
							}
						}
						ArrayNode jsonNodesCrops = (ArrayNode) nodeResult.findValue("crops");
						if (jsonNodesCrops != null && jsonNodesCrops.size() > 0) {
							int totalOriArea = 0;
							for (int j = 0; j < jsonNodesCrops.size(); j++) {
								ObjectNode oNodeCrops = (ObjectNode) jsonNodesCrops.get(j);
								if (oNodeCrops != null && oNodeCrops.get("produce") != null
										&& oNodeCrops.get("produce").asInt() == (i + 1)
										&& oNodeCrops.get("ori_area") != null) {
									totalOriArea += oNodeCrops.get("ori_area").asInt();
								}
							}
							oriAreaBuffer.append(",").append(totalOriArea);
						} else {
							oriAreaBuffer.append(",").append(0);
						}
					}
				}
				if (nodeResult.findValue("total_area") != null) {
					totalArea = nodeResult.findValue("total_area").asText();
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}

		return result.append(ratioBuffer).append(numBuffer).append(oriAreaBuffer).append(rowsBuffer).append(",")
				.append(totalArea).append(",").append(rows).toString();
	}
}
