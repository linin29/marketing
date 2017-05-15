package com.tunicorn.marketing.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tunicorn.marketing.bo.GoodsSkuBO;
import com.tunicorn.marketing.mapper.GoodsSkuMapper;
import com.tunicorn.marketing.vo.GoodsSkuVO;

@Service
public class GoodsSkuService {

	@Autowired
	private GoodsSkuMapper goodsSkuMapper;

	public int createGoodsSku(GoodsSkuVO goodsSkuVO) {
		return goodsSkuMapper.createGoodsSku(goodsSkuVO);
	}

	public int updateGoodsSku(GoodsSkuVO goodsSkuVO) {
		return goodsSkuMapper.updateGoodsSku(goodsSkuVO);
	}

	public List<GoodsSkuVO> getGoodsSkuListByBO(GoodsSkuBO goodsSkuBO) {
		return goodsSkuMapper.getGoodsSkuListByBO(goodsSkuBO);
	}

	public int getGoodsSkuCount(GoodsSkuBO goodsSkuBO) {
		return goodsSkuMapper.getGoodsSkuCount(goodsSkuBO);
	}
}
