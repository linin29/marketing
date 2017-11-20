package com.tunicorn.marketing.service;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import javax.imageio.ImageIO;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;
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
import com.tunicorn.marketing.api.param.MarketingGetStoreRequestParam;
import com.tunicorn.marketing.api.param.MarketingIdentifyMockRequestParam;
import com.tunicorn.marketing.api.param.MarketingIdentifyRequestParam;
import com.tunicorn.marketing.api.param.MarketingPriceIdentifyRequestParam;
import com.tunicorn.marketing.api.param.MarketingRectifyRequestParam;
import com.tunicorn.marketing.api.param.MarketingStitcherRequestParam;
import com.tunicorn.marketing.bo.AecBO;
import com.tunicorn.marketing.bo.ApiCallingSummaryBO;
import com.tunicorn.marketing.bo.CropBO;
import com.tunicorn.marketing.bo.GoodsBO;
import com.tunicorn.marketing.bo.GoodsSkuBO;
import com.tunicorn.marketing.bo.IdentifyUpdateParamBO;
import com.tunicorn.marketing.bo.ImageCropBO;
import com.tunicorn.marketing.bo.OrderBO;
import com.tunicorn.marketing.bo.PriceIdentifyBO;
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

	private final static int THREAD_UPLOAD_MAX_SIZE = 50;
	private static ExecutorService generateExecutorPool = Executors.newFixedThreadPool(20);

	private static ExecutorService aecUploadExecutorPool = Executors.newFixedThreadPool(THREAD_UPLOAD_MAX_SIZE);

	@Transactional
	public ServiceResponseBO createTask(String userId, String taskName, List<MultipartFile> images) {
		logger.info("params of createTask: taskName: " + taskName + ", userId:" + userId);
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
		TaskVO createTaskVO = new TaskVO();
		createTaskVO.setId(
				(Long.toHexString(new Date().getTime()) + RandomStringUtils.randomAlphanumeric(13)).toLowerCase());
		createTaskVO.setName(taskName);
		createTaskVO.setUserId(userId);
		createTaskVO.setTaskStatus(MarketingConstants.TASK_INIT_STATUS);
		int createResult = taskMapper.createTask(createTaskVO);
		TaskVO tempTaskVO = taskMapper.getTaskById(createTaskVO.getId());
		logger.info("create task result: " + createResult);
		if (images != null && images.size() > 0) {
			List<TaskImagesVO> taskImagesVOs = new ArrayList<TaskImagesVO>();
			for (int i = 0; i < images.size(); i++) {
				TaskImagesVO taskImagesVO = new TaskImagesVO();

				UploadFile file = MarketingStorageUtils.getUploadFile(images.get(i), userId, createTaskVO.getId(),
						tempTaskVO.getCreateTime(), ConfigUtils.getInstance().getConfigValue("marketing.image.sub.dir"),
						false);

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
			taskMapper.updateTaskStatus(createTaskVO.getId(), MarketingConstants.TASK_STATUS_IMAGE_UPLOADED, 0);
		}

		ObjectMapper mapper = new ObjectMapper();
		ObjectNode node = mapper.createObjectNode();
		node.put(MarketingConstants.TASK_ID, createTaskVO.getId());
		if (images != null && images.size() > 0) {
			node.put("length", images.size());
		}
		logger.info("result of createTask method: " + node.toString());
		return new ServiceResponseBO(node);
	}

	@Transactional
	public ServiceResponseBO createZipTask(String userId, String taskName, MultipartFile zipFile) {
		logger.info("params of createTask: taskName: " + taskName + ", userId:" + userId);
		TaskVO taskVO = taskMapper.getTaskByNameAndUserId(taskName, userId);
		if (taskVO != null) {
			return new ServiceResponseBO(false, "marketing_task_existed");
		}

		if (StringUtils.isBlank(taskName)) {
			return new ServiceResponseBO(false, "marketing_task_name_not_null");
		}
		TaskVO createTaskVO = new TaskVO();
		List<TaskImagesVO> taskImagesVOs = new ArrayList<TaskImagesVO>();
		try {
			createTaskVO.setId(
					(Long.toHexString(new Date().getTime()) + RandomStringUtils.randomAlphanumeric(13)).toLowerCase());
			createTaskVO.setName(taskName);
			createTaskVO.setUserId(userId);
			createTaskVO.setTaskStatus(MarketingConstants.TASK_INIT_STATUS);
			taskMapper.createTask(createTaskVO);

			String basePath = com.tunicorn.util.ConfigUtils.getInstance().getConfigValue("storage.private.basePath")
					+ MarketingConstants.MARKETING + File.separator + createTaskVO.getId() + File.separator
					+ ConfigUtils.getInstance().getConfigValue("marketing.image.sub.dir");

			// String basePath = "D:\\";
			ZipInputStream zin = new ZipInputStream(zipFile.getInputStream());
			ZipEntry ze;
			int i = 0;
			while ((ze = zin.getNextEntry()) != null) {
				if (!ze.isDirectory()) {
					File imageFile = new File(basePath + File.separator + ze.getName());
					if (!imageFile.exists()) {
						imageFile.createNewFile();
					}
					FileOutputStream fos = new FileOutputStream(imageFile);

					int len = 0;
					byte b[] = new byte[1024];
					while ((len = zin.read(b)) != -1) {
						fos.write(b, 0, len);
					}
					fos.close();
					TaskImagesVO taskImagesVO = new TaskImagesVO();

					taskImagesVO
							.setId((Long.toHexString(new Date().getTime()) + RandomStringUtils.randomAlphanumeric(13))
									.toLowerCase());
					int zeIndex = ze.getName().indexOf("/");
					String taskImageName = "";
					if (zeIndex > 0) {
						taskImageName = ze.getName().substring(zeIndex + 1);
					} else {
						taskImageName = ze.getName();
					}
					taskImagesVO.setName(taskImageName);
					taskImagesVO.setUserId(createTaskVO.getUserId());
					taskImagesVO.setTaskId(createTaskVO.getId());
					int index = (basePath + File.separator + ze.getName()).indexOf(MarketingConstants.MARKETING);
					String imagePath = (basePath + File.separator + ze.getName())
							.substring(index + MarketingConstants.MARKETING.length());
					taskImagesVO.setImagePath(imagePath);
					taskImagesVO.setFullPath(basePath + File.separator + ze.getName());
					taskImagesVO.setOrderNo(i + 1);
					taskImagesVOs.add(taskImagesVO);
					i++;
				} else {
					File imageFileDir = new File(basePath + File.separator + ze.getName());
					if (!imageFileDir.exists()) {
						imageFileDir.mkdirs();
					}
				}
			}
			zin.closeEntry();
		} catch (IOException e) {
			e.printStackTrace();
		}
		if (taskImagesVOs != null && taskImagesVOs.size() > MarketingConstants.IMAGE_MAX_COUNT) {
			return new ServiceResponseBO(false, "marketing_image_max_count");
		}
		ObjectMapper mapper = new ObjectMapper();
		ObjectNode node = mapper.createObjectNode();
		node.put(MarketingConstants.TASK_ID, createTaskVO.getId());
		if (taskImagesVOs != null && taskImagesVOs.size() > 0) {
			taskImagesMapper.batchInsertTaskImages(taskImagesVOs);
			taskMapper.updateTaskStatus(createTaskVO.getId(), MarketingConstants.TASK_STATUS_IMAGE_UPLOADED, 0);
			node.put("length", taskImagesVOs.size());
		}
		logger.info("result of createTask method: " + node.toString());
		return new ServiceResponseBO(node);
	}

	@Transactional
	public ServiceResponseBO taskImages(List<MultipartFile> images, String taskId, String userId) {
		logger.info("params of taskImages: taskId:" + taskId + ", userId:" + userId);
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
			logger.info("taskId:" + taskId + ", result of taskImages: " + node.toString());
			return new ServiceResponseBO(node);
		} else if (result == -1) {
			return new ServiceResponseBO(false, "marketing_save_upload_file_error");
		} else {
			return new ServiceResponseBO(false, "marketing_db_error");
		}
	}

	@SuppressWarnings("deprecation")
	public ServiceResponseBO taskStatus(String taskId) {
		logger.info("params of taskStatus: taskId:" + taskId);
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
						logger.error("taskId:" + taskId + ", 获取任务返回goodResults结果失败:" + e.getMessage());
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
						logger.error("taskId:" + taskId + ", get task result fail, " + e.getMessage());
						e.printStackTrace();
					}
				}
			}
			// logger.info("taskId:" + taskId + ", result of taskStatus method:"
			// + newNode.toString());
			return new ServiceResponseBO(newNode);
		} else {
			return new ServiceResponseBO(false, "marketing_task_not_existed");
		}
	}

	public ServiceResponseBO taskStitcher(String taskId, Boolean needStitch, String majorType, String userId) {
		logger.info("params of taskStitcher: taskId:" + taskId + ", needStitch:" + needStitch + ", majorType:"
				+ majorType + ", userId:" + userId);
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
		logger.info("taskId:" + taskId + ", params of stitcher server: " + param.convertToJSON());
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
		logger.info("params of taskIdentify: taskId:" + taskId + ", userId:" + userId);
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
					logger.info("taskId:" + taskId + ", taskIdentify method of origin_file: " + origin_file);
					String[] fileNameInfo = getFileNameMD5(origin_file);
					if (fileNameInfo != null) {
						String fileName = fileNameInfo[0];
						String score = fileNameInfo[1];
						logger.info("taskId:" + taskId + ", taskIdentify method of score: " + score);
						String data = getResultByFileName(fileName, Double.parseDouble(score));
						if (!StringUtils.isBlank(data)) {
							logger.info("taskId:" + taskId + ", taskIdentify method of use mock with file: "
									+ fileNameInfo[0]);
							ObjectNode node = JsonUtil.toObjectNode(data);
							result = CommonAjaxResponse.toSuccess(node);
							isMock = true;
						}
					}
				}
			}
			// *************mock end*************

			if (!isMock) {
				logger.info("taskId:" + taskId + ", taskIdentify method call service");
				MarketingIdentifyRequestParam param = new MarketingIdentifyRequestParam();
				param.setMajor_type(taskVO.getMajorType());
				param.setTask_id(taskId);
				logger.info("taskId:" + taskId + ", params of identify server: " + param.convertToJSON());
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
		logger.info("params of deleteImage method: taskId:" + taskId + ", taskImagesId:" + taskImagesId);
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
			logger.info("taskId:" + taskId + ", result of deleteTaskImage: " + updateResult);
			if (updateResult > 0) {
				File file = new File(imagesVO.getFullPath());
				if (file.exists()) {
					boolean deleteFileResult = file.delete();
					logger.info("taskId:" + taskId + ", physics delete image result: " + deleteFileResult);
				}
				result = taskMapper.updateTaskStatus(taskId, MarketingConstants.TASK_STATUS_IMAGE_UPLOADED, 0);
			}
		} else {
			return new ServiceResponseBO(false, "marketing_db_not_found");
		}
		if (result > 0) {
			ObjectMapper mapper = new ObjectMapper();
			ObjectNode node = mapper.createObjectNode();
			node.put("resourceId", taskImagesId);
			logger.info("taskId:" + taskId + ", result of deleteImage method: " + node.toString());
			return new ServiceResponseBO(node);
		} else {
			return new ServiceResponseBO(false, "marketing_image_delete_failure");
		}
	}

	public ServiceResponseBO replace(String taskId, String taskImageId, MultipartFile image, int appId, String userId) {
		logger.info("params of replace method: taskId:" + taskId + ", taskImagesId:" + taskImageId + ",appId:" + appId);
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
		UploadFile file = MarketingStorageUtils.getUploadFile(image, userId, taskVO.getId(), taskVO.getCreateTime(),
				ConfigUtils.getInstance().getConfigValue("marketing.image.sub.dir"), false);
		TaskImagesVO imagesVO = new TaskImagesVO();
		int index = file.getPath().indexOf(MarketingConstants.MARKETING);
		String imagePath = file.getPath().substring(index + MarketingConstants.MARKETING.length());
		imagesVO.setImagePath(imagePath);
		imagesVO.setFullPath(file.getPath());
		imagesVO.setName(file.getName());
		imagesVO.setId(taskImageId);
		int updateResult = taskImagesMapper.updateTaskImage(imagesVO);
		logger.info("taskId:" + taskId + ", result of updateTaskImage for replace method: " + updateResult
				+ ", taskId: " + taskId);

		result = taskMapper.updateTaskStatus(taskId, MarketingConstants.TASK_STATUS_IMAGE_UPLOADED, 0);
		logger.info("taskId:" + taskId + ", result of updateTaskStatus for repalce method: " + result + ", taskId: "
				+ taskId);
		if (result > 0) {
			ObjectMapper mapper = new ObjectMapper();
			ObjectNode node = mapper.createObjectNode();
			node.put("resourceId", taskImageId);
			logger.info("taskId:" + taskId + ", result of repalce method: " + node.toString() + ", taskId: " + taskId);
			return new ServiceResponseBO(node);
		} else {
			return new ServiceResponseBO(false, "marketing_image_delete_failure");
		}
	}

	@Transactional
	public ServiceResponseBO taskOrder(List<OrderBO> imagesVOs, String taskId) {
		logger.info("params of taskOrder method: taskId:" + taskId);
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
			logger.info("taskId:" + taskId + ", result of batchUpdateTaskImages for taskOrder method: " + updateResult);
			if (updateResult > 0) {
				taskMapper.updateTaskStatus(taskId, MarketingConstants.TASK_STATUS_IMAGE_UPLOADED, 0);
				ObjectMapper mapper = new ObjectMapper();
				ObjectNode node = mapper.createObjectNode();
				node.put(MarketingConstants.TASK_ID, taskId);
				logger.info("taskId:" + taskId + ", result of taskOrder method: " + node.toString());
				return new ServiceResponseBO(node);
			} else {
				return new ServiceResponseBO(false, "marketing_parameter_invalid");
			}
		} else {
			return new ServiceResponseBO(false, "marketing_parameter_invalid");
		}
	}

	public String getBorderImagePath(TaskVO taskVO) {
		logger.info("params of getBorderImagePath method: taskId:" + taskVO.getId());
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
				logger.error("taskId:" + taskVO.getId() + ", parse json fail, " + e.getMessage());
			}
			logger.info("taskId:" + taskVO.getId() + ", result of getBorderImagePath: " + resultStr);
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
							if (i >= goodArr.size()) {
								break;
							}
							GoodsSkuVO goodsSkuVO = goodArr.get(i);

							GoodsBO goods = new GoodsBO();
							goods.setGoods_name(goodsSkuVO.getName());
							goods.setGoods_desc(goodsSkuVO.getDescription());
							if (oNode.get("num") != null) {
								String num = oNode.get("num").toString();
								if (!isInteger(oNode.get("num").toString())) {
									BigDecimal b1 = new BigDecimal(Float.parseFloat(oNode.get("num").toString()));
									double f2 = b1.setScale(1, BigDecimal.ROUND_HALF_UP).doubleValue();
									num = String.valueOf(f2);
								}
								goods.setNum(num);
							}
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
				logger.error("taskId:" + taskVO.getId() + ", 获取任务返回goodResults结果失败, " + e.getMessage());
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

	public List<TaskVO> getTempTaskList(TaskBO taskBO) {
		return taskMapper.getTempTaskList(taskBO);
	}

	public int getTempTaskCount(TaskBO taskBO) {
		return taskMapper.getTempTaskCount(taskBO);
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

	public TaskVO getNextTask(String taskId, String userId) {
		return taskMapper.getNextTask(taskId, userId);
	}

	public List<CropBO> getTaskImageCrops(String taskId, Integer imageOrderNo) {
		logger.info("params of getTaskImageCrops method: taskId:" + taskId + ",imageOrderNo:" + imageOrderNo);
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
								if (oNode.get("label") != null) {
									cropBO.setLabel(oNode.get("label").asInt());
								}
								cropBOs.add(cropBO);
							}
						}
					}
				} catch (IOException e) {
					logger.error(
							"taskId:" + taskId + ", getTaskImageCrops method 获取taskImageCrop失败, " + e.getMessage());
				}
			}
		}

		return cropBOs;
	}

	public List<CropBO> getTaskIdentifyCrops(String taskId, Integer produceId) {
		logger.info("params of getTaskIdentifyCrops method: taskId:" + taskId + ",produceId:" + produceId);
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
					logger.error("taskId:" + taskId + ", getTaskIdentifyCrops method 获取taskIdentifyCrop失败, "
							+ e.getMessage());
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

	public List<AecBO> getAecsByTaskIds(String[] taskIds) {
		List<AecBO> aecBOs = new ArrayList<AecBO>();
		if (taskIds != null && taskIds.length > 0) {
			CountDownLatch latch = new CountDownLatch(taskIds.length);
			for (int i = 0; i < taskIds.length; i++) {
				String taskId = taskIds[i];
				generateExecutorPool.execute(
						new XMLGeneratorThread(latch, aecBOs, taskId, taskMapper, taskImagesMapper, goodsSkuMapper));
			}
			try {
				latch.await();
			} catch (InterruptedException e) {
				logger.error("Thread interrupte exception, caused by:" + e.getMessage());
			}
		}
		logger.info("total download size:" + aecBOs.size());
		return aecBOs;
	}

	public String aecUpload(MultipartFile zipFile) {

		String basePath = String.format("%s%s%s%s%s%s",
				com.tunicorn.util.ConfigUtils.getInstance().getConfigValue("storage.private.basePath"),
				ConfigUtils.getInstance().getConfigValue("marketing.image.root.path"), File.separator,
				MarketingConstants.AEC_PATH, File.separator, MarketingConstants.UPLOAD_PATH);
		// boolean rectifyResult = false;
		Map<String, Set<String>> failMap = new HashMap<String, Set<String>>();
		Set<String> rectifyFailedList = new HashSet<String>();
		Set<String> syncFailedList = new HashSet<String>();
		Set<String> imageNotExistList = new HashSet<String>();

		List<File> xmlFileList = new ArrayList<File>();
		// String basePath1 = "D:\\aecq";
		try {
			ZipInputStream zin = new ZipInputStream(zipFile.getInputStream());
			ZipEntry ze;
			long uploadXmlFileStart = System.currentTimeMillis();
			while ((ze = zin.getNextEntry()) != null) {
				if (!ze.isDirectory() && ze.getName().contains(".xml")) {
					File xmlFile = new File(basePath + File.separator + ze.getName());
					xmlFile.setWritable(true, false);
					FileUtils.writeStringToFile(xmlFile, StringUtils.EMPTY);

					FileOutputStream fos = new FileOutputStream(xmlFile);

					int len = 0;
					byte b[] = new byte[1024];
					while ((len = zin.read(b)) != -1) {
						fos.write(b, 0, len);
					}
					fos.close();

					xmlFileList.add(xmlFile);
				}
			}
			zin.closeEntry();
			long uploadXmlFileEnd = System.currentTimeMillis();
			logger.info("aec upload xml and put in list use " + (uploadXmlFileEnd - uploadXmlFileStart));
			int totalSize = xmlFileList.size();
			int threadSize = THREAD_UPLOAD_MAX_SIZE - 1;
			int size = totalSize / threadSize;
			int mod = totalSize % threadSize;
			if (mod > 0) {
				threadSize++;
			}
			CountDownLatch latch = new CountDownLatch(threadSize);
			for (int i = 1; i <= threadSize; i++) {
				List<File> subXmlFiles = new ArrayList<File>();
				if (i < threadSize) {
					subXmlFiles = xmlFileList.subList((i - 1) * size, i * size);
				} else {
					subXmlFiles = xmlFileList.subList((i - 1) * size, totalSize);
				}
				aecUploadExecutorPool.execute(new AecUploadThread(latch, subXmlFiles, syncFailedList, rectifyFailedList,
						imageNotExistList, taskMapper, taskImagesMapper, goodsSkuMapper));
			}

			try {
				latch.await();
			} catch (InterruptedException e) {
				logger.error("Thread interrupte exception, caused by:" + e.getMessage());
			}

			logger.info("updateTaskGoodInfoAndRectify end");

			failMap.put("syncFailed", syncFailedList);
			failMap.put("rectifyFailed", rectifyFailedList);
			failMap.put("imageNotExist", imageNotExistList);

		} catch (IOException e) {
			logger.info("unzip fail, " + e.getMessage());
			return StringUtils.EMPTY;
		}
		String filePath = getFailMapFilePath(failMap);
		return filePath;
	}

	private String getFailMapFilePath(Map<String, Set<String>> failMap) {
		List<String> syncFailedList = new ArrayList<String>(failMap.get("syncFailed"));
		List<String> rectifyFailedList = new ArrayList<String>(failMap.get("rectifyFailed"));
		List<String> imageNotExistList = new ArrayList<String>(failMap.get("imageNotExist"));
		StringBuffer buffer = new StringBuffer();

		if (syncFailedList.size() == 0 && rectifyFailedList.size() == 0 && imageNotExistList.size() == 0) {
			buffer.append("所有任务已成功纠错并拉取数据");
		} else {
			if (imageNotExistList.size() > 0) {
				buffer.append("图片不存在:");
				for (int i = 0; i < imageNotExistList.size(); i++) {
					buffer.append(imageNotExistList.get(i));
					if (i < (imageNotExistList.size() - 1)) {
						buffer.append(",");
					} else {
						buffer.append("\n");
					}
				}
			}
			if (rectifyFailedList.size() > 0) {
				buffer.append("纠错失败：");
				for (int i = 0; i < rectifyFailedList.size(); i++) {
					buffer.append(rectifyFailedList.get(i));
					if (i < (rectifyFailedList.size() - 1)) {
						buffer.append(",");
					} else {
						buffer.append("\n");
					}
				}
			}
			if (syncFailedList.size() > 0) {
				buffer.append("拉取数据失败:");
				for (int i = 0; i < syncFailedList.size(); i++) {
					buffer.append(syncFailedList.get(i));
					if (i < (syncFailedList.size() - 1)) {
						buffer.append(",");
					}
				}
			}
		}
		SimpleDateFormat dfs = new SimpleDateFormat("yyyyMMddHHmmss");
		Date time = new Date();
		String formatTime = dfs.format(time);

		String filePath = String.format("%s%s%s%s%s%s",
				com.tunicorn.util.ConfigUtils.getInstance().getConfigValue("storage.private.basePath"),
				ConfigUtils.getInstance().getConfigValue("marketing.image.root.path"), File.separator,
				MarketingConstants.AEC_PATH, File.separator, "result_" + formatTime + ".txt");
		// String filePath1 = "D:\\aecq\\download\\" + "result_" + formatTime +
		// ".txt";
		File file = new File(filePath);
		file.setWritable(true, false);
		try {
			FileUtils.writeStringToFile(file, buffer.toString());
		} catch (IOException e) {
			logger.error("aec 线下纠错生成纠错结果文件失败， " + e.getMessage());
			return StringUtils.EMPTY;
		}
		return filePath;
	}

	@SuppressWarnings({ "unchecked", "unused" })
	private ArrayNode parseXml(File xmlFile, String majorType) {

		SAXReader saxReader = new SAXReader();
		ObjectMapper mapper = new ObjectMapper();
		ArrayNode arrayNode = mapper.createArrayNode();
		Document document;
		try {
			document = saxReader.read(xmlFile);

			Element root = document.getRootElement();
			List<Element> objectList = root.elements("object");
			if (objectList != null && objectList.size() > 0) {
				for (Element element : objectList) {
					String name = element.elementText("name");

					Element bndboxElement = element.element("bndbox");
					String xmin = bndboxElement.elementText("xmin");
					String ymin = bndboxElement.elementText("ymin");
					String xmax = bndboxElement.elementText("xmax");
					String ymax = bndboxElement.elementText("ymax");

					ObjectNode node = mapper.createObjectNode();

					GoodsSkuBO goodsSkuBO = new GoodsSkuBO();
					goodsSkuBO.setName(name);
					goodsSkuBO.setMajorType(majorType);

					List<GoodsSkuVO> goodsSkuVOs = goodsSkuMapper.getNewGoodsSkuListByBO(goodsSkuBO);
					if (goodsSkuVOs != null && goodsSkuVOs.size() > 0) {
						node.put("label", goodsSkuVOs.get(0).getOrder() + 1);
					} else {
						node.put("label", 0);
					}

					if (StringUtils.isNotBlank(xmin) && StringUtils.isNotBlank(xmax)) {
						node.put("x", Integer.valueOf(xmin));
						node.put("width", Integer.valueOf(xmax) - Integer.valueOf(xmin));
					}
					if (StringUtils.isNotBlank(ymin) && StringUtils.isNotBlank(ymax)) {
						node.put("y", Integer.valueOf(ymin));
						node.put("height", Integer.valueOf(ymax) - Integer.valueOf(ymin));
					}
					arrayNode.add(node);
				}
			}

		} catch (DocumentException e) {
			logger.info("parseXml fail: " + e.getMessage());
		}
		return arrayNode;
	}

	@SuppressWarnings("unused")
	private boolean updateTaskGoodInfoAndRectify(ArrayNode arrayNode, TaskVO taskVO, int imageOrder) {
		String result = (String) taskVO.getResult();
		boolean rectifyResult = false;
		if (StringUtils.isNotBlank(result)) {
			ObjectMapper mapper = new ObjectMapper();
			ObjectNode nodeResult;
			try {
				nodeResult = (ObjectNode) mapper.readTree(result);
				if (nodeResult.findValue("goodInfo") != null) {
					ArrayNode jsonNodes = (ArrayNode) nodeResult.findValue("goodInfo");
					ObjectNode jsonNode = (ObjectNode) jsonNodes.get(imageOrder - 1);
					// JsonNode rectJsonNode = jsonNode.get("rect");
					jsonNode.set("rect", arrayNode);
					taskVO.setResult(nodeResult.toString());
					int updateResult = taskMapper.updateTask(taskVO);
					if (updateResult > 0) {
						CommonAjaxResponse ajaxResponse = rectify(taskVO.getId());
						if (ajaxResponse != null && ajaxResponse.getSuccess()) {
							rectifyResult = true;
						} else {
							// jsonNode.set("rect", rectJsonNode);
							// taskVO.setResult(nodeResult.toString());
							// taskMapper.updateTask(taskVO);
						}
					}
					logger.info("taskId:" + taskVO.getId() + ", aecUpload result: " + updateResult);
				}

			} catch (IOException e) {
				logger.error("taskId:" + taskVO.getId() + ", aecUpload fail, " + e.getMessage());
			}
		}
		return rectifyResult;
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
		String DateStr = sdf.format(date);
		apiCallingSummaryVO.setCallingDay(DateStr);
		apiCallingSummaryVO.setUserName(userName);

		List<ApiCallingSummaryVO> tempApiCallingSummaryVO = apiCallingSummaryMapper
				.getApiCallingSummaryListByVO(apiCallingSummaryVO);
		if (tempApiCallingSummaryVO != null && tempApiCallingSummaryVO.size() > 0) {
			apiCallingSummaryVO.setId(tempApiCallingSummaryVO.get(0).getId());
			apiCallingSummaryVO.setCallingTimes(callingTimes + tempApiCallingSummaryVO.get(0).getCallingTimes());
			int updateSummaryResult = apiCallingSummaryMapper.updateApiCallingSummary(apiCallingSummaryVO);
			logger.info("result of updateApiCallingSummary: " + updateSummaryResult);
		} else {
			apiCallingSummaryVO.setCallingTimes(callingTimes);
			apiCallingSummaryVO.setUserName(userName);
			long insertSummaryResult = apiCallingSummaryMapper.insertApiCallingSummary(apiCallingSummaryVO);
			logger.info("result of insertApiCallingSummary: " + insertSummaryResult);
		}

		ApiCallingDetailVO apiCallingDetailVO = new ApiCallingDetailVO();
		apiCallingDetailVO.setApiMethod(updateParam.getApiMethod());
		apiCallingDetailVO.setApiName(updateParam.getApiName());
		apiCallingDetailVO.setCallingStatus(callingStatus);
		apiCallingDetailVO.setPictures((int) taskImagesCount);
		apiCallingDetailVO.setUserName(userName);
		int insertDetailResult = apiCallingDetailMapper.insertApiCallingDetail(apiCallingDetailVO);
		logger.info("result of insertApiCallingDetail: " + insertDetailResult);
		ObjectMapper mapper = new ObjectMapper();
		ObjectNode node = mapper.createObjectNode();
		node.put(MarketingConstants.TASK_ID, updateParam.getTaskId());
		logger.info("result of updateApiCalling method: " + node.toString());
		return node;
	}

	public List<GoodsSkuVO> getGoods(String majorType) {
		return goodsSkuMapper.getGoodsSkuListByMajorType(majorType);
	}

	public List<GoodsSkuVO> getGoodsSkuListByMajorTypeWithShow(String majorType) {
		return goodsSkuMapper.getGoodsSkuListByMajorTypeWithShow(majorType);
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
						int updateResult = taskMapper.updateTask(taskVO);
						logger.info("taskId:" + taskId + ", save task goodsInfo result: " + updateResult);
					}

				} catch (IOException e) {
					logger.error("taskId:" + taskId + ", save task goodsInfo fail, " + e.getMessage());
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

	public CommonAjaxResponse getStore(String taskId) {
		MarketingGetStoreRequestParam param = new MarketingGetStoreRequestParam();
		param.setTaskId(taskId);
		String tokenStr = taskId + MarketingConstants.INNOVISION;
		try {
			MessageDigest messageDigest = MessageDigest.getInstance("MD5");
			messageDigest.update(tokenStr.getBytes());
			param.setToken(new BigInteger(1, messageDigest.digest()).toString(16));
		} catch (NoSuchAlgorithmException e) {
			logger.info("taskId:" + taskId + ", getStore method token MD5 fail " + e.getMessage());
		}
		CommonAjaxResponse result = MarketingAPI.getStore(param);
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
				node.put("stitchImagePath", taskVO.getStitchImagePath());
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
						logger.error("get task result fail, " + e.getMessage());
					}
					node.put("crops", (ArrayNode) nodeResult.findValue("crops"));
				}
			}
		}
		logger.info("taskId:" + taskId + ", result of getTaskResult method: " + node.toString());
		return node;
	}

	@SuppressWarnings("deprecation")
	@Transactional
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
					int updateResult = taskMapper.updateTask(taskVO);
					logger.info("taskId:" + taskId + ", save taskImageCrop result: " + updateResult);
				} catch (IOException e) {
					logger.error("taskId:" + taskId + ", save taskImageCrop fail, " + e.getMessage());
				}
			}
		}
	}

	public void generateFile(ImageCropBO cropBO) {
		String xmlFilePath = String.format("%s%s%s%s%s%s%s%s",
				com.tunicorn.util.ConfigUtils.getInstance().getConfigValue("storage.private.basePath"),
				ConfigUtils.getInstance().getConfigValue("marketing.image.root.path"), File.separator,
				cropBO.getMajorType(), File.separator, MarketingConstants.CROP_XML_PATH, File.separator,
				cropBO.getImageId() + ".xml");
		File imageFile;
		TaskImagesVO imagesVO = taskImagesMapper.getTaskImagesById(cropBO.getImageId());
		String imageFilenameTemp = "";
		if (imagesVO != null && imagesVO.getFullPath() != null) {
			try {
				imageFile = new File(imagesVO.getFullPath());
				imageFilenameTemp = String.format("%s%s%s%s%s%s%s%s",
						com.tunicorn.util.ConfigUtils.getInstance().getConfigValue("storage.private.basePath"),
						ConfigUtils.getInstance().getConfigValue("marketing.image.root.path"), File.separator,
						cropBO.getMajorType(), File.separator, MarketingConstants.CROP_IMAGE_PATH, File.separator,
						cropBO.getImageId() + ".jpg");
				FileUtils.copyFile(new File(imagesVO.getFullPath()), new File(imageFilenameTemp));

				BufferedImage bufferedImage = ImageIO.read(imageFile);
				int width = bufferedImage.getWidth();
				int height = bufferedImage.getHeight();
				generateXmlFile(cropBO, xmlFilePath, width, height);
			} catch (IOException e) {
				logger.error("imageId:" + cropBO.getImageId() + ", copy file fail, " + e.getMessage());
			}
		}
	}

	public PriceIdentifyBO priceIdentify(MultipartFile image, String userId) {

		UploadFile file = MarketingStorageUtils.getUploadFile(image, userId, MarketingConstants.PRICE_IDENTIFY,
				new Date(), ConfigUtils.getInstance().getConfigValue("marketing.image.sub.dir"), false);
		PriceIdentifyBO priceIdentifyBO = new PriceIdentifyBO();
		if (file != null) {
			MarketingPriceIdentifyRequestParam param = new MarketingPriceIdentifyRequestParam();
			param.setMajorType(MarketingConstants.PRICE_IDENTIFY);
			param.setImg_url(file.getPath());
			CommonAjaxResponse result = MarketingAPI.priceIdentify(param);
			if (result.getSuccess()) {

				ObjectNode retData = (ObjectNode) result.getData();
				if (retData.get("name") != null) {
					priceIdentifyBO.setName(retData.get("name").asText());
				}
				if (retData.get("price") != null) {
					priceIdentifyBO.setPrice(retData.get("price").asText());
				}
			}
		}
		return priceIdentifyBO;
	}

	private void generateXmlFile(ImageCropBO cropBO, String xmlFilePath, int width, int height) {
		Element root = DocumentHelper.createElement("annotation");
		Document document = DocumentHelper.createDocument(root);

		// 给根节点添加孩子节点
		root.addElement("foder").addText("newdata");
		root.addElement("filename").addText(cropBO.getImageId());
		root.addElement("path").addText(xmlFilePath);

		Element sourceElement = root.addElement("source");
		sourceElement.addElement("database").addText("mysql");

		Element sizeElement = root.addElement("size");
		sizeElement.addElement("width").addText(String.valueOf(width));
		sizeElement.addElement("height").addText(String.valueOf(height));
		sizeElement.addElement("depth").addText("3");

		root.addElement("segmented").addText("0");
		if (cropBO != null && cropBO.getImageCrop() != null && cropBO.getImageCrop().size() > 0) {
			ArrayNode arrayNode = cropBO.getImageCrop();
			for (int j = 0; j < arrayNode.size(); j++) {
				Element objectElement = root.addElement("object");

				ObjectNode nodeResult = (ObjectNode) arrayNode.get(j);
				String labelName = "Others";
				GoodsSkuBO goodsSkuBO = new GoodsSkuBO();
				if (nodeResult.get("label") != null) {
					goodsSkuBO.setOrder(nodeResult.get("label").asInt() - 1);
				}
				goodsSkuBO.setMajorType(cropBO.getMajorType());
				List<GoodsSkuVO> goodsSkuVOs = goodsSkuMapper.getGoodsSkuListByBO(goodsSkuBO);
				if (goodsSkuVOs != null && goodsSkuVOs.size() > 0) {
					labelName = goodsSkuVOs.get(0).getName();
				}
				objectElement.addElement("name").addText(labelName);
				objectElement.addElement("pose").addText("Unspecified");
				objectElement.addElement("truncated").addText("0");
				objectElement.addElement("difficult").addText("0");
				Element bndboxElement = objectElement.addElement("bndbox");
				int x = 0;
				int y = 0;
				if (nodeResult.get("x") != null) {
					bndboxElement.addElement("xmin").addText(nodeResult.get("x").toString());
					x = nodeResult.get("x").asInt();
				}
				if (nodeResult.get("y") != null) {
					bndboxElement.addElement("ymin").addText(nodeResult.get("y").toString());
					y = nodeResult.get("y").asInt();
				}
				if (nodeResult.get("width") != null) {
					bndboxElement.addElement("xmax").addText(String.valueOf(x + nodeResult.get("width").asInt()));
				}
				if (nodeResult.get("height") != null) {
					bndboxElement.addElement("ymax").addText(String.valueOf(y + nodeResult.get("height").asInt()));
				}
			}
		}
		try {
			OutputFormat format = OutputFormat.createPrettyPrint();
			format.setEncoding("UTF-8");
			// 设置在声明之后不换行
			format.setNewLineAfterDeclaration(false);
			File file = new File(xmlFilePath);
			file.setWritable(true, false);
			FileUtils.writeStringToFile(file, StringUtils.EMPTY);
			XMLWriter xmlWriter = new XMLWriter(new FileOutputStream(file), format);
			xmlWriter.write(document);
			xmlWriter.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

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
			TaskVO taskVO = taskMapper.getTaskById(taskId);
			for (int i = 0; i < images.size(); i++) {
				TaskImagesVO taskImagesVO = new TaskImagesVO();

				UploadFile file = MarketingStorageUtils.getUploadFile(images.get(i), userId, taskId,
						taskVO.getCreateTime(), ConfigUtils.getInstance().getConfigValue("marketing.image.sub.dir"),
						false);

				if (file == null) {
					logger.error("taskId:" + taskId + ", save form-data file failure");
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
			result = taskMapper.updateTaskStatus(taskId, MarketingConstants.TASK_STATUS_IMAGE_UPLOADED, 0);
		}
		logger.info("taskId:" + taskId + ", result of addImages method : " + result);
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
				logger.error("taskId:" + tempTaskVO.getId() + ", get task result fail, " + e.getMessage());
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
		if (StringUtils.equals(tempTaskVO.getTaskStatus(), MarketingConstants.TASK_STATUS_IDENTIFY_SUCCESS)) {
			node.put("identifySuccessTimes", tempTaskVO.getIdentifySuccessTimes());
		}
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
				logger.error("taskId:" + tempTaskVO.getId() + ", get task result fail, " + e.getMessage());
			}
		}
		// logger.info("taskId:" + tempTaskVO.getId() + ", result of get task
		// result: " + node.toString());
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
			if (i >= goodArr.size()) {
				break;
			}
			ObjectMapper tempMapper = new ObjectMapper();
			ObjectNode tempNode = tempMapper.createObjectNode();
			GoodsSkuVO goodsSkuVO = goodArr.get(i);

			tempNode.put("goods_name", goodsSkuVO.getName());
			tempNode.put("goods_desc", goodsSkuVO.getDescription());
			tempNode.put("ratio", f1 + "%");
			if (oNode.get("num") != null) {
				String num = oNode.get("num").toString();
				if (!isInteger(oNode.get("num").toString())) {
					BigDecimal b1 = new BigDecimal(Float.parseFloat(oNode.get("num").toString()));
					double f2 = b1.setScale(1, BigDecimal.ROUND_HALF_UP).doubleValue();
					num = String.valueOf(f2);
				}
				tempNode.put("num", num);
			}
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
			logger.error("file name MD5 fail, " + e.getMessage());
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
						if (oNode.get("num") != null) {
							String num = oNode.get("num").toString();
							if (!isInteger(oNode.get("num").toString())) {
								BigDecimal b1 = new BigDecimal(Float.parseFloat(oNode.get("num").toString()));
								double f2 = b1.setScale(1, BigDecimal.ROUND_HALF_UP).doubleValue();
								num = String.valueOf(f2);
							}
							numBuffer.append(",").append(num);
						}
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
			logger.error("get task goodResults export data fail, " + e.getMessage());
		}

		return result.append(ratioBuffer).append(numBuffer).append(oriAreaBuffer).append(rowsBuffer).append(",")
				.append(totalArea).append(",").append(rows).toString();
	}

	public boolean isInteger(String str) {
		Pattern pattern = Pattern.compile("^[-\\+]?[\\d]*$");
		return pattern.matcher(str).matches();
	}

	public List<TaskVO> getPendingWithoutHost() {
		return taskMapper.getPendingWithoutHostTasks();
	}
}

