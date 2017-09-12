package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.vo.ErrorCorrectionDetailVO;

public interface ErrorCorrectionDetailMapper {

	public int createErrorCorrectionDetail(ErrorCorrectionDetailVO errorCorrectionDetailVO);

	public void batchDeleteErrorCorrectionDetail(List<ErrorCorrectionDetailVO> correctionDetailVOs);

	public int updateErrorCorrectionDetail(ErrorCorrectionDetailVO errorCorrectionDetailVO);

	@Results({
	    @Result(property = "majorType", column = "major_type"),
	    @Result(property = "imageId", column = "image_id"),
	    @Result(property = "filePath", column = "file_path"),
	    @Result(property = "imagePath", column = "image_path")
	})
	@Select("select id, major_type, result, image_id, file_path, image_path from error_correction_detail "
			+ "where image_id=#{imageId} and status='active'")
	public ErrorCorrectionDetailVO getErrorCorrectionDetailByImageId(@Param("imageId") String imageId);
}
