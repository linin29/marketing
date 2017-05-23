package com.tunicorn.marketing.mapper;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

public interface TaskDumpMapper {

	@Select("select result from task_dump where name = #{fileName} and score >= #{score}")
	public String getResultByFileName(@Param("fileName") String fileName, @Param("score") Double score);


}