class XMLGeneratorThread implements Runnable {
	private static Logger logger = Logger.getLogger(XMLGeneratorThread.class);
	private CountDownLatch latch;
	List<AecBO> aecBOs;
	String taskId;
	private TaskMapper taskMapper;
	private TaskImagesMapper taskImagesMapper;
	private GoodsSkuMapper goodsSkuMapper;

	public XMLGeneratorThread(CountDownLatch count, List<AecBO> total, String taskId, TaskMapper taskMapper,
			TaskImagesMapper taskImagesMapper, GoodsSkuMapper goodsSkuMapper) {
		this.latch = count;
		this.aecBOs = total;
		this.taskId = taskId;
		this.taskMapper = taskMapper;
		this.taskImagesMapper = taskImagesMapper;
		this.goodsSkuMapper = goodsSkuMapper;
	}

	public void run() {
		List<TaskImagesVO> imagesVOs = taskImagesMapper.getTaskImagesListByTaskId(taskId);
		TaskVO taskVO = taskMapper.getTaskById(taskId);
		try {
			if (imagesVOs != null && imagesVOs.size() > 0) {
				for (TaskImagesVO taskImagesVO : imagesVOs) {
					AecBO aecBO = new AecBO();

					BufferedImage bufferedImage;
					bufferedImage = ImageIO.read(new File(taskImagesVO.getFullPath()));
					int width = bufferedImage.getWidth();
					int height = bufferedImage.getHeight();

					String imageExt = ".jpg";
					String imageFullPath = taskImagesVO.getFullPath();
					if (StringUtils.isNotBlank(imageFullPath)) {
						int index = imageFullPath.lastIndexOf(MarketingConstants.POINT);
						imageExt = imageFullPath.substring(index);
					}
					String imageFilePath = String.format("%s%s%s%s%s%s%s%s",
							com.tunicorn.util.ConfigUtils.getInstance().getConfigValue("storage.private.basePath"),
							ConfigUtils.getInstance().getConfigValue("marketing.image.root.path"), File.separator,
							taskVO.getMajorType(), File.separator, MarketingConstants.AEC_PATH, File.separator,
							taskImagesVO.getId() + imageExt);

					FileUtils.copyFile(new File(taskImagesVO.getFullPath()), new File(imageFilePath));
					String xmlFilePath = String.format("%s%s%s%s%s%s%s%s",
							com.tunicorn.util.ConfigUtils.getInstance().getConfigValue("storage.private.basePath"),
							ConfigUtils.getInstance().getConfigValue("marketing.image.root.path"), File.separator,
							taskVO.getMajorType(), File.separator, MarketingConstants.AEC_PATH, File.separator,
							taskImagesVO.getId() + ".xml");

					ImageCropBO cropBO = new ImageCropBO();
					cropBO.setTaskId(taskId);
					cropBO.setImageId(taskImagesVO.getId());
					cropBO.setMajorType(taskVO.getMajorType());
					cropBO.setOrder(taskImagesVO.getOrderNo());
					cropBO.setImageCrop(getImageCrops(taskVO, taskImagesVO.getOrderNo()));
					generateXmlFile(cropBO, xmlFilePath, width, height);

					aecBO.setImage(imageFilePath);
					aecBO.setAnnotationXML(xmlFilePath);
					synchronized (latch) {
						aecBOs.add(aecBO);
					}
				}
			}
		} catch (IOException e) {
			logger.error("getAecsByTaskIds method 获取指定任务的标记信息失败, " + e.getMessage());
		} finally {
			latch.countDown();
		}
	}

