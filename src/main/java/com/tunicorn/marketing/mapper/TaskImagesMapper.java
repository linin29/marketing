package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.tunicorn.marketing.bo.OrderBO;
import com.tunicorn.marketing.vo.TaskImagesVO;

public interface TaskImagesMapper {

	public void batchInsertTaskImages(List<TaskImagesVO> taskImagesVOs);

	@Select("select count(*) from task_images where task_id = #{taskId} and status = 'active'")
	public int getTaskImagesCountByTaskId(@Param("taskId") String taskId);

	public List<TaskImagesVO> getTaskImagesListByTaskId(@Param("taskId") String taskId);

	public TaskImagesVO getTaskImagesById(@Param("taskImageId") String taskImageId);

	public int updateTaskImage(TaskImagesVO imagesVO);

	public int batchUpdateTaskImages(List<OrderBO> imagesVOs);
	
	public TaskImagesVO getPreOrderTaskImage(@Param("taskId") String taskId, @Param("order") int order);
	
	public TaskImagesVO getNextOrderTaskImage(@Param("taskId") String taskId, @Param("order") int order);
}
