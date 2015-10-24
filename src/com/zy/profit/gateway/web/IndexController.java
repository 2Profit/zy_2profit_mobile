package com.zy.profit.gateway.web;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.DisabledAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.zy.broker.dto.BrokerExtInfoDto;
import com.zy.broker.entity.BrokerExtInfo;
import com.zy.broker.service.BrokerExtInfoService;
import com.zy.common.entity.PageModel;
import com.zy.common.util.AjaxResult;
import com.zy.common.util.BaseUtils;
import com.zy.common.util.DateUtils;
import com.zy.member.entity.Member;
import com.zy.member.entity.MemberCode;
import com.zy.member.service.MemberCodeService;
import com.zy.member.service.MemberService;
import com.zy.profit.gateway.util.HttpUtils;
import com.zy.profit.gateway.util.SMSAPI;
import com.zy.profit.gateway.util.SystemConfig;
import com.zy.util.Md5Util;
import com.zy.vote.service.VoteTopicService;


/**
 * 登录页
 * @author LL
 *
 */
@Controller
public class IndexController {

	@Autowired
	private MemberService memberService;
	
	@Autowired
	private MemberCodeService memberCodeService;
	@Autowired
	private VoteTopicService voteTopicService;
	@Autowired
	private BrokerExtInfoService brokerExtInfoService;
	
	@RequestMapping("/index")
	public String index(Model model){
		
		model.addAttribute("brokers", 
				brokerExtInfoService.queryPage(new BrokerExtInfoDto(), new PageModel<BrokerExtInfo>(6)));
		
		return "/index";
	}
	
	@RequestMapping("/register")
	public String register(HttpServletRequest request, Model model){
		model.addAttribute("msg", request.getParameter("msg"));
		return "/register";
	}
	
