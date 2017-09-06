package com.tunicorn.marketing.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;

import org.apache.commons.lang.StringUtils;

import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import ch.ethz.ssh2.StreamGobbler; 

public class RemoteSSHUtils {
    private static String  DEFAULTCHART="UTF-8";
    private static Connection conn;
    private final static String IP = "172.16.1.90";
    private final static String USERNAME = "root";
    private final static String PASSWORD = "tunicorn";
      
    /** 
     * 远程登录主机 
     * @return 
     * 登录成功返回true，否则返回false 
     */  
    private static boolean login(){
        boolean success = false;
        try {  
            conn = new Connection(IP);
            conn.connect();
            success=conn.authenticateWithPassword(USERNAME, PASSWORD);
        } catch (IOException e) {
        	//TODO: logger the exception info
            e.printStackTrace();
        }
        return success;
    }  
    /** 
     * 远程执行脚本或者命令 
     * @param command 
     *      即将执行的命令 
     * @return 
     *      命令执行完后返回的结果值 
     */  
    public static String execute(String command){
        String result="";
        try {
            if(login()){
                Session session = conn.openSession();
                session.execCommand(command);
                result = processStdout(session.getStdout(),DEFAULTCHART);
                if(StringUtils.isBlank(result)){
                    result = processStdout(session.getStderr(),DEFAULTCHART);
                    //TODO: logger the error message
                }
                conn.close();
                session.close();
            }  
        } catch (IOException e) {
        	 //TODO: logger the exception message
            e.printStackTrace();
        }
        return result;
    }  

   /** 
    * 解析脚本执行返回的结果集 
    * @param in 输入流对象 
    * @param charset 编码 
    * @return 
    *  以纯文本的格式返回 
    */  
    private static String processStdout(InputStream in, String charset){
        InputStream  stdout = new StreamGobbler(in);
        StringBuffer buffer = new StringBuffer();
        try {
            BufferedReader br = new BufferedReader(new InputStreamReader(stdout,charset));
            String line=null;
            while((line=br.readLine()) != null){
                buffer.append(line+"\n");
            }  
            br.close();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }  finally {
        	try {
				stdout.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
        }
        return buffer.toString();
    }  
      
    public static void main(String[] args) {  
        //执行命令  
        System.out.println(RemoteSSHUtils.execute("ifconfig"));  
        //执行脚本  
        System.out.println(RemoteSSHUtils.execute("python /home/feng/script/test.py"));
        System.out.println(RemoteSSHUtils.execute("/home/feng/script/test.sh"));
    }  
}
