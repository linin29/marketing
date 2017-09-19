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

import com.tunicorn.marketing.bo.AnnotationBO;

public class FTPClientHelper {
	private final static  String REMOTE_BASE_PATH = "/test";
	private final static  String REMOTE_IMAGE_FOLDER = "JPEGImages";
	private final static  String REMOTE_ANNOTATION_FOLDER = "Annotations";
	private final static  String SEPRATOR = "/";
	private final static  String CHARSET = "UTF-8";
	private FTPClient ftpClient = new FTPClient();     
    private String server, userName, password;
    private int port;
    
    public FTPClientHelper(String ip, int port, String userName, String password){     
    	this.server = ip;   
    	this.userName = userName;   
    	this.password = password;   
    	this.port = port;   
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
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
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
			e.printStackTrace();
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
			e.printStackTrace();
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
	        		//TODO: log upload file ${remoteFileName} failed
	        		failedEntity.add(entity);
	        		continue;
	        	}
			} catch (IOException e) {
				e.printStackTrace();
				failedEntity.add(entity);
				continue;
			}
        	
			try {
				FTPFile[] remoteAnnotationFiles = ftpClient.listFiles(remoteAnnotationFile);
				if (null != remoteAnnotationFiles && remoteAnnotationFiles.length > 0) {
	        		ftpClient.deleteFile(remoteAnnotationFile);
	        	}
				if (!uploadFile(remoteAnnotationFile, entity.getAnnotationXML())){
	        		//TODO: log upload file ${remoteFileName} failed
	        		failedEntity.add(entity);
	        		ftpClient.deleteFile(remoteImageFile);
	        	}
			} catch (IOException e) {
				e.printStackTrace();
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
		} catch (IOException e) {
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
                    	//TODO: log the creating directory ${directory} failed
                    	success = false;
                    	return success;
                    }
        		}
        	}
        	ftpClient.changeWorkingDirectory(SEPRATOR);
    	} catch (IOException exception) {
    		exception.printStackTrace();
    	}
    	return success;
    }     
}
