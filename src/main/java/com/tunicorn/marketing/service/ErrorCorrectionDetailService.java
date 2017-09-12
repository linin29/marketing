package com.tunicorn.marketing.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tunicorn.marketing.bo.CropBO;
import com.tunicorn.marketing.mapper.ErrorCorrectionDetailMapper;
import com.tunicorn.marketing.vo.ErrorCorrectionDetailVO;

@Service
public class ErrorCorrectionDetailService {
	private static Logger logger = Logger.getLogger(ErrorCorrectionDetailService.class);

	@Autowired
	private ErrorCorrectionDetailMapper errorCorrectionDetailMapper;

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

	public List<CropBO> getTaskMarkImageCrops(String imageId, Integer imageOrderNo) {
		logger.info("params of getTaskMarkImageCrops method: imageId:" + imageId + ",imageOrderNo:" + imageOrderNo);
		List<CropBO> cropBOs = new ArrayList<CropBO>();
		ErrorCorrectionDetailVO correctionDetailVO = errorCorrectionDetailMapper
				.getErrorCorrectionDetailByImageId(imageId);
		if (correctionDetailVO != null && StringUtils.isNotBlank(correctionDetailVO.getResult())) {
			String result = correctionDetailVO.getResult();
			ObjectMapper mapper = new ObjectMapper();
			try {
				ArrayNode jsonNodes = (ArrayNode) mapper.readTree(result);
				;
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
				logger.error("taskId:" + imageId + ", getTaskMarkImageCrops method 获取getTaskMarkImageCrops失败, " + e.getMessage());
			}
		}

		return cropBOs;
	}
}
