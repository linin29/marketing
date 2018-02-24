package com.tunicorn.marketing.resource;


import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.web.ErrorAttributes;
import org.springframework.boot.autoconfigure.web.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.tunicorn.common.api.Message;
import com.tunicorn.common.entity.AjaxResponse;
import com.tunicorn.util.MessageUtils;
@Controller
public class ExceptionResource implements ErrorController {
	private static Logger logger = Logger.getLogger(ExceptionResource.class);
	private static final String PATH = "/error";
	@Autowired
    private ErrorAttributes errorAttributes;
	/**
	 * 接口调用出错的情况下的error转发
	 * @auther weixiaokai
	 * @date 2018年2月24日 上午11:36:41
	 * @param request
	 * @return
	 */
	@RequestMapping(value = PATH)
	@ResponseBody
	AjaxResponse error(HttpServletRequest request, HttpServletResponse response) {
        /*if(!EnvironmentUtils.isProduction()) {
            return buildBody(request,true);
        }else{
            return buildBody(request,false);
        }*/
        return buildBody(request,false);
    }
	
	private AjaxResponse buildBody(HttpServletRequest request,Boolean includeStackTrace){
        Map<String,Object> errorAttributes = getErrorAttributes(request, includeStackTrace);
        Integer status=(Integer)errorAttributes.get("status");
        String path=(String)errorAttributes.get("path");
        String messageFound=(String)errorAttributes.get("message");
        String message="";
        String trace ="";
        if(!StringUtils.isEmpty(path)){
            message=String.format("Requested path %s with result %s",path,messageFound);
        }
        if(includeStackTrace) {
             trace = (String) errorAttributes.get("trace");
             if(!StringUtils.isEmpty(trace)) {
                 message += String.format(" and trace %s", trace);
             }
        }
        Message message1 = MessageUtils.getInstance().getMessage("resource_not_available");
		AjaxResponse response = AjaxResponse.toFailure(message1.getCode(), message1.getMessage());
		return response;
    }
	
	
	private Map<String, Object> getErrorAttributes(HttpServletRequest request, boolean includeStackTrace) {
        RequestAttributes requestAttributes = new ServletRequestAttributes(request);
        return errorAttributes.getErrorAttributes(requestAttributes, includeStackTrace);
    }
	/*public AjaxResponse getProjects(HttpServletRequest request){
		Message message = MessageUtils.getInstance().getMessage("resource_not_available");
		AjaxResponse response = AjaxResponse.toFailure(message.getCode(), message.getMessage());
		return response;
	}
*/
	@Override
	public String getErrorPath() {
		// TODO Auto-generated method stub
		return PATH;
	}
	

}
