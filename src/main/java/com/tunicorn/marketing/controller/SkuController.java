package com.tunicorn.marketing.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.tunicorn.marketing.bo.ApiCallingSummaryBO;
import com.tunicorn.marketing.bo.GoodsSkuBO;
import com.tunicorn.marketing.service.GoodsSkuService;
import com.tunicorn.marketing.vo.ApiCallingSummaryVO;
import com.tunicorn.marketing.vo.GoodsSkuVO;
import com.tunicorn.marketing.vo.UserVO;

@Controller
@RequestMapping("/admin/sku")
@EnableAutoConfiguration
public class SkuController extends BaseController{
	
	@Autowired
	private GoodsSkuService goodsSkuService;

	@RequestMapping(value = "", method = RequestMethod.GET)
	public String sku(HttpServletRequest request, Model model) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		GoodsSkuBO goodsSkuBO = new GoodsSkuBO();

		List<GoodsSkuVO> goodsSkuVOs = goodsSkuService.getGoodsSkuListByBO(goodsSkuBO);
		int totalCount = goodsSkuService.getGoodsSkuCount(goodsSkuBO);

		model.addAttribute("GoodsSkus", goodsSkuVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", 1);
		return "admin/sku/sku";
	}
	
	@RequestMapping(value = "/search", method = RequestMethod.GET)
	public String searchSku(HttpServletRequest request, Model model) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		GoodsSkuBO goodsSkuBO = new GoodsSkuBO();
		if (StringUtils.isNotBlank(request.getParameter("pageNum"))) {
			goodsSkuBO.setPageNum(Integer.parseInt(request.getParameter("pageNum")));
		}
		if (StringUtils.isNotBlank(request.getParameter("majorType"))) {
			goodsSkuBO.setMajorTypeId(Integer.parseInt(request.getParameter("majorType")));
		}
		List<GoodsSkuVO> goodsSkuVOs = goodsSkuService.getGoodsSkuListByBO(goodsSkuBO);
		int totalCount = goodsSkuService.getGoodsSkuCount(goodsSkuBO);

		model.addAttribute("GoodsSkus", goodsSkuVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", goodsSkuBO.getPageNum() + 1);
		return "admin/sku/sku";
	}
}
