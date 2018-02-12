package com.tunicorn.marketing.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.tunicorn.marketing.bo.TaskBO;
import com.tunicorn.marketing.vo.TaskVO;

public interface TaskMapper {

	public int createTask(TaskVO taskVO);

	public int updateTask(TaskVO taskVO);

	@Select("select id, name, task_status, user_id, create_time from task where name = #{taskName} and user_id = #{userId} and status = 'active'")
	public TaskVO getTaskByNameAndUserId(@Param("taskName") String taskName, @Param("userId") String userId);

	@Update("update task set task_status= #{taskStatus},identify_success_times=#{identifySuccessTimes} where id = #{taskId} and status='active'")
	public int updateTaskStatus(@Param("taskId") String taskId, @Param("taskStatus") String taskStatus,
			@Param("identifySuccessTimes") Integer identifySuccessTimes);

	public List<TaskVO> getTaskListByVO(TaskVO taskVO);

	public List<TaskVO> getTaskList(TaskBO taskBO);

	public int getTaskCount(TaskBO taskBO);

	public TaskVO getTaskById(@Param("taskId") String taskId);

	public TaskVO getNextTask(@Param("taskId") String taskId, @Param("userId") String userId);
	
	public List<TaskVO> getTempTaskList(TaskBO taskBO);

	public int getTempTaskCount(TaskBO taskBO);
	
	@Select("select id, major_type as majorType, need_stitch as needStitch "
			+ "from task where task_status='pending' and host is null and status = 'active' limit 200")
	public List<TaskVO> getPendingWithoutHostTasks ();
	
	/**
	 * @TODO 根据项目id获取该项目下的所有图片数量
	 * @auther weixiaokai
	 * @date 2018年2月12日 上午10:38:54
	 * @param projectId
	 * @return
	 */
	@Select("SELECT COUNT(t2.`id`) FROM task t1,task_images t2 WHERE t1.`id`=t2.`task_id` AND t1.`project_id`=#{projectId}")
	public int getTaskImagesByProjectId(@Param("projectId") String projectId);
}
