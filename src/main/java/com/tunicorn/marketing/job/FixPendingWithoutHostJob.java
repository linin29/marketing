package com.tunicorn.marketing.job;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.tunicorn.marketing.api.MarketingAPI;
import com.tunicorn.marketing.api.param.MarketingStitcherRequestParam;
import com.tunicorn.marketing.service.TaskService;
import com.tunicorn.marketing.vo.TaskVO;

@Component
@EnableScheduling
public class FixPendingWithoutHostJob {
	private static Logger logger = Logger.getLogger(FixPendingWithoutHostJob.class);
	private static int SLEEP_TIME = (int)(Math.random()*100000);
	@Autowired
	TaskService taskService;
	//invoke for each hour
	@Scheduled(cron = "0 0 */1 * * ? ")
    public synchronized void fixPendingStatus() {
		try {
			logger.info("Fix pending status job sleep:" + SLEEP_TIME + "ms");
			Thread.sleep(SLEEP_TIME);
		} catch (InterruptedException e) {
			e.printStackTrace();
			logger.error("Fix pending status interrupt failed, caused by:" + e.getMessage());
		}
		List<TaskVO> tasks = taskService.getPendingWithoutHost();
		if (tasks != null && tasks.size() > 0) {
			logger.info("Total size of pending without host:" + tasks.size());
			for (TaskVO task : tasks) {
				MarketingStitcherRequestParam param = new MarketingStitcherRequestParam();
				String majorType = task.getMajorType();
				String taskId = task.getId();
				boolean needStitch = true;
				int stitchNumber = task.getNeedStitch();
				if (stitchNumber == 0) {
					needStitch = false;
				}
				param.setNeed_stitch(needStitch);
				param.setMajor_type(majorType);
				param.setTask_id(taskId);
				logger.info("taskId:" + taskId + ", params of stitcher server: " + param.convertToJSON());
				MarketingAPI.stitcher(param);
			}
		}
	}
}
