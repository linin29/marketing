package com.tunicorn.marketing.utils;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import com.tunicorn.common.entity.UploadFile;
import com.tunicorn.common.storage.StorageWrapper;
import com.tunicorn.marketing.constant.MarketingConstants;

public class MarketingStorageUtils {
	public static UploadFile getUploadFile(MultipartFile file, long userId, long appId){
		return StorageWrapper.getUploadFile(file, MarketingConstants.PATH_MARKETING, userId, appId, true);
	}
	public static UploadFile getUploadFile(String url, long userId, long appId) {
		return StorageWrapper.getUploadFile(url, MarketingConstants.PATH_MARKETING, userId, appId, true);
	}
	public static UploadFile getUploadFile(MultipartFile file, int userId, long appId, boolean isTemp) {
		return StorageWrapper.getUploadFile(file, MarketingConstants.PATH_MARKETING, userId, appId, isTemp);
	}
	public static UploadFile getUploadFile(MultipartFile file, String userId, String taskId, Date date, String sub, boolean isTemp) {
		return StorageWrapper.getUploadFile(file, MarketingConstants.PATH_MARKETING, userId, taskId, date, sub, isTemp);
	}
	public static UploadFile getUploadFile(String url, long userId, long appId, boolean isTemp) {
		return StorageWrapper.getUploadFile(url, MarketingConstants.PATH_MARKETING, userId, appId, isTemp);
	}
	public static byte[] getResourceFile(String filePath){
		return StorageWrapper.getResourceFile(MarketingConstants.PATH_MARKETING, filePath);
	}
}
