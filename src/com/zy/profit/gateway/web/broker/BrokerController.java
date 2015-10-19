package com.zy.profit.gateway.web.broker;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.zy.broker.dto.BrokerExtInfoDto;
import com.zy.broker.entity.BrokerExtInfo;
import com.zy.broker.service.BrokerExtInfoService;
import com.zy.common.entity.PageModel;

@Controller
@RequestMapping("/bk")
public class BrokerController {

	@Autowired
	private BrokerExtInfoService brokerExtInfoService;
	
	@RequestMapping("/list")
	public String brokerIndex(Model model,BrokerExtInfoDto queryDto,PageModel<BrokerExtInfo> pageModel){
		
		model.addAttribute("page", brokerExtInfoService.queryPage(queryDto, pageModel));
		model.addAttribute("queryDto", queryDto);
		
		return "broker/brokerIndex";
	}
	
	@RequestMapping("/detail")
	public String borkerDetail(Model model,BrokerExtInfoDto queryDto){
		
		model.addAttribute("broker", brokerExtInfoService.get(queryDto.getId()));
		
		return "broker/brokerDetail";
	}
	
}
