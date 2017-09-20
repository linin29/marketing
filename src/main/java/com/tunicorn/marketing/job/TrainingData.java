package com.tunicorn.marketing.job;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.tunicorn.marketing.bo.AnnotationBO;
import com.tunicorn.marketing.service.TrainingDataService;
import com.tunicorn.marketing.service.TrainingStatisticsService;
import com.tunicorn.marketing.utils.ConfigUtils;
import com.tunicorn.marketing.utils.FTPTransferUtils;
import com.tunicorn.marketing.vo.TrainingDataVO;
import com.tunicorn.marketing.vo.TrainingStatisticsVO;

@Component
@EnableScheduling
public class TrainingData {
	private static Logger logger = Logger.getLogger(TrainingData.class);
	private static final int RETRIEVE_NUMBER = Integer.parseInt(ConfigUtils.getInstance().getConfigValue("training.data.number"));
	@Autowired
	TrainingDataService trainingDataService;
	@Autowired
	TrainingStatisticsService trainingStatisticsService;
	//invoke for each 10 minutes
	@Scheduled(cron = "0 */10 * * * ? ")
    public void transferFiles() {
		logger.info("Transfer files to FTP server timely...");
		List<TrainingDataVO> data = retrieveTraingData();
		if (data != null && data.size() > 0) {
			for (TrainingDataVO trainingData : data) {
				logger.info("Data ID:" + trainingData.getId());
			}
			//Construct annotations
			List<AnnotationBO> annotations = constructAnnotations(data);
			logger.info("Total size:" + annotations.size());
			//Transfer files
			List<AnnotationBO> failedAnnotations = FTPTransferUtils.transferFiles(annotations);
			logger.info("Failed size:" + failedAnnotations.size());
			//Reset Flag to 0 for the failed annotations
			if (failedAnnotations != null && failedAnnotations.size() > 0) {
				batchResetFailedFlag(failedAnnotations);
			}
			//Delete successful annotations
			annotations.removeAll(failedAnnotations);
			if (annotations != null && annotations.size() > 0) {
				deleteSuccessfulAnnotations(annotations);
				//Update successfully transferred count per major type
				updateTrainingCount(annotations);
			}
		}
	}
	
	private List<TrainingDataVO> retrieveTraingData () {
		List<TrainingDataVO> data = trainingDataService.getAllNeedHandleTrainingData(RETRIEVE_NUMBER);
		if (data != null && data.size() > 0) {
			//Set flag to 1
			batchSetFlag(data, 1);
		}
		return data;
	}
	
	/**
	 * 更新统计表数据
	 * @param annotations
	 */
	private void updateTrainingCount (List<AnnotationBO> annotations) {
		Map<String, Integer> typeCountMapping = new HashMap<String, Integer>();
		for (AnnotationBO annotation : annotations) {
			String majorType = annotation.getType();
			if (typeCountMapping.containsKey(majorType)) {
				typeCountMapping.put(majorType, (typeCountMapping.get(majorType) + 1));
			} else {
				typeCountMapping.put(majorType, 1);
			}
		}
		
		for (String majorType : typeCountMapping.keySet()) {
			updateTraingStatistics(majorType, typeCountMapping.get(majorType));
		}
	}
	
	private void updateTraingStatistics (String majorType, int count) {
		//Retrieve current count
		TrainingStatisticsVO stat = trainingStatisticsService.getTrainingStatisticsByType(majorType);
		if (stat == null) {
			stat = new TrainingStatisticsVO();
			stat.setMajorType(majorType);
			stat.setCount(count);
			trainingStatisticsService.createTrainingStatistics(stat);
		} else {
			int currentCount = stat.getCount() + count;
			stat.setCount(currentCount);
			trainingStatisticsService.updateTrainingStatistics(stat);
		}
	}
	/**
	 * 批量reset失败的flag
	 * @param annotations
	 */
	private void batchResetFailedFlag (List<AnnotationBO> annotations) {
		List<TrainingDataVO> traingData = new ArrayList<TrainingDataVO>();
		for (AnnotationBO annotation : annotations) {
			TrainingDataVO data = new TrainingDataVO();
			data.setId(annotation.getId());
			//data.setFlag(0);
			traingData.add(data);
		}
		batchSetFlag(traingData, 0);
	}
	/**
	 * 删除所有成功
	 * @param annotations
	 */
	private void deleteSuccessfulAnnotations (List<AnnotationBO> annotations) {
		batchDeleteTrainingData(annotations);
		deleteFiles(annotations);
	}
	
	private void deleteFiles (List<AnnotationBO> annotations) {
		for (AnnotationBO annotation : annotations) {
			File image = annotation.getImage();
			File xml = annotation.getAnnotationXML();
			if (image.exists()) {
				image.delete();
			}
			if (xml.exists()) {
				xml.delete();
			}
		}
	}
	
	private void batchDeleteTrainingData (List<AnnotationBO> annotations) {
		List<TrainingDataVO> traingData = new ArrayList<TrainingDataVO>();
		for (AnnotationBO annotation : annotations) {
			TrainingDataVO data = new TrainingDataVO();
			data.setId(annotation.getId());
			traingData.add(data);
		}
		trainingDataService.batchDeleteTrainingData(traingData);
	}
	
	private List<AnnotationBO> constructAnnotations (List<TrainingDataVO> trainingDataList) {
		List<AnnotationBO> annotations = new ArrayList<AnnotationBO>();
		for (TrainingDataVO data : trainingDataList) {
			AnnotationBO annotation = new AnnotationBO();
			annotation.setId(data.getId());
			if (StringUtils.isEmpty(data.getFilePath()) || StringUtils.isEmpty(data.getImagePath())) {
				continue;
			}
			File imageFile = new File(data.getImagePath());
			File annotationFile = new File(data.getFilePath());
			if (!imageFile.exists() || !annotationFile.exists()) {
				continue;
			}
			annotation.setType(data.getMajorType());
			annotation.setImage(imageFile);
			annotation.setAnnotationXML(annotationFile);
			annotations.add(annotation);
		}
		return annotations;
	}
	
	private void batchSetFlag (List<TrainingDataVO> trainingDataList, int flag) {
		for (TrainingDataVO data : trainingDataList) {
			data.setFlag(flag);
		}
		trainingDataService.batchUpdateFlag(trainingDataList);
	}
}
