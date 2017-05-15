package com.tunicorn.marketing.exception;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.http.HttpStatus;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.multipart.MultipartException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.NoHandlerFoundException;

import com.tunicorn.common.api.Message;
import com.tunicorn.marketing.api.CommonAjaxResponse;
import com.tunicorn.util.MessageUtils;

@ControllerAdvice
public class GlobalExceptionHandler {

	private static Logger logger = Logger.getLogger(GlobalExceptionHandler.class);

	@ResponseStatus(HttpStatus.NOT_FOUND)
	@ExceptionHandler(NoHandlerFoundException.class)
	public ModelAndView handleNotFound(NoHandlerFoundException exception, HttpServletRequest request) {
		logger.error(exception.getMessage());
		return new ModelAndView("error/404");
	}

	@ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
	@ExceptionHandler(HttpMessageNotReadableException.class)
	@ResponseBody
	public String handleHttpMessageNotReadable(HttpMessageNotReadableException exception,
			HttpServletRequest request) {
		Message message = MessageUtils.getInstance().getMessage("marketing_parameter_invalid");
		CommonAjaxResponse response = CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		logger.error("request_id:" + response.getRequestId() + ", error:" + exception.getMessage());
		return response.toString();
	}

	@ResponseStatus(HttpStatus.EXPECTATION_FAILED)
	@ExceptionHandler(MultipartException.class)
	@ResponseBody
	public String handleFileSizeException(MultipartException exception) {
		String errInfo = exception.getMessage();
		Message message = null;
	    message = MessageUtils.getInstance().getMessage("marketing_image_max_size");
		if(errInfo.contains("maximum")){
			message = MessageUtils.getInstance().getMessage("marketing_image_max_size");
		}else if(errInfo.contains("not a multipart")){
			message = MessageUtils.getInstance().getMessage("marketing_not_multipart_request");
		}else if(errInfo.contains("no multipart boundary was found")){
			message = MessageUtils.getInstance().getMessage("marketing_no_multipart_boundary");
		}else{
			message = MessageUtils.getInstance().getMessage("marketing_file_upload_error");
		}
		CommonAjaxResponse response = CommonAjaxResponse.toFailure(message.getCode(), message.getMessage());
		logger.error("request_id:" + response.getRequestId() + ", error:" + exception.getMessage());
		return response.toString();
	}

	@ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
	@ExceptionHandler(RuntimeException.class)
	public ModelAndView handleInternalError(RuntimeException exception, HttpServletRequest request) {
		logger.error(exception.getMessage());
		return new ModelAndView("error/500");
	}

}
