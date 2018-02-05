package com.tunicorn.marketing.service;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tunicorn.marketing.mapper.ApiCallingSummaryMapper;
import com.tunicorn.marketing.vo.ApiCallingSummaryVO;

@Service
public class CallingService {

	@Autowired
	private ApiCallingSummaryMapper apiCallingSummaryMapper;

	public List<String> getCallingExportData(String projectId, String majorType, String startTime, String endTime,
			String userName) {
		List<String> result = new ArrayList<String>();
		ApiCallingSummaryVO apiCallingSummaryVO = new ApiCallingSummaryVO();
		if (StringUtils.isNotBlank(projectId)) {
			apiCallingSummaryVO.setProjectId(projectId);
		}
		apiCallingSummaryVO.setMajorType(majorType);
		apiCallingSummaryVO.setUserName(userName);
		if (StringUtils.isNotBlank(startTime)) {
			apiCallingSummaryVO.setStartDate(startTime);
		}
		if (StringUtils.isNotBlank(endTime)) {
			apiCallingSummaryVO.setEndDate(endTime);
		}
		List<ApiCallingSummaryVO> apiCallingSummarys = apiCallingSummaryMapper
				.getApiCallingSummaryListByVO(apiCallingSummaryVO);
		if (apiCallingSummarys != null && apiCallingSummarys.size() > 0) {
			String goodSkuHead = getDataHead(majorType);
			result.add(goodSkuHead);
			for (ApiCallingSummaryVO apiCallingSummary : apiCallingSummarys) {
				StringBuffer taskBodyBuffer = new StringBuffer();
				taskBodyBuffer.append(apiCallingSummary.getProjectId()).append(",")
						.append(apiCallingSummary.getProject().getTypeStr()).append(",")
						.append(apiCallingSummary.getMajorTypeDesc()).append(",").append(apiCallingSummary.getApiName())
						.append(",").append(apiCallingSummary.getApiMethod()).append(",")
						.append(apiCallingSummary.getUserName()).append(",").append(apiCallingSummary.getCallingDay())
						.append(",").append(apiCallingSummary.getCallingTimes());
				result.add(taskBodyBuffer.toString());
			}
		}
		return result;
	}

	private String getDataHead(String majorType) {
		StringBuffer result = new StringBuffer();

		return result.append("项目编码").append(",项目类型").append(",品类").append(",调用API").append(",调用方法").append(",用户")
				.append(",调用日期").append(",调用次数").toString();
	}
}
