package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.vo.TrainingStatisticsVO;

public interface TrainingStatisticsMapper {

	public int createTrainingStatistics(TrainingStatisticsVO trainingStatisticsVO);

	public int updateTrainingStatistics(TrainingStatisticsVO trainingStatisticsVO);
	
	@Delete("delete from training_statistics where id=#{id}")
	public void deleteTrainingStatisticsById(int id);

	@Select("Select id, major_type as majorType, count from training_statistics where major_type=#{majorType}")
	public TrainingStatisticsVO getTrainingStatisticsByType(String majorType);
	
	@Select("Select id, major_type as majorType, count from training_statistics for update")
	public List<TrainingStatisticsVO> getTrainingStatisticsList();
}
