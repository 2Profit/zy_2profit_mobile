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
        <div style="width: 5.6rem">
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
                            <img style="width: 1.08rem; height: 1.08rem;" src="${ctx}/static/images/face_03.jpg" />
                            <div class="f_hg"></div>
                        </div>
                    </div>
                    <div class="i_right">
                        <textarea id="replayContent"></textarea>
                    </div>
                    <div class="J_code mt10">
                        <div class="fr">
							<div class="J_code mt10">
	                            <div class="c_inner clearfix">
	                                <div class="i_left">
	                                    <div class="l_input">
											<input placeholder="验证码" type="text" id="randomCode2">	                                        	
	                                    </div>
	                                </div>
	                                <div class="i_right">
	                                    <a href="javascript:refresh2();">
	                                        <img id="imageCode2" src="${ctx }/imageServlet">
	                                    </a>
	                                </div>
	                            </div>
	                        </div>
	                        <div class="J_btnGroup plr20 mt10">
	                            <a class="orange block" href="javascript:postReplay();">我要回复</a>
	                        </div>                            
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>