	@RequestMapping("/register/send_msg")
	@ResponseBody
	public AjaxResult sendCode(HttpServletRequest request){
		AjaxResult ajaxResult = new AjaxResult();
		ajaxResult.setSuccess(false);
		try {
			String mobile = request.getParameter("mobile");
			
			String code = BaseUtils.getNumr(4);
			String msg = SMSAPI.sendRegisterCode(mobile, code);
			if(msg == null){
				MemberCode memberCode = new MemberCode();
				memberCode.setMobile(mobile);
				memberCode.setCode(code);
				
				memberCodeService.save(memberCode);
				
				ajaxResult.setSuccess(true);
			}else{
				ajaxResult.setMsg(msg);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return ajaxResult;
	}

	@RequestMapping(value="/register/vaild_email")
	@ResponseBody
	public AjaxResult validEmail(HttpServletRequest request){
		
		AjaxResult ajaxResult = new AjaxResult();
		
		String retMsg = "";
		
		String email = request.getParameter("email");
		
		int ret = memberService.vaildUserByEmail(email);
		if(ret > 0){
			retMsg = "该电子邮箱已经被绑定";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		if(StringUtils.isNotBlank(retMsg)){
			map.put("error", retMsg);
		}else{
			map.put("ok", "");
		}
		ajaxResult.setData(map);
		
		return ajaxResult;
	}
	
	@RequestMapping(value="/register/vaild_mobile")
	@ResponseBody
	public AjaxResult validMobile(HttpServletRequest request){
		
		AjaxResult ajaxResult = new AjaxResult();
		
		String retMsg = "";
		
		String mobile = request.getParameter("mobile");
		
		int ret = memberService.vaildUserByMobile(mobile);
		if(ret > 0){
			retMsg = "该手机号已经被注册";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		if(StringUtils.isNotBlank(retMsg)){
			map.put("error", retMsg);
		}else{
			map.put("ok", "");
		}
		ajaxResult.setData(map);
		
		return ajaxResult;
	}
	
	@RequestMapping("/register/vaild_nick_name")
	@ResponseBody
	public AjaxResult vaildNickName(HttpServletRequest request){
		
		AjaxResult ajaxResult = new AjaxResult();
		
		String retMsg = "";
		
		String nickName = request.getParameter("nickName");
		
		int ret = memberService.vaildUserByNickName(nickName);
		if(ret > 0){
			retMsg = "该昵称已经被使用";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		if(StringUtils.isNotBlank(retMsg)){
			map.put("error", retMsg);
		}else{
			map.put("ok", "");
		}
		ajaxResult.setData(map);
		
		return ajaxResult;
	}
	
	@RequestMapping("/register/save")
	public String registerSave(Member member, RedirectAttributes redirectAttributes, HttpServletRequest request){
		
		String msg = "";
		
		member.setMobile(StringUtils.trim(member.getMobile()));
		
		//判断短信验证码
		List<MemberCode> memberCodes = memberCodeService.findCodesByMobile(member.getMobile());
		MemberCode memberCode = null;
		if(memberCodes == null || memberCodes.isEmpty()){
			msg = "短信验证码错误";
		}else{
			
			memberCode = memberCodes.get(0);
			Date currentDate = new Date();
			
			String code = request.getParameter("code").trim();
			if(!code.equals(memberCode.getCode())){
				msg = "短信验证码错误";
			}else{
				if(DateUtils.addMinutes(memberCode.getCreateDate(), SystemConfig.getSMSVaildTimeInt()).before(currentDate)){
					msg = "短信验证码已过期，请重新注册";
				}
			}
			
		}
		
		int ret = memberService.vaildUserByMobile(member.getMobile());
		if(ret > 0){
			msg = "注册失败，请重新再试";
		}
		
		if(StringUtils.isNotBlank(msg)){
			redirectAttributes.addAttribute("msg", msg);
			return "redirect:/register";
		}
		
		member.setAccountCategory(Member.ACCOUNT_CATEGORY_CUSTOMER);
		member.setAccountType(Member.ACCOUNT_TYPE_TRUE);
		member.setPwd(Md5Util.generatePassword(member.getPwd().trim()));
		
		
		memberService.saveMember(member, memberCode);
		redirectAttributes.addAttribute("msg", "注册成功，马上登陆");
		
		return "redirect:/login";
	}
	
	/*@RequestMapping("/register/save")
	@ResponseBody
	public AjaxResult registerSave(Member member, RedirectAttributes redirectAttributes, HttpServletRequest request){
		
		AjaxResult ajaxResult = new AjaxResult();
		ajaxResult.setSuccess(false);
		
		try {

			member.setMobile(member.getMobile().trim());
			member.setNickName(member.getNickName().trim());
			
			//判断短信验证码
			List<MemberCode> memberCodes = memberCodeService.findCodesByMobile(member.getMobile());
			MemberCode memberCode = null;
			if(memberCodes == null || memberCodes.isEmpty()){
				ajaxResult.setMsg("短信验证码错误");
				return ajaxResult;
			}else{
				
				memberCode = memberCodes.get(0);
				Date currentDate = new Date();
				
				if(DateUtils.addMinutes(memberCode.getCreateDate(), SystemConfig.getSMSVaildTimeInt()).before(currentDate)){
					ajaxResult.setMsg("短信验证码已过期，请重新注册");
					return ajaxResult;
				}else{
					String code = request.getParameter("code").trim();
					if(!code.equals(memberCode.getCode())){
						ajaxResult.setMsg("短信验证码错误");;
						return ajaxResult;
					}
				}
				
			}
			
			int ret = memberService.vaildUserByMobile(member.getMobile());
			if(ret > 0){
				ajaxResult.setMsg("注册失败，请重新再试");
				return ajaxResult;
			}
			
			ret = memberService.vaildUserByNickName(member.getNickName());
			if(ret > 0){
				ajaxResult.setMsg("注册失败，请重新再试");
				return ajaxResult;
			}
			
			member.setPwd(Md5Util.generatePassword(member.getPwd().trim()));
			memberService.saveMember(member, memberCode);
			
			ajaxResult.setSuccess(true);
			
		} catch (Exception e) {
			e.printStackTrace();
			ajaxResult.setMsg("注册失败，请重新再试");
			return ajaxResult;
		}
		
		
		return ajaxResult;
	}*/
	
	@RequestMapping("/login")
	public String login(HttpServletRequest request, Model model){
		model.addAttribute("msg", request.getParameter("msg"));
		return "/login";
	}
	
	/**
	 * 登录
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/dologin", method=RequestMethod.POST)
	@ResponseBody
	public AjaxResult doLogin(HttpServletRequest request){
		
		AjaxResult ajaxResult = new AjaxResult();
		ajaxResult.setSuccess(false);
		
		Subject subject = SecurityUtils.getSubject();
		
		String username = request.getParameter("username").trim();
		String pwd = request.getParameter("pwd").trim();
		
		String autoChk = request.getParameter("autoChk");
		boolean rememberMe = false;
		if(StringUtils.isNotBlank(autoChk) && "1".equals(autoChk)){
			rememberMe = true;
		}
		
		UsernamePasswordToken token = new UsernamePasswordToken(username, Md5Util.generatePassword(pwd), rememberMe);
		
		try {
			subject.login(token);
			
			//
			Member member = HttpUtils.getMember(request);
			member.setLastLoginDate(new Date());
			member.setLastLoginIp(request.getRemoteAddr());
			memberService.update(member);
			
			ajaxResult.setSuccess(true);
		} catch (DisabledAccountException dae) {
			dae.printStackTrace();
			ajaxResult.setMsg("账号已被删除");
		} catch (AuthenticationException e) {
			e.printStackTrace();
			ajaxResult.setMsg("账号或密码错误");
		}
		token.clear();
		
		return ajaxResult;
		
	}
	
	/**
	 * 注销
	 * @return
	 */
	@RequestMapping("/login_out")
	public String loginOut(HttpServletRequest request){
		
		Subject subject = SecurityUtils.getSubject();
		subject.logout();
		
		return "redirect:/login";
	}
}