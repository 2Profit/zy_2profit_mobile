<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

	<%@ include file="common/common.jsp"%>

</head>

<script type="text/javascript">jc.rem.on();</script>

<script type="text/javascript">

$(function(){
	
	
});

function mySubmit(){
	
	var username = $('#loginForm input[name="username"]').val();
	if(!username){
		layer.alert('请输入账号', function(){
			$('#loginForm input[name="username"]').focus();
		});
		return;
	}
	
	var pwd = $('#loginForm input[name="pwd"]').val();
	if(!pwd){
		layer.alert('请输入密码', function(){
			$('#loginForm input[name="pwd"]').focus();
		});
		return;
	}
	
	var lIdx = layerLoading();
	
	$('#loginForm').ajaxSubmit({
		success : function(result){
			layer.close(lIdx);
			if(result.success){
				window.location.href = '${ctx}/bk/list';
			}else{
				layer.alert(result.msg);
			}
		}
	});
}

</script>

<body>
    
   <div data-ui="header" class="J_header">
        <div class="h_left"><a href="javascript:void(0);"></a></div>
        <div class="h_center">立即登录</div>

    </div>

	<form action="${ctx }/dologin" id="loginForm" method="post">
		<input type="hidden" name="openid" value=""/>
	    <div class="J_form">
	        <div class="f_item">
	            <div class="i_left">
	                <div class="l_txt">帐号</div>
	            </div>
	            <div class="i_right">
	                <input placeholder="手机号或邮箱" type="text" name="username"/>
	            </div>
	        </div>
	        <div class="f_item">
	            <div class="i_left">
	                <div class="l_txt">密码</div>
	            </div>
	            <div class="i_right">
	                <input placeholder="6-32位字母数字组合" type="password" name="pwd"/>
	            </div>
	        </div>
	    </div>
    </form>
    
    <div class="J_error">${msg }</div>


    <div class="J_btnGroup">
        <a class="orange" href="javascript:mySubmit();">立即登录</a>
    </div>



</body>
</html>
