package com.tunicorn.marketing.job;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.tunicorn.marketing.service.TrainingStatisticsService;
import com.tunicorn.marketing.utils.ConfigUtils;
import com.tunicorn.marketing.utils.RemoteSSHUtils;
import com.tunicorn.marketing.vo.TrainingStatisticsVO;

@Component
@EnableScheduling
public class TrainingStatistics {
	private static Logger logger = Logger.getLogger(TrainingStatistics.class);
	private static final int TRAINING_THRESHHOLD = Integer.parseInt(ConfigUtils.getInstance().getConfigValue("training.stat.threshhold"));
	private static final String TRAINING_SCRIPT = ConfigUtils.getInstance().getConfigValue("remote.ssh.script");
	@Autowired
	TrainingStatisticsService trainingStatisticsService;
	//invoke for each 10 minutes
	@Scheduled(cron = "0 */10 * * * ? ")
    public synchronized void statistics() {
		List<TrainingStatisticsVO> stats = trainingStatisticsService.getTrainingStatisticsList();
		if (stats != null && stats.size() > 0) {
			for (TrainingStatisticsVO stat : stats) {
				logger.info("Type:" + stat.getMajorType() + ";Current size:" + stat.getCount());
				if (stat.getCount() >= TRAINING_THRESHHOLD) {
					String result = RemoteSSHUtils.execute(TRAINING_SCRIPT);
					logger.info("Remote return:" + result);
					trainingStatisticsService.deleteTrainingStatisticsById(stat.getId());
					logger.info("Trigger trainging for type:" + stat.getMajorType());
				}
			}
		}
	}
}
