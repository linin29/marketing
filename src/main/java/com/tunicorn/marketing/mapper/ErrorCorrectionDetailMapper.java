package com.tunicorn.marketing.mapper;

import java.util.List;

import com.tunicorn.marketing.vo.ErrorCorrectionDetailVO;

public interface ErrorCorrectionDetailMapper {

	public int createErrorCorrectionDetail(ErrorCorrectionDetailVO errorCorrectionDetailVO);
	
	public void batchDeleteErrorCorrectionDetail(List<ErrorCorrectionDetailVO> correctionDetailVOs);
}
