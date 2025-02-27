package com.example.demo.Service;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Service
public class TimeService {
	

	public String getTime() {
		Date d = new Date();
		SimpleDateFormat df = new SimpleDateFormat("HH시 mm분 ss초");
		String formattedDate = df.format(d);
		return formattedDate;
	}
}