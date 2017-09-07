package com.tunicorn.marketing.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.tunicorn.marketing.constant.MarketingConstants;

import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import ch.ethz.ssh2.StreamGobbler;

public class RemoteSSHUtils {
	private static Logger logger = Logger.getLogger(RemoteSSHUtils.class);

	private static Connection conn;
	private final static String IP = ConfigUtils.getInstance().getConfigValue("remote.ssh.ip");
	private final static String USERNAME = ConfigUtils.getInstance().getConfigValue("remote.ssh.username");
	private final static String PASSWORD = ConfigUtils.getInstance().getConfigValue("remote.ssh.password");

	/**
	 * 远程登录主机
	 * 
	 * @return 登录成功返回true，否则返回false
	 */
	private static boolean login() {
		boolean success = false;
		try {
			conn = new Connection(IP);
			conn.connect();
			success = conn.authenticateWithPassword(USERNAME, PASSWORD);
		} catch (IOException e) {
			logger.error("remote login exception, ip: " + IP);
			e.printStackTrace();
		}
		return success;
	}

	/**
	 * 远程执行脚本或者命令
	 * 
	 * @param command
	 *            即将执行的命令
	 * @return 命令执行完后返回的结果值
	 */
	public static String execute(String command) {
		String result = "";
		try {
			if (login()) {
				Session session = conn.openSession();
				session.execCommand(command);
				result = processStdout(session.getStdout(), MarketingConstants.UTF8);
				if (StringUtils.isBlank(result)) {
					result = processStdout(session.getStderr(), MarketingConstants.UTF8);
					logger.info("execute remote script fail, execute result: " + result);
				}
				conn.close();
				session.close();
			}
		} catch (IOException e) {
			logger.error("execute remote script exception, command: " + command);
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 解析脚本执行返回的结果集
	 * 
	 * @param in
	 *            输入流对象
	 * @param charset
	 *            编码
	 * @return 以纯文本的格式返回
	 */
	private static String processStdout(InputStream in, String charset) {
		InputStream stdout = new StreamGobbler(in);
		StringBuffer buffer = new StringBuffer();
		try {
			BufferedReader br = new BufferedReader(new InputStreamReader(stdout, charset));
			String line = null;
			while ((line = br.readLine()) != null) {
				buffer.append(line + "\n");
			}
			br.close();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				stdout.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return buffer.toString();
	}

	public static void main(String[] args) {
		// 执行命令
		System.out.println(RemoteSSHUtils.execute("ifconfig"));
		// 执行脚本
		System.out.println(RemoteSSHUtils.execute("python /home/feng/script/test.py"));
		System.out.println(RemoteSSHUtils.execute("/home/feng/script/test.sh"));
	}
}
