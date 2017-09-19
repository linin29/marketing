package com.tunicorn.marketing.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.apache.log4j.Logger;

import com.tunicorn.marketing.bo.AnnotationBO;

public class FTPTransferUtils {
	private static Logger logger = Logger.getLogger(FTPTransferUtils.class);
	private static final String FTP_IP = "172.16.1.89";
	private static final int FTP_PORT = 21;
	private static final String FTP_USERNAME = "Anonymous";
	private static final String FTP_PASSWORD = "";
	/**
	 * 触发模型训练, 首先将所有图片和标注数据上传到远程FTP服务器;然后远程执行模型训练脚本
	 * @param entities
	 * @return
	 */
	public static List<AnnotationBO> transferFiles (List<AnnotationBO>  entities) {
		Map<String, List<AnnotationBO>> typeEntitiesMap = constructTypeEntitiesMap(entities);
		List<AnnotationBO> failedEntities = transferFiles(typeEntitiesMap);
		return failedEntities;
	}
	/**
	 * 构造品类与Entity的map关系
	 * @param entities 所有从db中获取的entity
	 * @return Map<String, List<AnnotationEntity>> 每个品类对应的entity列表
	 */
	private static Map<String, List<AnnotationBO>> constructTypeEntitiesMap (List<AnnotationBO>  entities) {
		 Map<String, List<AnnotationBO>> typeEntitiesMap = new HashMap<String, List<AnnotationBO>>();
		 for (AnnotationBO entity : entities) {
			String type = entity.getType();
			List<AnnotationBO> entityList = null;
			if (!typeEntitiesMap.containsKey(type)) {
				entityList = new ArrayList<AnnotationBO>();
				entityList.add(entity);
			} else {
				entityList = typeEntitiesMap.get(type);
				entityList.add(entity);
			}
			typeEntitiesMap.put(type, entityList);
		}
		 return typeEntitiesMap;
	 }
	
	/**
	 * 将每个品类下的所有图片和标注文件上传到远程服务器。每个品类对应一个异步线程来上传文件，结束后将所有失败的记录汇总
	 * @param typeEntitiesMap 品类与待传实体的映射
	 * @return List<AnnotationEntity> 上传失败的记录
	 */
	private static List<AnnotationBO> transferFiles (Map<String, List<AnnotationBO>> typeEntitiesMap) {
		 List<AnnotationBO> failedEntities = new ArrayList<AnnotationBO>();
		 if (typeEntitiesMap != null && typeEntitiesMap.size() > 0) {
			 CountDownLatch latch = new CountDownLatch(typeEntitiesMap.size());
			 ExecutorService transferThreadPool = Executors.newFixedThreadPool(typeEntitiesMap.size());
			 for (String type : typeEntitiesMap.keySet()) {
				 List<AnnotationBO> totalEntities = typeEntitiesMap.get(type);
				 FTPClientHelper client = new FTPClientHelper(FTP_IP, FTP_PORT, FTP_USERNAME, FTP_PASSWORD);
				 client.connect();
				 if(client.createRemoteDirectory(type)){
					 transferThreadPool.execute(new TransferThread(client, latch, failedEntities, totalEntities, type));
				 } else {
					 logger.error("Create remote directory failed...");
					 failedEntities.addAll(totalEntities);
				 }
				 
			 }
			 try {
				latch.await();
			} catch (InterruptedException e) {
				logger.error("Thread interrupte exception, caused by:" + e.getStackTrace());
			} finally {
				transferThreadPool.shutdown();
			}
		 }
		 return failedEntities;
	 }
}
/**
 * 异步上传文件线程
 * @author adamen
 *
 */
class TransferThread implements Runnable {
	private FTPClientHelper client;
	private CountDownLatch latch;
	private List<AnnotationBO> failedEntities;
	private List<AnnotationBO> entities;
	private String type;
	
	public TransferThread (FTPClientHelper client, CountDownLatch latch, List<AnnotationBO> failedEntities, List<AnnotationBO> totalEntities, String type) {
		this.client = client;
		this.latch = latch;
		this.failedEntities = failedEntities;
		this.entities = totalEntities;
		this.type = type;
	}
	
	public void run() {
		List<AnnotationBO> failedEntityList = new ArrayList<AnnotationBO>();
		try {
			//client.connect();
			failedEntityList = client.upload(entities, type);
			synchronized(latch) {
				failedEntities.addAll(failedEntityList);
			}
		} finally {
			client.disconnect();
			latch.countDown();
		}
	}
	
}