	private void generateXmlFile(ImageCropBO cropBO, String xmlFilePath, int width, int height) {
		Element root = DocumentHelper.createElement("annotation");
		Document document = DocumentHelper.createDocument(root);

		// 给根节点添加孩子节点
		root.addElement("foder").addText("newdata");
		root.addElement("filename").addText(cropBO.getImageId());
		root.addElement("path").addText(xmlFilePath);

		Element sourceElement = root.addElement("source");
		sourceElement.addElement("database").addText("mysql");

		Element sizeElement = root.addElement("size");
		sizeElement.addElement("width").addText(String.valueOf(width));
		sizeElement.addElement("height").addText(String.valueOf(height));
		sizeElement.addElement("depth").addText("3");

		root.addElement("segmented").addText("0");
		if (cropBO != null && cropBO.getImageCrop() != null && cropBO.getImageCrop().size() > 0) {
			ArrayNode arrayNode = cropBO.getImageCrop();
			for (int j = 0; j < arrayNode.size(); j++) {
				Element objectElement = root.addElement("object");

				ObjectNode nodeResult = (ObjectNode) arrayNode.get(j);
				String labelName = "Others";
				GoodsSkuBO goodsSkuBO = new GoodsSkuBO();
				if (nodeResult.get("label") != null) {
					goodsSkuBO.setOrder(nodeResult.get("label").asInt() - 1);
				}
				goodsSkuBO.setMajorType(cropBO.getMajorType());
				List<GoodsSkuVO> goodsSkuVOs = goodsSkuMapper.getGoodsSkuListByBO(goodsSkuBO);
				if (goodsSkuVOs != null && goodsSkuVOs.size() > 0) {
					labelName = goodsSkuVOs.get(0).getName();
				}
				objectElement.addElement("name").addText(labelName);
				objectElement.addElement("pose").addText("Unspecified");
				objectElement.addElement("truncated").addText("0");
				objectElement.addElement("difficult").addText("0");
				Element bndboxElement = objectElement.addElement("bndbox");
				int x = 0;
				int y = 0;
				if (nodeResult.get("x") != null) {
					bndboxElement.addElement("xmin").addText(nodeResult.get("x").toString());
					x = nodeResult.get("x").asInt();
				}
				if (nodeResult.get("y") != null) {
					bndboxElement.addElement("ymin").addText(nodeResult.get("y").toString());
					y = nodeResult.get("y").asInt();
				}
				if (nodeResult.get("width") != null) {
					bndboxElement.addElement("xmax").addText(String.valueOf(x + nodeResult.get("width").asInt()));
				}
				if (nodeResult.get("height") != null) {
					bndboxElement.addElement("ymax").addText(String.valueOf(y + nodeResult.get("height").asInt()));
				}
			}
		}
		try {
			OutputFormat format = OutputFormat.createPrettyPrint();
			format.setEncoding("UTF-8");
			// 设置在声明之后不换行
			format.setNewLineAfterDeclaration(false);
			File file = new File(xmlFilePath);
			file.setWritable(true, false);
			FileUtils.writeStringToFile(file, StringUtils.EMPTY);
			XMLWriter xmlWriter = new XMLWriter(new FileOutputStream(file), format);
			xmlWriter.write(document);
			xmlWriter.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	private static ArrayNode getImageCrops(TaskVO taskVO, int imageOrder) {
		ObjectMapper mapper = new ObjectMapper();
		if (taskVO != null) {
			String result = (String) taskVO.getResult();
			if (StringUtils.isNotBlank(result)) {
				ObjectNode nodeResult;
				try {
					nodeResult = (ObjectNode) mapper.readTree(result);
					if (nodeResult.findValue("goodInfo") != null) {
						ArrayNode jsonNodes = (ArrayNode) nodeResult.findValue("goodInfo");
						JsonNode tempNode = jsonNodes.get(imageOrder - 1);
						ArrayNode tempArrayNode = (ArrayNode) tempNode.get("rect");
						logger.info("taskId:" + taskVO.getId() + ", getImageCrops method, imageCrops size :"
								+ tempArrayNode.size());
						return tempArrayNode;
					}

				} catch (IOException e) {
					logger.error("taskId:" + taskVO.getId() + ", getImageCrops fail, " + e.getMessage());
				}
			}
		}
		return mapper.createArrayNode();
	}
}

class AecUploadThread implements Runnable {
	private static Logger logger = Logger.getLogger(AecUploadThread.class);
	private CountDownLatch latch;
	List<File> subXmlFiles;
	Set<String> rectifyFailedList;
	Set<String> syncFailedList;
	Set<String> imageNotExistList;
	private TaskMapper taskMapper;
	private TaskImagesMapper taskImagesMapper;
	private GoodsSkuMapper goodsSkuMapper;

	public AecUploadThread(CountDownLatch count, List<File> subXmlFiles, Set<String> syncFailedList,
			Set<String> rectifyFailedList, Set<String> imageNotExistList, TaskMapper taskMapper,
			TaskImagesMapper taskImagesMapper, GoodsSkuMapper goodsSkuMapper) {
		this.latch = count;
		this.subXmlFiles = subXmlFiles;
		this.rectifyFailedList = rectifyFailedList;
		this.syncFailedList = syncFailedList;
		this.imageNotExistList = imageNotExistList;
		this.taskMapper = taskMapper;
		this.taskImagesMapper = taskImagesMapper;
		this.goodsSkuMapper = goodsSkuMapper;
	}

	public void run() {
		if (subXmlFiles != null && subXmlFiles.size() > 0) {
			try {
				for (int i = 0; i < subXmlFiles.size(); i++) {
					boolean rectifyResult = false;
					File xmlFile = subXmlFiles.get(i);
					String xmlFileName = xmlFile.getName();
					int zeIndex = xmlFileName.lastIndexOf(MarketingConstants.POINT);

					String taskImageId = "";
					if (zeIndex > 0) {
						taskImageId = xmlFileName.substring(0, zeIndex);
					}
					TaskImagesVO imagesVO = taskImagesMapper.getTaskImagesById(taskImageId);
					if (imagesVO != null) {
						TaskVO taskVO = taskMapper.getTaskById(imagesVO.getTaskId());
						ArrayNode arrayNode = parseXml(xmlFile, taskVO.getMajorType());
						rectifyResult = updateTaskGoodInfoAndRectify(arrayNode, taskVO, imagesVO.getOrderNo());
						if (rectifyResult) {
							CommonAjaxResponse response = getStore(imagesVO.getTaskId());
							if (response == null || !response.getSuccess()) {
								synchronized (latch) {
									syncFailedList.add(imagesVO.getTaskId());
								}
							}
						} else {
							synchronized (latch) {
								rectifyFailedList.add(imagesVO.getTaskId());
							}
						}
						// xmlFile.delete();
					} else {
						synchronized (latch) {
							imageNotExistList.add(taskImageId);
						}
					}
				}
			} finally {
				latch.countDown();
			}
		}
	}

	@SuppressWarnings("unchecked")
	private ArrayNode parseXml(File xmlFile, String majorType) {
		long xmlStart = System.currentTimeMillis();
		SAXReader saxReader = new SAXReader();
		ObjectMapper mapper = new ObjectMapper();
		ArrayNode arrayNode = mapper.createArrayNode();
		Document document;
		try {
			document = saxReader.read(xmlFile);

			Element root = document.getRootElement();
			List<Element> objectList = root.elements("object");
			if (objectList != null && objectList.size() > 0) {
				for (Element element : objectList) {
					String name = element.elementText("name");

					Element bndboxElement = element.element("bndbox");
					String xmin = bndboxElement.elementText("xmin");
					String ymin = bndboxElement.elementText("ymin");
					String xmax = bndboxElement.elementText("xmax");
					String ymax = bndboxElement.elementText("ymax");

					ObjectNode node = mapper.createObjectNode();

					GoodsSkuBO goodsSkuBO = new GoodsSkuBO();
					goodsSkuBO.setName(name);
					goodsSkuBO.setMajorType(majorType);

					List<GoodsSkuVO> goodsSkuVOs = goodsSkuMapper.getNewGoodsSkuListByBO(goodsSkuBO);
					if (goodsSkuVOs != null && goodsSkuVOs.size() > 0) {
						node.put("label", goodsSkuVOs.get(0).getOrder() + 1);
					} else {
						node.put("label", 0);
					}

					if (StringUtils.isNotBlank(xmin) && StringUtils.isNotBlank(xmax)) {
						node.put("x", Integer.valueOf(xmin));
						node.put("width", Integer.valueOf(xmax) - Integer.valueOf(xmin));
					}
					if (StringUtils.isNotBlank(ymin) && StringUtils.isNotBlank(ymax)) {
						node.put("y", Integer.valueOf(ymin));
						node.put("height", Integer.valueOf(ymax) - Integer.valueOf(ymin));
					}
					arrayNode.add(node);
				}
			}

		} catch (DocumentException e) {
			logger.info("parseXml fail: " + e.getMessage());
		}
		long xmlEnd = System.currentTimeMillis();
		logger.info("It takes " + (xmlEnd - xmlStart) + "ms to Parse xml:" + xmlFile.getName());
		return arrayNode;
	}

	private boolean updateTaskGoodInfoAndRectify(ArrayNode arrayNode, TaskVO taskVO, int imageOrder) {
		long totalStart = System.currentTimeMillis();
		String result = (String) taskVO.getResult();
		boolean rectifyResult = false;
		if (StringUtils.isNotBlank(result)) {
			ObjectMapper mapper = new ObjectMapper();
			ObjectNode nodeResult;
			try {
				nodeResult = (ObjectNode) mapper.readTree(result);
				if (nodeResult.findValue("goodInfo") != null) {
					ArrayNode jsonNodes = (ArrayNode) nodeResult.findValue("goodInfo");
					ObjectNode jsonNode = (ObjectNode) jsonNodes.get(imageOrder - 1);
					// JsonNode rectJsonNode = jsonNode.get("rect");
					jsonNode.set("rect", arrayNode);
					taskVO.setResult(nodeResult.toString());
					long updateTaskStart = System.currentTimeMillis();
					int updateResult = taskMapper.updateTask(taskVO);
					long updateTaskEnd = System.currentTimeMillis();
					logger.info("updateTaskGoodInfoAndRectify method update task, task id is " + taskVO.getId()
							+ " use " + (updateTaskEnd - updateTaskStart));

					if (updateResult > 0) {
						long rectifyStart = System.currentTimeMillis();
						CommonAjaxResponse ajaxResponse = rectify(taskVO.getId());
						long rectifyEnd = System.currentTimeMillis();
						logger.info("updateTaskGoodInfoAndRectify method rectify task, task id is " + taskVO.getId()
								+ " use " + (rectifyEnd - rectifyStart));

						if (ajaxResponse != null && ajaxResponse.getSuccess()) {
							rectifyResult = true;
						} else {
							// jsonNode.set("rect", rectJsonNode);
							// taskVO.setResult(nodeResult.toString());
							// taskMapper.updateTask(taskVO);
						}
					}
					logger.info("taskId:" + taskVO.getId() + ", aecUpload result: " + updateResult);
				}

			} catch (IOException e) {
				logger.error("taskId:" + taskVO.getId() + ", aecUpload fail, " + e.getMessage());
			}
		}
		long totalEnd = System.currentTimeMillis();
		logger.info("updateTaskGoodInfoAndRectify method, task id is " + taskVO.getId() + " total use "
				+ (totalEnd - totalStart));
		return rectifyResult;
	}

	private CommonAjaxResponse getStore(String taskId) {
		MarketingGetStoreRequestParam param = new MarketingGetStoreRequestParam();
		param.setTaskId(taskId);
		String tokenStr = taskId + MarketingConstants.INNOVISION;
		// MessageDigest messageDigest = MessageDigest.getInstance("MD5");
		// messageDigest.update(tokenStr.getBytes());
		// param.setToken(new BigInteger(1,
		// messageDigest.digest()).toString(16));

		param.setToken(encryptionStr(tokenStr, "MD5"));

		CommonAjaxResponse result = MarketingAPI.getStore(param);
		return result;
	}

	private CommonAjaxResponse rectify(String taskId) {
		TaskVO taskVO = taskMapper.getTaskById(taskId);
		MarketingRectifyRequestParam param = new MarketingRectifyRequestParam();
		param.setTaskId(taskId);
		param.setMajorType(taskVO.getMajorType());
		CommonAjaxResponse result = MarketingAPI.rectify(param);
		return result;
	}

	private String bytesConvertToHexString(byte[] bytes) {
		StringBuffer sb = new StringBuffer();
		for (byte aByte : bytes) {
			String s = Integer.toHexString(0xff & aByte);
			if (s.length() == 1) {
				sb.append("0" + s);
			} else {
				sb.append(s);
			}
		}
		return sb.toString();
	}

	private byte[] encryptionStrBytes(String str, String algorithm) {
		byte[] bytes = null;
		try {
			MessageDigest md = MessageDigest.getInstance(algorithm);
			md.update(str.getBytes());
			bytes = md.digest();
		} catch (NoSuchAlgorithmException e) {
			System.out.println("加密算法: " + algorithm + " 不存在: ");
		}
		return null == bytes ? null : bytes;
	}

	private String encryptionStr(String str, String algorithm) {
		// 加密之后所得字节数组
		byte[] bytes = encryptionStrBytes(str, algorithm);
		return bytesConvertToHexString(bytes);
	}
}