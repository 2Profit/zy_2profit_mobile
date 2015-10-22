<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%@ include file="../common/common.jsp"%>
    
    <script type="text/javascript">
    
    	$(function(){
    		
    	});
    </script>
    
</head>
<body>
    <div class="J_dialog J_dialogReply">
        <div style="width: 600px">
            <div class="d_title">
                <div class="t_txt">回复评论</div>
                <div class="t_close">
                    <a data-close="true" href="javascript:;">×</a>
                </div>
            </div>
            <div class="plrb20">
                <div class="d_inner">
                    <div class="i_left">
                        <div class="l_face">
                            <img width="54" height="54" src="${ctx}/static/tmp/face_07.jpg" />
                            <div class="f_hg"></div>
                        </div>
                    </div>
                    <div class="i_right">
                        <textarea id="replayContent"></textarea>
                    </div>
                    <div class="J_toolsBar mt10">
                        <div class="fr">
							<div class="t_text mini">
	                            <label>
	                                <input placeholder="验证码" type="text" id="randomCode2">
	                            </label>
	                        </div>
	                        <div class="ml10 t_code">
	                            <a href="javascript:refresh2();">
	                                <img id="imageCode2" src="${ctx }/imageServlet"/>
	                            </a>
	                        </div>                            
                            <div class="ml10 t_button">
                                <a class="abtn orange" href="javascript:postReplay();">我要回复</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>