package com.tunicorn.marketing.job;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.tunicorn.marketing.constant.MarketingConstants;
import com.tunicorn.marketing.service.TrainingStatisticsService;
import com.tunicorn.marketing.utils.ConfigUtils;
import com.tunicorn.marketing.utils.RemoteSSHUtils;
import com.tunicorn.marketing.vo.TrainingStatisticsVO;

@Component
@EnableScheduling
public class TriggerTrainingJob {
	private static Logger logger = Logger.getLogger(TriggerTrainingJob.class);
	private static final int TRAINING_THRESHHOLD = Integer.parseInt(ConfigUtils.getInstance().getConfigValue("training.stat.threshhold"));
	private static final String TRAINING_SCRIPT = ConfigUtils.getInstance().getConfigValue("remote.ssh.script");
	private static int SLEEP_TIME = (int)(Math.random()*100000);
	@Autowired
	TrainingStatisticsService trainingStatisticsService;
	//invoke for each 30 minutes
	@Scheduled(cron = "0 */30 * * * ? ")
    public synchronized void statistics() {
		try {
			logger.info("Trigger job sleep:" + SLEEP_TIME + "ms");
			Thread.sleep(SLEEP_TIME);
		} catch (InterruptedException e) {
			e.printStackTrace();
			logger.error("Transfer job interrupt failed, caused by:" + e.getMessage());
		}
		List<TrainingStatisticsVO> stats = trainingStatisticsService.getTrainingStatisticsList();
		if (stats != null && stats.size() > 0) {
			for (TrainingStatisticsVO stat : stats) {
				logger.info("Type:" + stat.getMajorType() + ";Current size:" + stat.getCount());
				if (stat.getCount() >= TRAINING_THRESHHOLD) {
					String result = RemoteSSHUtils.execute(TRAINING_SCRIPT + stat.getMajorType());
					logger.info("Remote return:" + result);
					if(StringUtils.isNotBlank(result) && result.contains(MarketingConstants.REMOTE_SSH_RETURN)){
						trainingStatisticsService.deleteTrainingStatisticsById(stat.getId());
					}
					logger.info("Trigger trainging for type:" + stat.getMajorType());
				}
			}
		}
	}
}
