package com.tunicorn.marketing.constant;

import java.util.regex.Pattern;

import com.tunicorn.marketing.utils.ConfigUtils;

public class MarketingConstants {

	public static final String APP_KEY_HEADER_NAME = "App-Key";
	public static final String APP_SECRET_HEADER_NAME = "App-Secret";
	public static final String TOKEN_HEADER_NAME = "Authorization";
	public static final Pattern TOKEN_PATTERN = Pattern.compile("^[a-zA-z0-9]{64}$");
	public static final Pattern APP_KEY_SECRET_PATTERN = Pattern.compile("^[a-zA-z0-9\\-]{36}$");

	public static final String TASK_INIT_STATUS = "init";

	public static final String PATH_MARKETING = ConfigUtils.getInstance().getConfigValue("marketing.image.root.path");

	public static final String TASK_CREATE_API_NAME = "create_task";

	public static final String CORE_SERVER_MARKETING_STITCHER_URL = "/montage";
	public static final String CORE_SERVER_MARKETING_IDENTIFY_URL = "/statistics";
	public static final String CORE_SERVER_MARKETING_IDENTIFY_MOCK_URL = "/statistics_mock";

	public static final String MARKETING_STITCHER_API_NAME = "stitcher";
	public static final String MARKETING_IDENTIFY_API_NAME = "identify";

	public static final String TASK_STATUS_IMAGE_UPLOADED = "image_uploaded";
	public static final String TASK_STATUS_PENDING = "pending";
	public static final String TASK_STATUS_STITCHING = "stitching";
	public static final String TASK_STATUS_STITCH_FAILURE = "stitch_failure";
	public static final String TASK_STATUS_STITCH_SUCCESS = "stitch_success";
	public static final String TASK_STATUS_IDENTIFY_FAILURE = "identify_failure";
	public static final String TASK_STATUS_IDENTIFY_SUCCESS = "identify_success";

	public static final int PAGINATION_ITEMS_PER_PAGE = 20;

	public static final String STATUS_ACTIVE = "active";
	public static final String STATUS_DELETED = "deleted";

	public static final char COMMA = ',';
	public static final String POINT = ".";

	public static final int IMAGE_MAX_COUNT = 20;
	public static final int IMAGE_MAX_SIZE = 5;
	public static final int FIVE_IMAGES = 5;

	public static final String MARKETING = "marketing";

	public static final String MARKETING_STITCHER_SERVICE = "marketing_stitcher_service";
	public static final String MARKETING_IDENTIFY_SERVICE = "marketing_identify_service";
	public static final String MARKETING_IDENTIFY_MOCK_SERVICE = "marketing_identify_mock_service";

	public static final String API_MARKETING = "/api/marketing/";
	public static final String PIC_MARKETING = "/pic/marketing";

	public static final String POST = "POST";

	public static final String TASK_ID = "taskId";
	public static final String MAJOR_TYPE = "major_type";
	
}