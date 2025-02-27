package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.Service.TimeService;

@Controller
public class TestController {

	@Autowired
	private TimeService timeService;

	@RequestMapping(value = "/home")
	public String home() {

		return "index.html";
	}

	@RequestMapping(value = "/getTime", method = { RequestMethod.POST })
	@ResponseBody
	public String getTime() {

		String time = timeService.getTime();
		return time;
	}
}