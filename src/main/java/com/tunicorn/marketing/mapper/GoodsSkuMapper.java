package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.bo.GoodsSkuBO;
import com.tunicorn.marketing.vo.GoodsSkuVO;

public interface GoodsSkuMapper {

	@Results({ @Result(property = "majorType", column = "major_type"),
			@Result(property = "createTime", column = "create_time"),
			@Result(property = "isShow", column = "is_show") })
	@Select("select id, major_type, `name`, description, `order`, create_time, is_show from goods_sku"
			+ " where major_type = #{majorType} and status='active' order by `order`")
	public List<GoodsSkuVO> getGoodsSkuListByMajorType(@Param("majorType") String majorType);

	@Results({ @Result(property = "majorType", column = "major_type"),
			@Result(property = "createTime", column = "create_time"),
			@Result(property = "isShow", column = "is_show") })
	@Select("select id, major_type, `name`, description, `order`, create_time, is_show from goods_sku"
			+ " where major_type = #{majorType} and is_show=1 and status='active' order by `order`")
	public List<GoodsSkuVO> getGoodsSkuListByMajorTypeWithShow(@Param("majorType") String majorType);

	public int createGoodsSku(GoodsSkuVO goodsSkuVO);

	public int updateGoodsSku(GoodsSkuVO goodsSkuVO);

	public List<GoodsSkuVO> getGoodsSkuListByBO(GoodsSkuBO goodsSkuBO);

	public int getGoodsSkuCount(GoodsSkuBO goodsSkuBO);

	@Select("select count(*) from goods_sku where `name`=#{name} and major_type = #{majorType} and status='active'")
	public int getGoodsSkuCountByNameAndMajorType(@Param("name") String name, @Param("majorType") String majorType);

	@Results({ @Result(property = "majorType", column = "major_type"),
			@Result(property = "createTime", column = "create_time"),
			@Result(property = "isShow", column = "is_show") })
	@Select("select id, major_type, `name`, description, `order`, create_time, is_show from goods_sku"
			+ " where id = #{goodsSkuId} and status='active'")
	public GoodsSkuVO getGoodsSkuById(@Param("goodsSkuId") long goodsSkuId);

	public List<GoodsSkuVO> getGoodsSkuListByMajorTypeAndName(GoodsSkuVO goodsSkuVO);
	
	public List<GoodsSkuVO> getNewGoodsSkuListByBO(GoodsSkuBO goodsSkuBO);
}
