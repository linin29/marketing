package com.tunicorn.marketing.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.SocketException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.net.ftp.FTPReply;
import org.apache.log4j.Logger;

import com.tunicorn.marketing.bo.AnnotationBO;
import com.tunicorn.marketing.constant.MarketingConstants;

public class FTPClientHelper {
	private static Logger logger = Logger.getLogger(FTPClientHelper.class);
	private final static  String REMOTE_BASE_PATH = ConfigUtils.getInstance().getConfigValue("ftp.base.path");
	private final static  String REMOTE_IMAGE_FOLDER = ConfigUtils.getInstance().getConfigValue("ftp.image.directory");
	private final static  String REMOTE_ANNOTATION_FOLDER = ConfigUtils.getInstance().getConfigValue("ftp.annotation.directory");
	private final static  String SEPRATOR = "/";
	private final static  String CHARSET = "UTF-8";
	private final static  String SKU_FILE_NAME = ConfigUtils.getInstance().getConfigValue("ftp.sku.file.name");
	private final static  String LOCAL_BASE_PATH = String.format("%s%s%s%s",
												   com.tunicorn.util.ConfigUtils.getInstance().getConfigValue("storage.private.basePath"),
												   ConfigUtils.getInstance().getConfigValue("marketing.image.root.path"), File.separator,
												   MarketingConstants.UPLOAD_PATH);
	private FTPClient ftpClient = new FTPClient();     
    private String server, userName, password;
    private int port;
    
    public FTPClientHelper(String ip, int port, String userName, String password){     
    	this.server = ip;   
    	this.userName = userName;   
    	this.password = password;   
    	this.port = port;
    	ftpClient.setConnectTimeout(10*60*1000);
    	//设置将过程中使用到的命令输出到控制台 -for debugging
        //this.ftpClient.addProtocolCommandListener(new PrintCommandListener(new PrintWriter(System.out)));     
    }     
	         
