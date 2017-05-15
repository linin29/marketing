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

	@Update("update task set task_status= #{taskStatus} where id = #{taskId} and status='active'")
	public int updateTaskStatus(@Param("taskId") String taskId, @Param("taskStatus") String taskStatus);

	public List<TaskVO> getTaskListByVO(TaskVO taskVO);

	public List<TaskVO> getTaskList(TaskBO taskBO);

	public int getTaskCount(TaskBO taskBO);

	public TaskVO getTaskById(@Param("taskId") String taskId);
}
