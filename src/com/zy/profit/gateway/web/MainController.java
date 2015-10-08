package com.zy.profit.gateway.web;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/main")
public class MainController {

	@RequestMapping
	public String main(HttpServletRequest request, Model model){
		
		return "/main";
	}
	
}
