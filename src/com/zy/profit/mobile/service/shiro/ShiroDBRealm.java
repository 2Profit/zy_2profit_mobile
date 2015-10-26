package com.zy.profit.mobile.service.shiro;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;

import com.zy.member.entity.Member;
import com.zy.member.service.MemberService;
import com.zy.profit.mobile.util.WebHelper;

/** 
 * 自定义Shiro的realm
 * @author LL 
 * 
 */
public class ShiroDBRealm extends AuthorizingRealm {

	@Autowired
	private MemberService memberService;
	
	/**
	 * 当前登录的subject授予角色、权限
	 */
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
		
//		InsUser user = (InsUser) principals.fromRealm(getName()).iterator().next();
//		
//		Set<InsRole> roles = user.getRoles();
//		if(roles != null && !roles.isEmpty()){
//			SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
//			for(InsRole r : roles){
//				info.addRole(r.getId());
//			}
//			return info;
//		}
		
		return null;
	}

	/**
	 * 验证当前用户
	 */
	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(
			AuthenticationToken authcToken) throws AuthenticationException {

        UsernamePasswordToken token = (UsernamePasswordToken)authcToken;
        
        if(StringUtils.isEmpty(token.getUsername())){
        	return null;
        }
        
        Member member = memberService.findMemberByLogin(token.getUsername());
        
        if(member != null){
        	AuthenticationInfo authcInfo = new SimpleAuthenticationInfo(token.getUsername(), member.getPwd(), getName());
        	
        	Subject subject = SecurityUtils.getSubject();
        	subject.getSession().setAttribute(WebHelper.SESSION_LOGIN_USER, member);
        	
        	return authcInfo;
        }else{
        	return null;
        }
	}

//	private Set<InsRole> getRole(InsUser user){
//		
//		int ut = user.getUserType().intValue();
//		Set<InsRole> roles = user.getRoles();
//		
//		if(roles == null || roles.isEmpty()){
//			InsRole r = new InsRole();
//			if(ut == Constants.USER_TYPE_INS.key.intValue()){
//				//机构
//				r.setId(Constants.ROLE_ID_INS);
//			}else if(ut == Constants.USER_TYPE_SCH.key.intValue()){
//				//学校
//				r.setId(Constants.ROLE_ID_SCH);
//			}else if(ut == Constants.USER_TYPE_TEA.key.intValue()){
//				Teacher teacher = user.getTeacher();
//				if(teacher.getTeacherType().equals(Constants.TEACHER_TYPE_TEA.key)){
//					//辅导老师
//					r.setId(Constants.ROLE_ID_TEA);
//				}else if(teacher.getTeacherType().equals(Constants.TEACHER_TYPE_CLS.key)){
//					//班主任
//					r.setId(Constants.ROLE_ID_CLS_TEA);
//				}
//			}
//			roles = new HashSet<InsRole>();
//			roles.add(r);
//		}
//		
//		return roles;
//	}
	
	
}
