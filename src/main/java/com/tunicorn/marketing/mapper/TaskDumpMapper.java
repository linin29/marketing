package com.tunicorn.marketing.mapper;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

public interface TaskDumpMapper {

	@Select("select result from task_dump where name = #{fileName}")
	public String getResultByFileName(@Param("fileName") String fileName);


}
