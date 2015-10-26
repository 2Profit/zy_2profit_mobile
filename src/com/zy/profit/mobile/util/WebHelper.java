package com.zy.profit.mobile.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

import org.apache.commons.lang3.StringUtils;

/** 
 * 
 * @author LL 
 * 
 */
public class WebHelper {

	//session中登录的用户
	public static final String SESSION_LOGIN_USER = "login_user";
	
	public static final String SESSION_LOGIN_USER_FULL_NAME = "login_user_full_name";
	
	public static final Integer PAGE_SIZE = 10;
	
	/**
	 * 验证添加和修改时type是否正确
	 * @param type
	 * @throws UtilException 
	 */
	public static void vaildatorType(String type) throws UtilException{
		if(StringUtils.isBlank(type) 
				|| (!"add".equals(type.trim()) && !"update".equals(type.trim()))){
			throw new UtilException("参数有误");
		}
	}
	
	public static final DateFormat dfYMDHM = new SimpleDateFormat("yyyy-MM-dd hh:mm");
	
}
