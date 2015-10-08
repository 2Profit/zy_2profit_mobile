package com.zy.profit.gateway.util;

import java.util.HashMap;

import com.cloopen.rest.sdk.CCPRestSmsSDK;

/**
 * 短信接口
 * @author Administrator
 *
 */
public class SMSAPI {

	private static CCPRestSmsSDK restAPI = new CCPRestSmsSDK();
	
	static{
		restAPI.init(SystemConfig.getSMSRestURL(), "8883");
		restAPI.setAccount(SystemConfig.getSMSSID(), SystemConfig.getSMSToken());
		restAPI.setAppId(SystemConfig.getSMSAPPID());
	}
	
	/**
	 * 
	 * @param mobile
	 * @param code
	 * @return
	 */
	public static String sendRegisterCode(String mobile, String code){
		
		HashMap<String, Object> result = restAPI.sendTemplateSMS(mobile,SystemConfig.getSMSModelId() ,new String[]{code,SystemConfig.getSMSVaildTime()});
		
		if("000000".equals(result.get("statusCode"))){
			//正常返回输出data包体信息（map）
			HashMap<String,Object> data = (HashMap<String, Object>) result.get("data");
			return null;
		}else{
			//异常返回输出错误码和错误信息
			Object obj = result.get("statusMsg");
			return obj == null ? "" : obj.toString();
		}
		
	}
	
}
