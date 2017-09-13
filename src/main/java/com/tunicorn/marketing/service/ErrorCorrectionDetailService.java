package com.tunicorn.marketing.service;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.imageio.ImageIO;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tunicorn.marketing.bo.CropBO;
import com.tunicorn.marketing.bo.GoodsSkuBO;
import com.tunicorn.marketing.bo.MarkImageCropBO;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.mapper.ErrorCorrectionDetailMapper;
import com.tunicorn.marketing.mapper.GoodsSkuMapper;
import com.tunicorn.marketing.mapper.TaskImagesMapper;
import com.tunicorn.marketing.utils.ConfigUtils;
import com.tunicorn.marketing.vo.ErrorCorrectionDetailVO;
import com.tunicorn.marketing.vo.GoodsSkuVO;
import com.tunicorn.marketing.vo.TaskImagesVO;

@Service
public class ErrorCorrectionDetailService {
	private static Logger logger = Logger.getLogger(ErrorCorrectionDetailService.class);

	@Autowired
	private ErrorCorrectionDetailMapper errorCorrectionDetailMapper;
	@Autowired
	private GoodsSkuMapper goodsSkuMapper;
	@Autowired
	private TaskImagesMapper taskImagesMapper;

	public int createErrorCorrectionDetail(ErrorCorrectionDetailVO errorCorrectionDetailVO) {
		return errorCorrectionDetailMapper.createErrorCorrectionDetail(errorCorrectionDetailVO);
	}

	public void batchDeleteErrorCorrectionDetail(List<ErrorCorrectionDetailVO> correctionDetailVOs) {
		errorCorrectionDetailMapper.batchDeleteErrorCorrectionDetail(correctionDetailVOs);
	}

	public int updateErrorCorrectionDetail(ErrorCorrectionDetailVO errorCorrectionDetailVO) {
		return errorCorrectionDetailMapper.updateErrorCorrectionDetail(errorCorrectionDetailVO);
	}

	public ErrorCorrectionDetailVO getErrorCorrectionDetailByImageId(String imageId) {
		return errorCorrectionDetailMapper.getErrorCorrectionDetailByImageId(imageId);
	}

	public void saveMarkImageCrop(MarkImageCropBO markImageCropBO) {
		logger.info("params of saveMarkImageCrop method: markImageCropBO:" + markImageCropBO.toString());
		String imageId = markImageCropBO.getImageId();
		if (StringUtils.isNotBlank(imageId)) {
			TaskImagesVO taskImagesVO = new TaskImagesVO();
			taskImagesVO.setId(markImageCropBO.getImageId());
			taskImagesVO.setResult(markImageCropBO.getImageCrop().toString());
			taskImagesMapper.updateTaskImage(taskImagesVO);
			
			ErrorCorrectionDetailVO correctionDetailVO = errorCorrectionDetailMapper
					.getErrorCorrectionDetailByImageId(markImageCropBO.getImageId());
			if (correctionDetailVO == null || correctionDetailVO.getFlag() == 1) {
				correctionDetailVO = new ErrorCorrectionDetailVO();
				correctionDetailVO
						.setId((Long.toHexString(new Date().getTime()) + RandomStringUtils.randomAlphanumeric(13))
								.toLowerCase());
				correctionDetailVO.setImageId(markImageCropBO.getImageId());
				correctionDetailVO.setFilePath(markImageCropBO.getFilePath());
				correctionDetailVO.setImageId(markImageCropBO.getImageId());
				correctionDetailVO.setImagePath(markImageCropBO.getImagePath());
				correctionDetailVO.setMajorType(markImageCropBO.getMajorType());
				this.createErrorCorrectionDetail(correctionDetailVO);
			}
		} else {
			logger.info("imageId param of saveMarkImageCrop method is null");
		}
	}

	public List<CropBO> getTaskMarkImageCrops(String imageId) {
		logger.info("params of getTaskMarkImageCrops method: imageId:" + imageId);
		List<CropBO> cropBOs = new ArrayList<CropBO>();
		TaskImagesVO taskImagesVO = taskImagesMapper.getTaskImagesById(imageId);
		if (StringUtils.isNotBlank(taskImagesVO.getResult())) {
			String result = taskImagesVO.getResult();
			ObjectMapper mapper = new ObjectMapper();
			try {
				ArrayNode jsonNodes = (ArrayNode) mapper.readTree(result);
				if (jsonNodes != null && jsonNodes.size() > 0) {
					for (int i = 0; i < jsonNodes.size(); i++) {
						ObjectNode oNode = (ObjectNode) jsonNodes.get(i);
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
			} catch (IOException e) {
				logger.error("imageId:" + imageId + ", getTaskMarkImageCrops method 获取getTaskMarkImageCrops失败, "
						+ e.getMessage());
			}
		}

		return cropBOs;
	}

	public void generateFile(MarkImageCropBO cropBO) {
		String xmlFilePath = String.format("%s%s%s%s%s%s%s%s",
				com.tunicorn.util.ConfigUtils.getInstance().getConfigValue("storage.private.basePath"),
				ConfigUtils.getInstance().getConfigValue("marketing.image.root.path"), File.separator,
				cropBO.getMajorType(), File.separator, MarketingConstants.CROP_TXT_PATH, File.separator,
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
				cropBO.setFilePath(xmlFilePath);
				cropBO.setImagePath(imageFilenameTemp);
			} catch (IOException e) {
				logger.error("imageId:" + cropBO.getImageId() + ", copy file fail, " + e.getMessage());
			}
		}
	}

	private void generateXmlFile(MarkImageCropBO cropBO, String xmlFilePath, int width, int height) {
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
				goodsSkuBO.setOrder(nodeResult.get("label").asInt() - 1);
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
			// 设置声明之后不换行
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
}
