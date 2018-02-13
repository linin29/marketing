package com.tunicorn.marketing.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tunicorn.marketing.vo.MajorTypeVO;

public class GetDiffUtils {

	/**
	 * @TODO 比较preList和currList不同元素，返回currList-preList
	 * @auther weixiaokai
	 * @date 2018年2月12日 下午6:28:27
	 * @param preList
	 * @param currList
	 * @return
	 */
	public static List<Long> getDiffMajorTypeVO(List<MajorTypeVO> preList, List<MajorTypeVO> currList){
		List<Long> diffList = new ArrayList<Long>(preList.size()+currList.size());
		Map<Long, Integer> map = new HashMap<>();
		for (MajorTypeVO majorTypeVO : currList) {
			map.put(majorTypeVO.getId(), 1);
		}
		
		for(MajorTypeVO majorTypeVO : preList){
			if (map.get(majorTypeVO.getId())!=null) {
				map.put(majorTypeVO.getId(), 2);
				continue;
			}
		}
		
		for(Map.Entry<Long, Integer> entry : map.entrySet())  
	        {  
	            if(entry.getValue()==1)  
	            {  
	            	diffList.add(entry.getKey());  
	            }  
	        }  
		return diffList;
	}

}
