package com.tunicorn.marketing.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

@WebFilter(filterName = "xssFilter", urlPatterns = "/*", asyncSupported = true)
public class XssFilter implements Filter {
	 
	 /**
	  * 描述 : 日志
	  */
	 private static final Logger LOGGER = Logger.getLogger(XssFilter.class);
	 
	 @Override
	 public void init(FilterConfig filterConfig) throws ServletException {
	  LOGGER.debug("(XssFilter) initialize");
	 }
	 
	 @Override
	 public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
	   throws IOException, ServletException {
	  XssHttpServletRequestWrapper xssRequest =
	    new XssHttpServletRequestWrapper((HttpServletRequest) request);
	  chain.doFilter(xssRequest, response);
	 }
	 
	 @Override
	 public void destroy() {
	  LOGGER.debug("(XssFilter) destroy");
	 }

}