   /**
    * 连接远程服务器
    * @return boolean 是否连接成功
    */
    public boolean connect(){     
    	try {
			ftpClient.connect(server, port);
			ftpClient.setControlEncoding(CHARSET);     
	        if(FTPReply.isPositiveCompletion(ftpClient.getReplyCode())){     
	            if(ftpClient.login(userName, password)){     
	                return true;     
	            }     
	        }     
	        disconnect();     
		} catch (SocketException e) {
			logger.error("Failed to connect remote server, caused by:" + e.getMessage());
		} catch (IOException e) {
			logger.error("Failed to connect/login remote server, caused by:" + e.getMessage());
		}     
    	return false;  
    }     
    /**
     * 断开远程连接
     */
    public void disconnect() {     
        try {
        	if(ftpClient.isConnected()){
        		ftpClient.disconnect();
        	}
		} catch (IOException e) {
			logger.error("Failed to disconnect remote server, caused by:" + e.getMessage());
		}     
    }
    /**
     * upload local files to remote, send all the local files to the remote path with same file name
     * @param entities 待上传的列表
     * @param type 品类
     * @return List<AnnotationEntity> 上传失败的列表
     */
    public List<AnnotationBO> upload(List<AnnotationBO> entities, String type){
    	List<AnnotationBO> failedEntity = new ArrayList<AnnotationBO>();
    	//设置PassiveMode传输 -被动模式，client主动向服务器发送数据
        ftpClient.enterLocalPassiveMode();     
        //设置以二进制流的方式传输 -默认是ASCII(文本)方式
		try {
			ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
		} catch (IOException e) {
			logger.error("Failed to set file type on remote server, caused by:" + e.getMessage());
			failedEntity.addAll(entities);
			return failedEntity;
		}
		ftpClient.setControlEncoding(CHARSET);   
        //boolean success = true;     
        //对远程目录的处理     
        String remoteImagePath = REMOTE_BASE_PATH + SEPRATOR + type + SEPRATOR + REMOTE_IMAGE_FOLDER;
        String remoteAnnotationPath = REMOTE_BASE_PATH + SEPRATOR + type + SEPRATOR + REMOTE_ANNOTATION_FOLDER;
        
        for (AnnotationBO entity : entities) {
        	String localImageName = entity.getImage().getName();
        	String localAnnotationName = entity.getAnnotationXML().getName();
        	String remoteImageFile = remoteImagePath + SEPRATOR + localImageName;
        	String remoteAnnotationFile = remoteAnnotationPath + SEPRATOR + localAnnotationName;
        	
			try {
				FTPFile[] remoteImageFiles = ftpClient.listFiles(remoteImageFile);
				if (null != remoteImageFiles && remoteImageFiles.length > 0) {
	        		ftpClient.deleteFile(remoteImageFile);
	        	}
				if (!uploadFile(remoteImageFile, entity.getImage())){
					logger.error("Failed to upload file to remote server, file name:" + localImageName);
	        		failedEntity.add(entity);
	        		continue;
	        	}
			} catch (IOException e) {
				logger.error("Failed to operate file on remote server, file name:" + localImageName + ". Caused by:" + e.getMessage());
				failedEntity.add(entity);
				continue;
			}
        	
			try {
				FTPFile[] remoteAnnotationFiles = ftpClient.listFiles(remoteAnnotationFile);
				if (null != remoteAnnotationFiles && remoteAnnotationFiles.length > 0) {
	        		ftpClient.deleteFile(remoteAnnotationFile);
	        	}
				if (!uploadFile(remoteAnnotationFile, entity.getAnnotationXML())){
					logger.error("Failed to upload file to remote server, file name:" + localAnnotationName);
	        		failedEntity.add(entity);
	        		ftpClient.deleteFile(remoteImageFile);
	        	}
			} catch (IOException e) {
				logger.error("Failed to operate file on remote server, file name:" + localAnnotationName + ". Caused by:" + e.getMessage());
				failedEntity.add(entity);
			}
        }
        return failedEntity;
    } 
    /**
     * write data to remote file
     * @param remoteFileName
     * @param localFile
     * @return boolean 是否上传成功
     */
    private boolean uploadFile (String remoteFileName, File localFile) {
    	OutputStream out = null;
    	boolean success = false;
		try {
			out = ftpClient.storeFileStream(remoteFileName);
			FileInputStream fileInput = new FileInputStream(localFile);
	    	byte[] data = new byte[4096];
	    	int read;
	    	while((read = fileInput.read(data)) != -1){     
	            out.write(data, 0, read);     
	        }     
	        out.flush();     
	        fileInput.close();     
	        out.close();    
	        success = ftpClient.completePendingCommand();
		} catch (Exception e) {
			logger.error("Failed to write file on remote server, file name:" + remoteFileName);
			e.printStackTrace();
		}
        return success;
    }
    /**
     * 创建品类目录结构
     * @param type
     * @return boolean 是否创建成功
     */
    public boolean createRemoteDirectory (String type) {
    	List<String> remoteDirs = new ArrayList<String>();
    	String remoteImagePath = REMOTE_BASE_PATH + SEPRATOR + type + SEPRATOR + REMOTE_IMAGE_FOLDER;
        String remoteAnnotationPath = REMOTE_BASE_PATH + SEPRATOR + type + SEPRATOR + REMOTE_ANNOTATION_FOLDER;
        remoteDirs.add(remoteImagePath);
        remoteDirs.add(remoteAnnotationPath);
        for (String dir : remoteDirs) {
        	if (!createDirectory(dir)) {
				return false;
			}
        }
        return true;
        
    }
    /**
     * 上传sku列表文件
     * @param type
     */
    public void uploadSkuFile(String type){
    	//设置PassiveMode传输 -被动模式，client主动向服务器发送数据
        ftpClient.enterLocalPassiveMode();     
        //设置以二进制流的方式传输 -默认是ASCII(文本)方式
		try {
			ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
		} catch (IOException e) {
			logger.error("Failed to set file type on remote server, caused by:" + e.getMessage());
		}
		ftpClient.setControlEncoding(CHARSET);
		String localSkuFile = LOCAL_BASE_PATH + File.separator + type+File.separator + SKU_FILE_NAME;
        String remoteSkuFile = REMOTE_BASE_PATH + File.separator + type + SEPRATOR + SKU_FILE_NAME;
    	
		try {
			FTPFile[] remoteSkuFiles = ftpClient.listFiles(remoteSkuFile);
			if (null != remoteSkuFiles && remoteSkuFiles.length > 0) {
        		ftpClient.deleteFile(remoteSkuFile);
        	}
			if (!uploadFile(remoteSkuFile, new File(localSkuFile))){
				logger.error("Failed to upload file to remote server, file name:" + SKU_FILE_NAME);
        	}
		} catch (IOException e) {
			logger.error("Failed to operate file on remote server, file name:" + SKU_FILE_NAME + ". Caused by:" + e.getMessage());
		}
    }
    /**
     * 循环创建远程目录
     * @param remotePath
     * @return boolean 是否创建成功
     */
    private boolean createDirectory(String remotePath){
    	boolean success = true;
    	String[] directories = remotePath.split(SEPRATOR);
    	try {
    		for (String directory : directories) {
        		if (StringUtils.isEmpty(directory)) {
        			continue;
        		}
        		if (!ftpClient.changeWorkingDirectory(new String(directory.getBytes(CHARSET),CHARSET))) {
        			if(ftpClient.makeDirectory(directory)){
                        ftpClient.changeWorkingDirectory(directory);     
                    } else {
                    	logger.error("Failed to create directory on remote server, directory name:" + directory);
                    	success = false;
                    	return success;
                    }
        		}
        	}
        	ftpClient.changeWorkingDirectory(SEPRATOR);
    	} catch (IOException exception) {
    		success = false;
    		logger.error("Failed to create directory on remote server, caused by:" + exception.getMessage());
    	}
    	return success;
    }     
}
