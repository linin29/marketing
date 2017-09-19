package com.tunicorn.marketing.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.tunicorn.marketing.bo.ServiceResponseBO;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.mapper.TrainingDataMapper;
import com.tunicorn.marketing.vo.TrainingDataVO;

@Service
public class TrainingDataService {
	private static Logger logger = Logger.getLogger(TrainingDataService.class);

	@Autowired
	private TrainingDataMapper trainingDataMapper;

	public int createTrainingData(TrainingDataVO trainingDataVO) {
		return trainingDataMapper.createTrainingData(trainingDataVO);
	}

	public void batchDeleteTrainingData(List<TrainingDataVO> trainingDataVOs) {
		trainingDataMapper.batchDeleteTrainingData(trainingDataVOs);
	}

	public int updateTrainingData(TrainingDataVO trainingDataVO) {
		return trainingDataMapper.updateTrainingData(trainingDataVO);
	}

	public List<TrainingDataVO> getAllNeedHandleTrainingData(int retrieveNumber) {
		return trainingDataMapper.getAllNeedHandleTrainingData(retrieveNumber);
	}

	public void batchUpdateFlag(List<TrainingDataVO> trainingDataList) {
		trainingDataMapper.batchUpdateFlag(trainingDataList);
	}

	@Transactional
	public ServiceResponseBO upload(List<MultipartFile> zipFiles) {

		/*
		 * String basePath = String.format("%s%s%s%s",
		 * com.tunicorn.util.ConfigUtils.getInstance().getConfigValue(
		 * "storage.private.basePath"),
		 * ConfigUtils.getInstance().getConfigValue("marketing.image.root.path")
		 * , File.separator, MarketingConstants.UPLOAD_PATH);
		 */

		String basePath = "C:\\mnt\\storage4\\marketing";
		try {
			if (zipFiles != null && zipFiles.size() > 0) {
				long startTime = System.currentTimeMillis();
				Map<String, String> xmlFileMap;
				Map<String, String> imageFileMap;
				List<TrainingDataVO> trainingDataVOs = new ArrayList<TrainingDataVO>();
				for (MultipartFile zipFile : zipFiles) {
					xmlFileMap = new HashMap<String, String>();
					imageFileMap = new HashMap<String, String>();
					String originalFileName = zipFile.getOriginalFilename();
					int lastPointIndex = originalFileName.lastIndexOf(MarketingConstants.POINT);

					File majorTypeDir = new File(
							basePath + File.separator + originalFileName.substring(0, lastPointIndex));
					if (!majorTypeDir.exists()) {
						majorTypeDir.mkdirs();
					}
					ZipInputStream zin = new ZipInputStream(zipFile.getInputStream(),
							Charset.forName(MarketingConstants.GBK));
					ZipEntry ze;
					while ((ze = zin.getNextEntry()) != null) {
						if (!ze.isDirectory()) {
							String fileName = ze.getName();
							String fileBasePath = basePath + File.separator + ze.getName();
							int lastXmlPointIndex = fileName.lastIndexOf(MarketingConstants.POINT);
							int lastXmlSlashIndex = fileName.lastIndexOf("/");
							String fileRealName = fileName.substring(lastXmlSlashIndex + 1, lastXmlPointIndex);

							if (fileName.contains(".xml")) {
								xmlFileMap.put(fileRealName, fileBasePath);
							} else {
								imageFileMap.put(fileRealName, fileBasePath);
							}
						}
					}
					zin.closeEntry();
					for (String xmlKey : xmlFileMap.keySet()) {
						if (imageFileMap.containsKey(xmlKey)) {
							String imagePath = imageFileMap.get(xmlKey);
							String xmlFilePath = xmlFileMap.get(xmlKey);

							File imagefile = new File(imagePath);
							File xmlfile = new File(xmlFilePath);

							FileUtils.writeStringToFile(imagefile, StringUtils.EMPTY);
							FileUtils.writeStringToFile(xmlfile, StringUtils.EMPTY);
							FileOutputStream fos = new FileOutputStream(imagefile);

							int len = 0;
							byte[] buffer = new byte[4096];
							while ((len = zin.read(buffer)) != -1) {
								fos.write(buffer, 0, len);
							}
							fos.close();
							fos = new FileOutputStream(xmlfile);
							len = 0;
							buffer = new byte[4096];
							while ((len = zin.read(buffer)) != -1) {
								fos.write(buffer, 0, len);
							}
							fos.close();

							TrainingDataVO trainingDataVO = new TrainingDataVO();
							trainingDataVO.setFilePath(xmlFileMap.get(xmlKey));
							trainingDataVO.setImagePath(imagePath);
							trainingDataVO.setMajorType(originalFileName.substring(0, lastPointIndex));
							trainingDataVOs.add(trainingDataVO);
						}
					}
				}
				this.batchInsertTrainingData(trainingDataVOs);
				long endTime = System.currentTimeMillis();
				logger.info("time consuming : " + (endTime - startTime));
			}

		} catch (IOException e) {
			logger.error("upload zip file fail, " + e.getMessage());
			return new ServiceResponseBO(false, "marketing_save_upload_file_error");
		}
		return new ServiceResponseBO(null);
	}

	private void batchInsertTrainingData(List<TrainingDataVO> trainingDataVOs) {
		int batchSize = MarketingConstants.BATCH_INSERT_SIZE;
		int dataSize = trainingDataVOs.size();
		int threadNumber = dataSize / batchSize;
		if ((dataSize % batchSize) > 0) {
			threadNumber++;
		}
		List<TrainingDataVO> subTrainingDataVOs = null;
		for (int index = 0; index < threadNumber; index++) {
			if (index < (threadNumber - 1)) {
				subTrainingDataVOs = trainingDataVOs.subList(index * batchSize, (index + 1) * batchSize);
			} else {
				subTrainingDataVOs = trainingDataVOs.subList(index * batchSize, dataSize);
			}
			SyncBatchInsertTrainingDataThread thread = new SyncBatchInsertTrainingDataThread(this,
					new Vector<TrainingDataVO>(subTrainingDataVOs));
			new Thread(thread).start();
		}
	}

	public TrainingDataMapper getTrainingDataMapper() {
		return trainingDataMapper;
	}
}

class SyncBatchInsertTrainingDataThread implements Runnable {
	private TrainingDataMapper trainingDataMapper;
	private Vector<TrainingDataVO> trainingDataVOs;

	public SyncBatchInsertTrainingDataThread(TrainingDataService trainingDataService,
			Vector<TrainingDataVO> trainingDataVOs) {
		this.trainingDataMapper = trainingDataService.getTrainingDataMapper();
		this.trainingDataVOs = trainingDataVOs;
	}

	@Override
	public void run() {
		trainingDataMapper.batchInsertTrainingData(trainingDataVOs);
	}
}
