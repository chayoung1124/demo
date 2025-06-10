package com.example.demo.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.example.demo.model.BoardVo;
import com.example.demo.model.ReVo;
import com.example.demo.service.BoardService;
import com.example.demo.service.ReService;

@Component
public class SchedulerController {
	@Autowired
	private BoardService s;
	@Autowired
	private ReService r;

	@Scheduled(cron = "0 0/3 * * * *")
	public void masking() {
		System.out.println("스케쥴링 동작" + System.currentTimeMillis());
		BoardVo vo = new BoardVo();
		ReVo re = new ReVo();
		
		s.updateMasking(vo);
		r.updateReMasking(re);
	}
}