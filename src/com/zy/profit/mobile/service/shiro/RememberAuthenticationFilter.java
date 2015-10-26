package com.zy.profit.mobile.service.shiro;

import java.util.Date;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authc.FormAuthenticationFilter;
import org.springframework.beans.factory.annotation.Autowired;

import com.zy.member.entity.Member;
import com.zy.member.service.MemberService;
import com.zy.profit.mobile.util.WebHelper;

/**
 * 
 * @author Administrator
 *
 */
public class RememberAuthenticationFilter extends FormAuthenticationFilter {

	@Autowired
	private MemberService memberService;
	
	/**
	 * 判断是否让用户登陆
	 */
	@Override
	protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) {
		
		Subject subject = getSubject(request, response);
		
		//记住密码且没有登陆 session中登录用户是空的
		if(!subject.isAuthenticated() && subject.isRemembered()){
			Session session = subject.getSession();
			if(session.getAttribute(WebHelper.SESSION_LOGIN_USER) == null){
				String username = subject.getPrincipal().toString();
				Member member = memberService.findMemberByLogin(username);
				if(member != null){
					member.setLastLoginDate(new Date());
					member.setLastLoginIp(request.getRemoteAddr());
					session.setAttribute(WebHelper.SESSION_LOGIN_USER, member);	
				}
			}
		}
		
		return subject.isAuthenticated() || subject.isRemembered();
	}

}
