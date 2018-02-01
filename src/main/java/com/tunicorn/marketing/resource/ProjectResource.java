package com.tunicorn.marketing.resource;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.tunicorn.common.api.RestAPIResponse;
import com.tunicorn.common.entity.AjaxResponse;
import com.tunicorn.marketing.service.ProjectService;

@RestController
@EnableAutoConfiguration
@RequestMapping(value = "/api/v1/marketing", produces = "application/json;charset=utf-8")
@Validated
public class ProjectResource extends BaseResource {
	private static Logger logger = Logger.getLogger(ProjectResource.class);
	
	@Autowired
	private ProjectService projectService;
	
	@RequestMapping(value = "/projects/get", method = RequestMethod.POST)
	@ResponseBody
	public RestAPIResponse getProjects(HttpServletRequest request){
		logger.info("根据token获取该用户下的可选项目");
		AjaxResponse tokenStatus = checkToken(request);
		return new RestAPIResponse(null);
	}

}
