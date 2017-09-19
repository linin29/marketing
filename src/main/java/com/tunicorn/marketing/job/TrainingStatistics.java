package com.tunicorn.marketing.job;

import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.tunicorn.marketing.service.TrainingStatisticsService;
import com.tunicorn.marketing.utils.RemoteSSHUtils;
import com.tunicorn.marketing.vo.TrainingStatisticsVO;

@Component
@EnableScheduling
public class TrainingStatistics {
	private static Logger logger = Logger.getLogger(TrainingStatistics.class);
	private static final int TRAINING_THRESHHOLD = 2;
	private static final String TRAINING_SCRIPT = "";
	@Autowired
	TrainingStatisticsService trainingStatisticsService;
	//invoke for each 10 minutes
	@Scheduled(cron = "0 */10 * * * ? ")
	@Transactional
    public synchronized void statistics() {
		List<TrainingStatisticsVO> stats = trainingStatisticsService.getTrainingStatisticsList();
		if (stats != null && stats.size() > 0) {
			for (TrainingStatisticsVO stat : stats) {
				logger.info("Type:" + stat.getMajorType() + ";Current size:" + stat.getCount());
				if (stat.getCount() >= TRAINING_THRESHHOLD) {
					RemoteSSHUtils.execute(TRAINING_SCRIPT);
					trainingStatisticsService.deleteTrainingStatisticsById(stat.getId());
					logger.info("Trigger trainging for type:" + stat.getMajorType());
				}
			}
		}
	}
}
