package com.tunicorn.marketing;

import javax.servlet.MultipartConfigElement;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.MultipartConfigFactory;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import com.tunicorn.marketing.interceptor.LoginInterceptor;
import com.tunicorn.util.ConfigUtils; 

@SpringBootApplication
@MapperScan("com.tunicorn.marketing.*mapper")
@ServletComponentScan
public class MarketingApplication extends WebMvcConfigurerAdapter {

	public static void main(String[] args) { 
		SpringApplication.run(MarketingApplication.class, args);
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(new LoginInterceptor()).addPathPatterns("/**").excludePathPatterns("/js/**")
		.excludePathPatterns("/fonts/**")
		.excludePathPatterns("/css/**") 
		.excludePathPatterns("/image/**")
		.excludePathPatterns("/login")
		.excludePathPatterns("/api/**")
		.excludePathPatterns("/user/**");
	}

	@Bean
	public MultipartConfigElement multipartConfigElement() {
		String size = ConfigUtils.getInstance().getConfigValue("file.upload.size");
		String total = ConfigUtils.getInstance().getConfigValue("file.upload.total.size");
		//String location = ConfigUtils.getInstance().getConfigValue("file.upload.storage");

		MultipartConfigFactory factory = new MultipartConfigFactory();
		factory.setMaxFileSize(size); //KB,MB， file size
		factory.setMaxRequestSize(total);  //total size of files
		//factory.setLocation(location);  //file path to storage
		return factory.createMultipartConfig();
	}
}
