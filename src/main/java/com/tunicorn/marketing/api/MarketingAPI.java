package com.tunicorn.marketing.api;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tunicorn.common.Constant;
import com.tunicorn.common.api.Message;
import com.tunicorn.common.api.param.IRequestParam;
import com.tunicorn.marketing.api.param.MarketingIdentifyMockRequestParam;
import com.tunicorn.marketing.api.param.MarketingIdentifyRequestParam;
import com.tunicorn.marketing.api.param.MarketingPullDataRequestParam;
import com.tunicorn.marketing.api.param.MarketingRectifyRequestParam;
import com.tunicorn.marketing.api.param.MarketingStitcherRequestParam;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.utils.ConfigUtils;
import com.tunicorn.util.HttpClientUtils;
import com.tunicorn.util.JsonUtil;
import com.tunicorn.util.MessageUtils;

public class MarketingAPI {
	private static Logger logger = Logger.getLogger(MarketingAPI.class);

	public static CommonAjaxResponse stitcher(MarketingStitcherRequestParam params) {
		return callCoreService(MarketingConstants.CORE_SERVER_MARKETING_STITCHER_URL, params,
				MarketingConstants.MARKETING_STITCHER_SERVICE);
	}

	public static CommonAjaxResponse identify(MarketingIdentifyRequestParam params) {
		return callCoreService(MarketingConstants.CORE_SERVER_MARKETING_IDENTIFY_URL, params,
				MarketingConstants.MARKETING_IDENTIFY_SERVICE);
	}

	// Mock method
	public static CommonAjaxResponse identifyMock(MarketingIdentifyMockRequestParam params) {
		return callCoreService(MarketingConstants.CORE_SERVER_MARKETING_IDENTIFY_MOCK_URL, params,
				MarketingConstants.MARKETING_IDENTIFY_MOCK_SERVICE);
	}

	// rectify method
	public static CommonAjaxResponse rectify(MarketingRectifyRequestParam params) {
		return callCoreService(MarketingConstants.CORE_SERVER_MARKETING_RECTIFY_MOCK_URL, params,
				MarketingConstants.MARKETING_RECTIFY_SERVICE);
	}

	// pullData method
	public static CommonAjaxResponse pullData(MarketingPullDataRequestParam params) {
		return callCoreService(null, params, MarketingConstants.MARKETING_PULL_DATA_SERVICE);
	}

	private static CommonAjaxResponse callCoreService(String uri, IRequestParam params, String apiErrMsgTag) {
		String url = ConfigUtils.getInstance().getConfigValue("marketing.service.url") + uri;

		Map<String, String> headers = new HashMap<String, String>();
		if (StringUtils.endsWith(MarketingConstants.MARKETING_STITCHER_SERVICE, apiErrMsgTag)) {
			MarketingStitcherRequestParam requestParams = (MarketingStitcherRequestParam) params;
			if (StringUtils.isNotBlank(requestParams.getMajor_type())) {
				headers.put(MarketingConstants.MAJOR_TYPE, requestParams.getMajor_type());
			}
		} else if (StringUtils.endsWith(MarketingConstants.MARKETING_IDENTIFY_SERVICE, apiErrMsgTag)) {
			MarketingIdentifyRequestParam requestParams = (MarketingIdentifyRequestParam) params;
			if (StringUtils.isNotBlank(requestParams.getMajor_type())) {
				headers.put(MarketingConstants.MAJOR_TYPE, requestParams.getMajor_type());
			}
		} else if (StringUtils.endsWith(MarketingConstants.MARKETING_IDENTIFY_MOCK_SERVICE, apiErrMsgTag)) {
			// Mock setup
			url = ConfigUtils.getInstance().getConfigValue("marketing.mock.service.url");
		} else if (StringUtils.endsWith(MarketingConstants.MARKETING_RECTIFY_SERVICE, apiErrMsgTag)) {
			MarketingRectifyRequestParam requestParams = (MarketingRectifyRequestParam) params;
			if (StringUtils.isNotBlank(requestParams.getMajorType())) {
				headers.put(MarketingConstants.MAJOR_TYPE, requestParams.getMajorType());
			}
		}else if (StringUtils.endsWith(MarketingConstants.MARKETING_PULL_DATA_SERVICE, apiErrMsgTag)) {
			// Mock setup
			url = ConfigUtils.getInstance().getConfigValue("marketing.pulldata.service.url");
		}
		
		headers.put("Content-Type", "application/json");
		logger.info(url);
		logger.info(params.convertToJSON());
		String retValue = HttpClientUtils.post(url, headers, params.convertToJSON());

		if (StringUtils.isBlank(retValue)) {
			Message message = MessageUtils.getInstance().getMessage("marketing_call_service_failure");
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		logger.info("The response from backend marketing server:" + retValue);

		ObjectNode node = JsonUtil.toObjectNode(retValue);
		if (node == null) {
			Message message = MessageUtils.getInstance().getMessage("marketing_call_service_failure");
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}

		if (!Boolean.parseBoolean(node.get(Constant.CORE_SERVICE_SUCCESS_FLAG).asText())) {
			Message message = MessageUtils.getInstance().getMessage("marketing_call_service_failure");
			return CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		}

		return CommonAjaxResponse.toSuccess(node);
	}
}
