package com.tunicorn.marketing.service;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.tunicorn.marketing.bo.ServiceResponseBO;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.mapper.GoodsSkuMapper;
import com.tunicorn.marketing.mapper.TaskImagesMapper;
import com.tunicorn.marketing.mapper.TrainingDataMapper;
import com.tunicorn.marketing.utils.ConfigUtils;
import com.tunicorn.marketing.vo.TaskImagesVO;
import com.tunicorn.marketing.vo.TrainingDataVO;

@Service
public class TrainingDataService {
	private static Logger logger = Logger.getLogger(TrainingDataService.class);

	@Autowired
	private TrainingDataMapper trainingDataMapper;
	@Autowired
	private GoodsSkuMapper goodsSkuMapper;
	@Autowired
	private TaskImagesMapper taskImagesMapper;

	public int createTrainingData(TrainingDataVO trainingDataVO) {
		return trainingDataMapper.createTrainingData(trainingDataVO);
	}

	public void batchDeleteTrainingData(List<TrainingDataVO> trainingDataVOs) {
		trainingDataMapper.batchDeleteTrainingData(trainingDataVOs);
	}

	public int updateTrainingData(TrainingDataVO trainingDataVO) {
		return trainingDataMapper.updateTrainingData(trainingDataVO);
	}

	public List<TrainingDataVO> getAllNeedHandleTrainingData (int retrieveNumber) {
		return trainingDataMapper.getAllNeedHandleTrainingData(retrieveNumber);
	}
	
	public void batchUpdateFlag (List<TrainingDataVO> trainingDataList) {
		trainingDataMapper.batchUpdateFlag(trainingDataList);
	}
	
	@Transactional
	public ServiceResponseBO upload(List<MultipartFile> zipFiles) {
		String basePath = String.format("%s%s%s%s",
				com.tunicorn.util.ConfigUtils.getInstance().getConfigValue("storage.private.basePath"),
				ConfigUtils.getInstance().getConfigValue("marketing.image.root.path"), File.separator,
				MarketingConstants.UPLOAD_PATH);
		// String basePath = "D:\\";
		try {
			if (zipFiles != null && zipFiles.size() > 0) {
				for (MultipartFile zipFile : zipFiles) {
					String originalFileName = zipFile.getOriginalFilename();
					int lastPointIndex = originalFileName.lastIndexOf(MarketingConstants.POINT);
					File imageFileDir = new File(
							basePath + File.separator + originalFileName.substring(0, lastPointIndex));
					if (!imageFileDir.exists()) {
						imageFileDir.mkdirs();
					}
					ZipInputStream zin = new ZipInputStream(zipFile.getInputStream());
					ZipEntry ze;
					while ((ze = zin.getNextEntry()) != null) {
						if (!ze.isDirectory()) {
							String xmlFilePath;
							String imageFilePath;
							String fileName = ze.getName();
							String fileBasePath = basePath + File.separator + ze.getName();
							if(fileName.contains(".xml")){
								ZipEntry temoZe;
								while ((temoZe = zin.getNextEntry()) != null) {
									
								}
								if (StringUtils.isNotBlank(fileName)) {
									if (fileName.contains(".xml")) {
										xmlFilePath = fileBasePath;
									} else {
										imageFilePath = fileBasePath;
									}
								}
								File file = new File(basePath + File.separator + ze.getName());
								if (!file.exists()) {
									file.createNewFile();
								}
								FileOutputStream fos = new FileOutputStream(file);

								int len = 0;
								while ((len = zin.read()) != -1) {
									// fos.write(len);
								}
								fos.close();
								TaskImagesVO taskImagesVO = new TaskImagesVO();

								taskImagesVO.setId(
										(Long.toHexString(new Date().getTime()) + RandomStringUtils.randomAlphanumeric(13))
												.toLowerCase());
								int zeIndex = ze.getName().indexOf("/");
								String taskImageName = "";
								if (zeIndex > 0) {
									taskImageName = ze.getName().substring(zeIndex + 1);
								} else {
									taskImageName = ze.getName();
								}
								TrainingDataVO trainingDataVO = new TrainingDataVO();
								trainingDataVO.setId(
										(Long.toHexString(new Date().getTime()) + RandomStringUtils.randomAlphanumeric(13))
												.toLowerCase());
								// trainingDataVO.setFilePath(xmlFilePath);
								// trainingDataVO.setImagePath(imageFilenameTemp);
								// trainingDataVO.setMajorType(cropBO.getMajorType());
								// trainingDataMapper.createTrainingData(trainingDataVO);
							}
						}
					}
					zin.closeEntry();
				}
			}

		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

}
