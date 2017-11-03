package com.tunicorn.marketing.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tunicorn.marketing.mapper.TrainingStatisticsMapper;
import com.tunicorn.marketing.vo.TrainingStatisticsVO;

@Service
public class TrainingStatisticsService {
	@Autowired
	private TrainingStatisticsMapper trainingStatisticsMapper;

	public int createTrainingStatistics(TrainingStatisticsVO trainingStatisticsVO) {
		return trainingStatisticsMapper.createTrainingStatistics(trainingStatisticsVO);
	}

	public int updateTrainingStatistics(TrainingStatisticsVO trainingStatisticsVO) {
		return trainingStatisticsMapper.updateTrainingStatistics(trainingStatisticsVO);
	}

	public TrainingStatisticsVO getTrainingStatisticsByType (String majorType) {
		return trainingStatisticsMapper.getTrainingStatisticsByType(majorType);
	}
	
	public List<TrainingStatisticsVO> getTrainingStatisticsList () {
		return trainingStatisticsMapper.getTrainingStatisticsList();
	}
	
	public void deleteTrainingStatisticsById (int id) {
		trainingStatisticsMapper.deleteTrainingStatisticsById(id);
	}
	
}
