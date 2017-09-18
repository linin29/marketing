package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.vo.TrainingDataVO;

public interface TrainingDataMapper {

	public int createTrainingData(TrainingDataVO trainingDataVO);

	public void batchDeleteTrainingData(List<TrainingDataVO> trainingDataVOs);

	public int updateTrainingData(TrainingDataVO trainingDataVO);

	@Results({
	    @Result(property = "majorType", column = "major_type"),
	    @Result(property = "imageId", column = "image_id"),
	    @Result(property = "filePath", column = "file_path"),
	    @Result(property = "imagePath", column = "image_path")
	})
	@Select("select id, major_type, image_id, file_path, image_path from training_data "
			+ "where image_id=#{imageId} and status='active'")
	public TrainingDataVO getTrainingDataByImageId(@Param("imageId") String imageId);
}
