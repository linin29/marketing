package com.tunicorn.marketing.utils;

import java.util.Properties;

import javax.mail.internet.MimeMessage;

import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;

import com.tunicorn.marketing.constant.MarketingConstants;

public class SendMailUtils {

	public static void sendTextWithHtml(String from, String[] to, String subject, String text) throws Exception {
		MimeMessage message = null;

		Properties properties = new Properties();
		// 是否显示调试信息(可选)
		//properties.setProperty("mail.debug", "true");
		properties.setProperty("mail.smtp.starttls.enable", "false");
		properties.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		properties.setProperty("mail.smtp.auth", "true");
		properties.setProperty(" mail.smtp.timeout ", "25000");

		JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
		mailSender.setJavaMailProperties(properties);
		mailSender.setHost("smtp.exmail.qq.com");
		mailSender.setUsername(from);
		//mailSender.setPassword("");
		mailSender.setPort(465);
		mailSender.setDefaultEncoding(MarketingConstants.UTF8);
		try {
			message = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(message, true);
			helper.setFrom(from);
			helper.setTo(to);
			helper.setSubject(subject);
			helper.setText(text, true);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mailSender.send(message);
	}

	public static void main(String[] args) {
		try {
			StringBuffer sb = new StringBuffer();
			sb.append("<h1>大标题-h1</h1>")
					.append("<p style='color:#F00'>红色字</p>")
					.append("<p style='text-align:right'>右对齐</p>");
			sendTextWithHtml("lining@tunicorn.cn", new String[] { "948016508@qq.com" }, "服务申请", sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
