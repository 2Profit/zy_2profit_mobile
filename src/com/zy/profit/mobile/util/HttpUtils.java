package com.zy.profit.mobile.util;

import java.io.File;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;

import com.zy.member.entity.Member;


/** 
 * 
 * @author LL 
 * 
 */
public class HttpUtils {

	/**
	 * 每页多少条数据
	 * @param request
	 * @return
	 */
	public static Integer getPageSize(HttpServletRequest request){
		String pageSizeStr = request.getParameter("pageSize");
		if(StringUtils.isNotBlank(pageSizeStr) && StringUtils.isNumeric(pageSizeStr.trim())){
			return Integer.parseInt(pageSizeStr.trim());
		}else{
			return null;
		}
	}
	
	/**
	 * 当前页
	 * @param request
	 * @return
	 */
	public static Integer getCurrentPage(HttpServletRequest request){
		String currentPageStr = request.getParameter("currentPage");
		if(StringUtils.isNotBlank(currentPageStr) && StringUtils.isNumeric(currentPageStr.trim())){
			return Integer.parseInt(currentPageStr.trim());
		}else{
			return null;
		}
	}
	
	/**
	 * 当前登录用户
	 * @param request
	 * @return
	 */
	public static Member getMember(HttpServletRequest request){
		return (Member) request.getSession().getAttribute(WebHelper.SESSION_LOGIN_USER);
	}
	
	
	/**
	 * 
	 * @param request
	 * @return
	 */
	public static String getBasePath(HttpServletRequest request){
		return request.getSession().getServletContext().getRealPath("/");
	}
	
	/**
	 * 下载文件
	 * @param fileName
	 * @param fileUrl
	 * @return
	 */
	public static ResponseEntity<byte[]> download(String fileName, String fileUrl){
        File file = new File(fileUrl);  
        HttpHeaders headers = new HttpHeaders();    
        ResponseEntity<byte[]> re = null;
		try {
			String fn = new String(fileName.getBytes("UTF-8"),"iso-8859-1");//为了解决中文名称乱码问题  
			headers.setContentDispositionFormData("attachment", fn);
	        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
	        re = new ResponseEntity<byte[]>(FileUtils.readFileToByteArray(file),    
                    headers, HttpStatus.CREATED);
		} catch (Exception e) {
			e.printStackTrace();
		}
           
        return re;
	}
	
	
}
