package com.tunicorn.marketing.job;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.tunicorn.marketing.bo.AnnotationBO;
import com.tunicorn.marketing.service.TrainingDataService;
import com.tunicorn.marketing.utils.FTPTransferUtils;
import com.tunicorn.marketing.vo.TrainingDataVO;

@Component
@EnableScheduling
public class TrainingData {
	private static final int RETRIEVE_NUMBER = 200;
	@Autowired
	TrainingDataService trainingDataService;
	//每隔10分钟调用一次此方法
	@Scheduled(cron = "0 */10 * * * ? ")
    public void transferFiles() {
		System.out.println("Transfer files to FTP server timely...");
		//Set flag to 1
		List<TrainingDataVO> data = new ArrayList<TrainingDataVO>();
		synchronized (this) {
			data = trainingDataService.getAllNeedHandleTrainingData(RETRIEVE_NUMBER);
			batchSetFlag(data, 1);
		}
		//Construct annotations
		List<AnnotationBO> annotations = constructAnnotations(data);
		//Transfer files
		List<AnnotationBO> failedAnnotations = FTPTransferUtils.transferFiles(annotations);
		//Reset Flag to 0 for the failed annotations
		batchResetFailedFlag(failedAnnotations);
		//Delete successful annotations
		annotations.removeAll(failedAnnotations);
		deleteSuccessfulAnnotations(annotations);
		//Update successfully transferred count per major type
		updateTrainingCount(annotations);
		
	}
	
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
		
		synchronized (this) {
			for (String majorType : typeCountMapping.keySet()) {
				//Retrieve current count
				//Update with added count
			}
		}
	}
	
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
	
	private void deleteSuccessfulAnnotations (List<AnnotationBO> annotations) {
		batchDeleteTrainingData(annotations);
		deleteFiles(annotations);
	}
	
	private void deleteFiles (List<AnnotationBO> annotations) {
		for (AnnotationBO annotation : annotations) {
			annotation.getImage().deleteOnExit();
			annotation.getAnnotationXML().deleteOnExit();
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
			annotation.setType(data.getMajorType());
			annotation.setImage(new File(data.getImagePath()));
			annotation.setAnnotationXML(new File(data.getFilePath()));
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
