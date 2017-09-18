package com.tunicorn.marketing.mapper;

import java.util.List;

import com.tunicorn.marketing.vo.TrainingDataVO;

public interface TrainingDataMapper {

	public int createTrainingData(TrainingDataVO trainingDataVO);

	public void batchDeleteTrainingData(List<TrainingDataVO> trainingDataVOs);

	public int updateTrainingData(TrainingDataVO trainingDataVO);

}
