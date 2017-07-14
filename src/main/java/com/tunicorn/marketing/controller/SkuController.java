package com.tunicorn.marketing.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.tunicorn.common.api.Message;
import com.tunicorn.common.entity.AjaxResponse;
import com.tunicorn.marketing.bo.GoodsSkuBO;
import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.service.GoodsSkuService;
import com.tunicorn.marketing.service.MajorTypeService;
import com.tunicorn.marketing.vo.GoodsSkuVO;
import com.tunicorn.marketing.vo.UserVO;
import com.tunicorn.util.MessageUtils;

@Controller
@RequestMapping("/admin/sku")
@EnableAutoConfiguration
public class SkuController extends BaseController {

	@Autowired
	private GoodsSkuService goodsSkuService;
	@Autowired
	private 
	MajorTypeService majorTypeService;

	@RequestMapping(value = "", method = RequestMethod.GET)
	public String sku(HttpServletRequest request, Model model) {
		UserVO user = getCurrentUser(request);
		model.addAttribute("user", user);

		GoodsSkuBO goodsSkuBO = new GoodsSkuBO();

		List<GoodsSkuVO> goodsSkuVOs = goodsSkuService.getGoodsSkuListByBO(goodsSkuBO);
		int totalCount = goodsSkuService.getGoodsSkuCount(goodsSkuBO);

		model.addAttribute("majorTypes", majorTypeService.getMajorTypeList());
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

		model.addAttribute("majorTypes", majorTypeService.getMajorTypeList());
		model.addAttribute("GoodsSkus", goodsSkuVOs);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("currentPage", goodsSkuBO.getPageNum() + 1);
		return "admin/sku/sku";
	}

	@RequestMapping(value = "/create", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponse createSku(HttpServletRequest request, @RequestBody GoodsSkuVO goodsSku) {
		if (goodsSkuService.getGoodsSkuCountByNameAndMajorType(goodsSku.getName(), goodsSku.getMajorType()) > 0) {
			Message message = MessageUtils.getInstance().getMessage("marketing_goods_sku_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		long result = goodsSkuService.createGoodsSku(goodsSku);
		if (result == 0) {
			Message message = MessageUtils.getInstance().getMessage("marketing_goods_sku_create_failed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		return AjaxResponse.toSuccess(null);
	}

	@RequestMapping(value = "/{goodsSkuId}/update", method = RequestMethod.POST)
	@ResponseBody
	public AjaxResponse updateSku(HttpServletRequest request, @PathVariable("goodsSkuId") long goodsSkuId,
			@RequestBody GoodsSkuVO goodsSku) {
		goodsSku.setId(goodsSkuId);
		GoodsSkuVO GoodsSkuVO = goodsSkuService.getGoodsSkuById(goodsSkuId);
		if (GoodsSkuVO == null) {
			Message message = MessageUtils.getInstance().getMessage("marketing_goods_sku_not_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		goodsSkuService.updateGoodsSku(goodsSku);
		return AjaxResponse.toSuccess(null);
	}

	@RequestMapping(value = "/{goodsSkuId}", method = RequestMethod.DELETE)
	@ResponseBody
	public AjaxResponse deleteGoodsSku(HttpServletRequest request, @PathVariable("goodsSkuId") long goodsSkuId) {
		GoodsSkuVO GoodsSkuVO = goodsSkuService.getGoodsSkuById(goodsSkuId);
		if (GoodsSkuVO == null) {
			Message message = MessageUtils.getInstance().getMessage("marketing_goods_sku_not_existed");
			return AjaxResponse.toFailure(message.getCode(), message.getMessage());
		}
		GoodsSkuVO.setStatus(MarketingConstants.STATUS_DELETED);
		goodsSkuService.updateGoodsSku(GoodsSkuVO);
		return AjaxResponse.toSuccess(null);
	}
}
