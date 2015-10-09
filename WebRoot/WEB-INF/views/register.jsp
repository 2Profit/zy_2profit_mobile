<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<%@ include file="common/common.jsp"%>
<script type="text/javascript">
	jc.rem.on();
</script>
</head>

<script type="text/javascript">
	$(function() {

	});

	function mySubmit() {
		//验证输入信息完整性
		var mobile = $('input[name="mobile"]').val();
		var code = $('input[name="code"]').val();
		var pwd = $('input[name="pwd"]').val();
		
		if(!checkMobile(mobile)){
			layerAlert('手机号码格式不正确');
			$('input[name="mobile"]').focus();
			return;
		}
		if(!code){
			layerAlert('请输入验证码');
			$('input[name="code"]').focus();
			return;
		}
		if(!checkPwd(pwd)){
			layerAlert('密码由8-16位数字、字母组成');
			$('input[name="pwd"]').focus();
			return;
		}
		
		$('#registerForm').submit();
	}

	var codeTimer = null;

	function sendCode(_this) {

		var $sendBtn = $(_this);
		if ($sendBtn.attr('data-status') == 'no') {
			return;
		}

		var mobile = $('input[name="mobile"]').val();
		if(checkMobile(mobile)){
			
			$.ajax({
				url : '${ctx}/register/vaild_mobile',
				data : {
					mobile : mobile
				},
				async : false,
				success : function(result){
					if(!result.data.error){
						var seconds = 59;
						$sendBtn.removeClass('blue').addClass('gray').html(
								"重新获取 ( 60 ) ");
						$sendBtn.attr('data-status', 'no');
						
						//调用短信接口
						$.ajax({
							url : '${ctx}/register/send_msg',
							data : {
								'mobile' : $('input[name="mobile"]').val()
							},
							async : false,
							success : function(result) {
								
							}
						});

						codeTimer = setInterval(function() {
							if (seconds < 0) {
								clearInterval(codeTimer);
								$sendBtn.removeClass('gray').addClass('blue')
										.html('获取手机验证码');
								$sendBtn.attr('data-status', 'yes');
							} else {
								$sendBtn.html('重新获取 ( ' + (seconds--) + ' )');
							}
						}, 1000);
					}else{
						layerAlert('手机号码已经注册');
					}
				}
			});
		}else{
			layerAlert('手机号码格式错误');
		}
		
	}
</script>

<body>
	<div data-ui="header" class="J_header">
		<div class="h_left">
			<a href="javascript:void(0);"></a>
		</div>
		<div class="h_center">立即注册</div>

	</div>
	<form action="${ctx}/register/save" id="registerForm" method="post">
		<div class="J_form">
			<div class="f_item">
				<div class="i_left">
					<select>
						<option value="86">+86</option>
						<option value="201">+201</option>
						<option value="202">+202</option>
					</select>
				</div>
				<div class="i_right">
					<input placeholder="手机号" type="text" name="mobile"/>
					
	                <a class="r_btn blue" href="javascript:void(0);" data-status="yes" onclick="sendCode(this)">获取验证码</a>
	               	
				</div>
			</div>
			<div class="f_item">
				<div class="i_left">
					<div class="l_txt">验证码</div>
				</div>
				<div class="i_right">
					<input placeholder="请输入验证码" type="text" name="code"/>
				</div>
			</div>
			<div class="f_item">
				<div class="i_left">
					<div class="l_txt">密码</div>
				</div>
				<div class="i_right">
					<input placeholder="8-16位数字、字母组成" type="password" name="pwd"/>
				</div>
			</div>
	
		</div>
	</form>
	
	<div class="J_error">${msg }</div>
	
	<div class="J_btnGroup">
		<a class="orange" href="javascript:void(0);" onclick="mySubmit()">立即注册</a>
	</div>

</body>
</html>
