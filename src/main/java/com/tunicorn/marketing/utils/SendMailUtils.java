package com.tunicorn.marketing.utils;

import java.util.Properties;

import javax.mail.internet.MimeMessage;

import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;

import com.tunicorn.marketing.constant.MarketingConstants;

public class SendMailUtils {

	public static void sendTextWithHtml(String subject, String text){
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
		mailSender.setUsername(ConfigUtils.getInstance().getConfigValue("spring.mail.from"));
		mailSender.setPassword(ConfigUtils.getInstance().getConfigValue("spring.mail.from.password"));
		mailSender.setPort(465);
		mailSender.setDefaultEncoding(MarketingConstants.UTF8);
		try {
			message = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(message, true);
			helper.setFrom(ConfigUtils.getInstance().getConfigValue("spring.mail.from"));
			helper.setTo(ConfigUtils.getInstance().getConfigValue("spring.mail.to"));
			helper.setSubject(subject);
			helper.setText(text, true);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mailSender.send(message);
	}
}
