package com.tunicorn.marketing.job;

import java.text.ParseException;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.tunicorn.marketing.service.ProjectReminderUpdateService;
import com.tunicorn.marketing.service.ProjectService;
import com.tunicorn.marketing.service.StoreService;
import com.tunicorn.marketing.service.TaskService;
import com.tunicorn.marketing.utils.ConfigUtils;
import com.tunicorn.marketing.vo.AdminServiceApplyVO;
import com.tunicorn.marketing.vo.ProjectReminderUpdateVO;
import com.tunicorn.marketing.vo.ProjectVO;
import com.tunicorn.util.DateUtils;
import com.tunicorn.util.EmailUtils;

@Component
@EnableScheduling
public class ProjectReminderJob {
	private static Logger logger = Logger.getLogger(ProjectReminderJob.class);
	private static int SLEEP_TIME = (int)(Math.random()*100000);
	
	@Autowired
	private ProjectReminderUpdateService projectReminderService;
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private TaskService taskService;
	
	@Autowired
	private StoreService storeService;
	/**
	 * 自动提醒，当项目的图片数量，调用量和门店量达到客户设置的阈值时，将自动向客户发送当前使用情况，每天发送一次。
	 */
	//invoke at 12 for each day
	//@Scheduled(cron = "0 */2 * * * ? ")
	@Scheduled(cron = "0 0 12 * * ? ")
    public synchronized void statistics() {
		try {
			logger.info("Project reminder job sleep:" + SLEEP_TIME + "ms");
			Thread.sleep(SLEEP_TIME);
		} catch (InterruptedException e) {
			e.printStackTrace();
			logger.error("Project reminder interrupt failed, caused by:" + e.getMessage());
		}
		List<ProjectVO> projects = projectService.getProjects();
		Date currentDate = new Date();
		String currentDateString = DateUtils.convertDateToString(currentDate, "yyyy-MM-dd");
		for (ProjectVO project : projects) {
			String projectId = project.getId();
			ProjectReminderUpdateVO reminderUpdate = projectReminderService.getProjectReminders(projectId, currentDateString);
			//该项目今天提醒已发送
			if (reminderUpdate != null) {
				continue;
			}
			
			int totalCallCount = project.getCallNumber();
			int totalImageCount = project.getImageNumber();
			int totalStoreCount = project.getStoreNumber();
			float threshhold = project.getThreshhold();
			int currentCallCount = projectService.getAPICallCountByProjectId(projectId);
			int currentImageCount = taskService.getImageCountByProjectId(projectId);
			int currentStoreCount = storeService.getStoreCountByProjectId(projectId);
			if ((currentCallCount/totalCallCount) >= threshhold || 
				(currentImageCount/totalImageCount) >= threshhold ||
				(currentStoreCount/totalStoreCount) >= threshhold) {
				AdminServiceApplyVO service = projectService.getServiceByProjectId(projectId);
				String emailAddress = service.getEmail().trim();
				String emailSubject = ConfigUtils.getInstance().getConfigValue("email.reminder.project.subject");
				StringBuffer emailContent = new StringBuffer();
				emailContent.append("<p>").append(service.getUsername()).append("您好,</p>");
				emailContent.append("<p>您的项目:<strong>").append(project.getName()).append("</strong>,已使用情况如下:</p>");
				emailContent.append("<p>已使用门店数:").append(currentStoreCount).append("(总门店数:").append(totalStoreCount).append(")</p>");
				emailContent.append("<p>已使用调用数:").append(currentCallCount).append("(总调用数:").append(totalCallCount).append(")</p>");
				emailContent.append("<p>已使用图片数:").append(currentImageCount).append("(总图片数:").append(totalImageCount).append(")</p>");
				if (EmailUtils.sendHtmlMail(new String[]{emailAddress}, emailSubject, emailContent.toString())) {
					ProjectReminderUpdateVO update = new ProjectReminderUpdateVO();
					update.setProjectId(projectId);
					update.setRemiderDay(currentDateString);
					projectReminderService.insertReminder(update);//插入该项目今天的发送记录
					projectReminderService.deletePreviousReminder(currentDateString);//删除之前的发送记录
				}
			}
		}
	}
}
