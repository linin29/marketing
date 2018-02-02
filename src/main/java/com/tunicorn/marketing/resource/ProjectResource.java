package com.tunicorn.marketing.resource;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.tunicorn.common.api.RestAPIResponse;
import com.tunicorn.common.entity.AjaxResponse;
import com.tunicorn.marketing.api.CommonAjaxResponse;
import com.tunicorn.marketing.service.ProjectService;
import com.tunicorn.marketing.vo.ProjectVO;
import com.tunicorn.marketing.vo.TokenVO;

@RestController
@EnableAutoConfiguration
@RequestMapping(value = "/api/v1/marketing", produces = "application/json;charset=utf-8")
@Validated
public class ProjectResource extends BaseResource {
	private static Logger logger = Logger.getLogger(ProjectResource.class);
	
	@Autowired
	private ProjectService projectService;
	
	/**
	 * 根据登录token获取与该账号关联的项目列表
	 * @auther weixiaokai
	 * @date 2018年2月1日 下午2:05:31
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/projects/get", method = RequestMethod.POST)
	@ResponseBody
	public CommonAjaxResponse getProjects(HttpServletRequest request){
		logger.info("根据token获取该用户下的可选项目");
		AjaxResponse tokenStatus = checkToken(request);
		if (!tokenStatus.getSuccess()) { //token失效
			logger.info(tokenStatus.getErrorMessage());
			return CommonAjaxResponse.toFailure(tokenStatus.getErrorCode(),tokenStatus.getErrorMessage());
		}
		//token有效
		TokenVO token = (TokenVO) tokenStatus.getData();
		List<Map<String, Object>> pMaps = projectService.getProjectsByUserId(token.getUserId());
		return CommonAjaxResponse.toSuccess(pMaps);
	}

}
