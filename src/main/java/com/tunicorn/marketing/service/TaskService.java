package com.tunicorn.marketing.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
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

import com.fasterxml.jackson.core.JsonProcessingException;
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
import com.tunicorn.marketing.api.param.MarketingStitcherRequestParam;
import com.tunicorn.marketing.bo.ApiCallingSummaryBO;
import com.tunicorn.marketing.bo.CropBO;
import com.tunicorn.marketing.bo.GoodsBO;
import com.tunicorn.marketing.bo.IdentifyUpdateParamBO;
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
				if(file==null){
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
		} else if(result == -1){
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
				if (taskVO.getResult()!=null) {
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
				String result = (String)taskVO.getResult();
				newNode.put("image", MarketingConstants.PIC_MARKETING + taskVO.getStitchImagePath());
				newNode.put("rows", 0);
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
				if (StringUtils.isNotBlank(rows)) {
					newNode.put("rows", rows.substring(0, rows.length() - 1));
				}
			}
			return new ServiceResponseBO(newNode);
		} else {
			return new ServiceResponseBO(false, "marketing_task_not_existed");
		}
	}

	@Transactional
	public ServiceResponseBO taskStitcher(String taskId, Boolean needStitch, String majorType, String userId) {
		TaskVO taskVO = taskMapper.getTaskById(taskId);
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
		if (!this.getMajorTypeList().contains(majorType)) {
			return new ServiceResponseBO(false, "marketing_type_invalid");
		}
		param.setNeed_stitch(needStitch);
		param.setMajor_type(majorType);
		param.setTask_id(taskId);
		CommonAjaxResponse result = MarketingAPI.stitcher(param);

		String apiName = MarketingConstants.API_MARKETING + taskId + "/stitcher";
		String apiMethod = MarketingConstants.POST;
		String status = MarketingConstants.TASK_STATUS_PENDING;
		if (!result.getSuccess()) {
			return new ServiceResponseBO(false, "marketing_call_service_failure");
		}
		StitcherUpdateParamBO updateParam = new StitcherUpdateParamBO();
		updateParam.setApiMethod(apiMethod);
		updateParam.setApiName(apiName);
		updateParam.setMajorType(majorType);
		updateParam.setStatus(status);
		updateParam.setTaskId(taskId);
		updateParam.setUserId(userId);
		ObjectNode fResults = this.updateTaskStatusByStitcher(updateParam);
		if (fResults != null) {
			return new ServiceResponseBO(fResults);
		} else {
			return new ServiceResponseBO(false, "marketing_stitch_failure");
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
			
			//*************mock begin*************
			String USE_IDENTIFY_MOCK = ConfigUtils.getInstance().getConfigValue("use.identify.mock");
			String[] mock_major_type = ConfigUtils.getInstance().getConfigValue("identify.mock.type").split(":");
			List<String> tempList = Arrays.asList(mock_major_type);
			if (USE_IDENTIFY_MOCK.equals("true") && tempList.contains(taskVO.getMajorType())){
				String origin_file = getOriginFile(taskVO.getId());
				if (origin_file != null){
//					String[] fileNameInfo = getFileNameByStitcherImage(origin_file); 
					logger.info("origin_file: " + origin_file);
					String[] fileNameInfo = getFileNameMD5(origin_file);
					if(fileNameInfo != null){
						String fileName = fileNameInfo[0];
						String score = fileNameInfo[1];
						logger.info("score: " + score);
						String data = getResultByFileName(fileName, Double.parseDouble(score));
						if(!StringUtils.isBlank(data)){
							logger.info("use mock with file: " + fileNameInfo[0]);
							ObjectNode node = JsonUtil.toObjectNode(data);
							result = CommonAjaxResponse.toSuccess(node);
							isMock = true;
						}
					}
				}
			}
			//*************mock end*************
			
			if(!isMock){
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
			updateParam.setResultStr(result.getData()!=null ? result.getData().toString() : "");
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
	
	public String getBorderImagePath(TaskVO taskVO){
		ObjectMapper mapper = new ObjectMapper();
		if (taskVO.getResult()!=null) {
			String resultStr = (String)taskVO.getResult();
			try {
				ObjectNode nodeResult = (ObjectNode) mapper.readTree(resultStr);
				return nodeResult.get("results_border").asText();
			} catch (Exception e) {
				logger.info("parse json fail, " + e);
			}
		}
		return "";
	}

	public List<GoodsBO> getResultList(TaskVO taskVO) {
		ObjectMapper mapper = new ObjectMapper();
		List<GoodsBO> goodsResult = new ArrayList<GoodsBO>();
		if (taskVO.getResult()!=null) {
			String resultStr = (String)taskVO.getResult();
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
							if(jsonNodesCrops!=null && jsonNodesCrops.size()>0){
								ObjectNode oNodeCrops = (ObjectNode) jsonNodesCrops.get(i);
								if (oNodeCrops.get("ori_area") != null) {
									goods.setOri_area(oNodeCrops.get("ori_area").asText());
								}
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

	public List<MajorTypeVO> getMajorTypeVOList() {
		return majorTypeMapper.getMajorTypeList();
	}

	public List<CropBO> getTaskIdentifyCrops(String taskId, Integer produceId) {
		List<CropBO> cropBOs = new ArrayList<CropBO>();
		TaskVO taskVO = taskMapper.getTaskById(taskId);
		if (taskVO != null) {
			String result = (String)taskVO.getResult();
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

	private ObjectNode updateTaskStatusByStitcher(StitcherUpdateParamBO updateParam) {
		TaskVO taskVO = new TaskVO();
		taskVO.setId(updateParam.getTaskId());
		taskVO.setTaskStatus(updateParam.getStatus());
		taskVO.setMajorType(updateParam.getMajorType());
		int result = taskMapper.updateTask(taskVO);
		if (result > 0) {
			this.updateApiCalling(updateParam);
		}
		ObjectMapper mapper = new ObjectMapper();
		ObjectNode node = mapper.createObjectNode();
		node.put(MarketingConstants.TASK_ID, updateParam.getTaskId());
		return node;
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

	private void updateApiCalling(StitcherUpdateParamBO updateParam) {
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
		int callingTimes = 1;
		if (taskImagesCount > MarketingConstants.FIVE_IMAGES) {
			callingTimes = 2;
		}
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
	}

	public List<GoodsSkuVO> getGoods(String majorType) {
		return goodsSkuMapper.getGoodsSkuListByMajorType(majorType);

	}

	private int addImages(String taskId, String userId, List<MultipartFile> images) {
		int result = 0;
		if (images != null && images.size() > 0) {
			List<TaskImagesVO> taskImagesVOs = new ArrayList<TaskImagesVO>();
			List<TaskImagesVO> imagesVOs = taskImagesMapper.getTaskImagesListByTaskId(taskId);
			int orderNo = 1;
			if (imagesVOs != null && imagesVOs.size() > 0) {
				orderNo = imagesVOs.get(imagesVOs.size() - 1).getOrderNo();
			}
			for (int i = 0; i < images.size(); i++) {
				TaskImagesVO taskImagesVO = new TaskImagesVO();
				UploadFile file = MarketingStorageUtils.getUploadFile(images.get(i), taskId,
						ConfigUtils.getInstance().getConfigValue("marketing.image.sub.dir"), false);
				if(file==null){
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
		}else{
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
		String resultStr = (String)tempTaskVO.getResult();
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

	private List<String> getMajorTypeList() {
		List<String> majorTypeList = new ArrayList<String>();
		List<MajorTypeVO> list = majorTypeMapper.getMajorTypeList();
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
	private String[] getFileNameByStitcherImage(String stitcherImagePath){
		MarketingIdentifyMockRequestParam param = new MarketingIdentifyMockRequestParam(); 
		param.setImagePath(stitcherImagePath);
		CommonAjaxResponse result = MarketingAPI.identifyMock(param);
		if(result.getSuccess()){
			ObjectNode node = (ObjectNode) result.getData();
			String filePath = node.findValue("imagePath").asText();
			String score = node.findValue("score").asText();
			int idx = filePath.lastIndexOf("/");
			return new String[]{filePath.substring(idx+1), score};
		}else{
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
		
		return new String[]{md5String, "10000"};
	}
	private String getResultByFileName(String fileName, Double score){
		if(!StringUtils.isBlank(fileName)){
			String data = taskDumpMapper.getResultByMD5(fileName);
			if(!StringUtils.isBlank(data)){
				return data;
			}else{
				return null;
			}
		}else{
			return null;
		}
	}	

	private String getOriginFile(String taskId){
		List<TaskImagesVO> images = taskImagesMapper.getTaskImagesListByTaskId(taskId);
		if(images.size() != 1){
			return null;
		}else{
			return images.get(0).getFullPath();
		}
	}
}
