package com.gdu.semi.batch;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.gdu.semi.service.UserService;

@EnableScheduling
@Component
public class SleepUserScheduler {
	
	@Autowired
	private UserService userService;
	
	// 매일  자정
	@Scheduled(cron="0 0 0 * * *")
	public void execute() {
		userService.sleepUserHandle();
		System.out.println("휴면되엇서");
	}
}
