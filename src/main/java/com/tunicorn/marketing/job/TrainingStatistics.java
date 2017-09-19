package com.tunicorn.marketing.job;

import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@EnableScheduling
public class TrainingStatistics {
	
	//每隔10分钟调用一次此方法
	@Scheduled(cron = "0 */1 * * * ? ")
    public void statistics() {
		System.out.println("statistics");
	}
}
