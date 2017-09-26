package com.tunicorn.marketing.constant;

import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import org.mockito.internal.util.reflection.FieldInitializationReport;

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
	public static final String CORE_SERVER_MARKETING_RECTIFY_MOCK_URL = "/rectify";

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
	public static final String MARKETING_RECTIFY_SERVICE = "marketing_rectify_service";
	public static final String MARKETING_PULL_DATA_SERVICE = "marketing_pull_data_service";
	public static final String MARKETING_GET_STORE_SERVICE = "marketing_get_store_service";

	public static final String API_MARKETING = "/api/marketing/";
	public static final String PIC_MARKETING = "/pic/marketing";

	public static final String POST = "POST";

	public static final String TASK_ID = "taskId";
	public static final String MAJOR_TYPE = "major_type";
	public static Map<String, String> SERVICE_STATUS_NAME_MAPPING = new HashMap<String, String>();
	static {
		SERVICE_STATUS_NAME_MAPPING.put("created", "已创建");
		SERVICE_STATUS_NAME_MAPPING.put("opened", "已开通");
		SERVICE_STATUS_NAME_MAPPING.put("rejected", "已驳回");
	}

	public static final String MARKETING_IMAGE_BASE_PATH = com.tunicorn.util.ConfigUtils.getInstance().getConfigValue(
			"storage.private.basePath") + ConfigUtils.getInstance().getConfigValue("marketing.image.root.path");
	public static final String TIANNUO_PASSWORD = "tiannuo";
	
	public static final String UTF8 = "UTF-8";
	public static final String ISO88991= "iso-8859-1";
	public static final String GBK = "GBK";

	public static final String APPLY_CREATED_STATUS = "created";
	public static final String APPLY_OPENED_STATUS = "opened";
	public static final String APPLY_REJECTED_STATUS = "rejected";

	public static final String SESSION_ADMIN_USER = "admin_user";

	public static final String APPLICATION_PRIVACY_PUBLIC = "public";
	public static final String APPLICATION_PRIVACY_PRIVATE = "private";
	public static final String APPLICATION_PRIVACY_PROTECTED = "protected";

	public static final String ADMIN_USER_NAME = "admin";

	public static final String INNOVISION = "innovision";
	
	public static final String BROWSER_IE= "IE";
	public static final String BROWSER_FIREFOX= "FF";
	public static final String BROWSER_SAFARI= "SF";
	
	public static final String USER_AGENT = "USER-AGENT";
	
	public static final String BATCH_ZIP_PATH = "static" + File.separator + "zip" + File.separator  + "batch_zip.zip";
	public static final String BATCH_ZIP_NAME = "batch_zip.zip";
	
	public static final String CROP_IMAGE_PATH = "JPEGImages";
	public static final String CROP_XML_PATH = "Annotations";
	
	public static final String UPLOAD_PATH = "upload";
	public static final String ZIP_PATH = "zip";
	
	public static final int BATCH_INSERT_SIZE = Integer.parseInt(ConfigUtils.getInstance().getConfigValue("marketing.batch.insert.size"));
	
	public static final String REMOTE_SSH_RETURN = "tunicorn ret success";
}