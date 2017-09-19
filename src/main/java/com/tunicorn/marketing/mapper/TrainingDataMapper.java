package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.vo.TrainingDataVO;

public interface TrainingDataMapper {

	public int createTrainingData(TrainingDataVO trainingDataVO);

	public void batchDeleteTrainingData(List<TrainingDataVO> trainingDataVOs);

	public int updateTrainingData(TrainingDataVO trainingDataVO);

	@Select("Select id, major_type as majorType, image_path as imagePath, file_path as filePath from training_data "
			+ "where flag=0 order by major_type limit #{retrieveNumber}")
	public List<TrainingDataVO> getAllNeedHandleTrainingData(int retrieveNumber);
	
	public void batchUpdateFlag(List<TrainingDataVO> trainingDataList);
}
