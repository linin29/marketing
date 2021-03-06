package com.tunicorn.marketing.service;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.tunicorn.marketing.bo.GoodsSkuBO;
import com.tunicorn.marketing.mapper.GoodsSkuMapper;
import com.tunicorn.marketing.vo.GoodsSkuVO;

@Service
public class GoodsSkuService {
	private static Logger logger = Logger.getLogger(GoodsSkuService.class);
	@Autowired
	private GoodsSkuMapper goodsSkuMapper;

	@Transactional
	public int createGoodsSku(GoodsSkuVO goodsSkuVO) {
		List<GoodsSkuVO> goodsSkuVOs = goodsSkuMapper.getGoodsSkuListByMajorType(goodsSkuVO.getMajorType());
		if (goodsSkuVOs != null && goodsSkuVOs.size() > 0) {
			GoodsSkuVO goodsSku = goodsSkuVOs.get(goodsSkuVOs.size() - 1);
			goodsSkuVO.setOrder(goodsSku.getOrder() + 1);
		}
		int result = goodsSkuMapper.createGoodsSku(goodsSkuVO);
		logger.info("result of createGoodsSku method: " + result);
		return result;
	}

	@Transactional
	public int updateGoodsSku(GoodsSkuVO goodsSkuVO) {
		return goodsSkuMapper.updateGoodsSku(goodsSkuVO);
	}

	public List<GoodsSkuVO> getGoodsSkuListByBO(GoodsSkuBO goodsSkuBO) {
		return goodsSkuMapper.getGoodsSkuListByBO(goodsSkuBO);
	}

	public int getGoodsSkuCount(GoodsSkuBO goodsSkuBO) {
		return goodsSkuMapper.getGoodsSkuCount(goodsSkuBO);
	}

	public int getGoodsSkuCountByNameAndMajorType(String name, String majorType) {
		return goodsSkuMapper.getGoodsSkuCountByNameAndMajorType(name, majorType);
	}

	public GoodsSkuVO getGoodsSkuById(long goodsSkuId) {
		return goodsSkuMapper.getGoodsSkuById(goodsSkuId);
	}

	public List<GoodsSkuVO> getGoodsSkuListByMajorTypeAndName(String majorType, String name) {
		GoodsSkuVO goodsSkuVO = new GoodsSkuVO();
		goodsSkuVO.setName(name);
		goodsSkuVO.setMajorType(majorType);
		return goodsSkuMapper.getGoodsSkuListByMajorTypeAndName(goodsSkuVO);
	}
}
