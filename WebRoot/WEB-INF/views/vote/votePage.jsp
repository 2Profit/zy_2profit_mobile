<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<%@ include file="../common/common.jsp"%>

<script type="text/javascript">

var globalPostId = '';
$(function(){
	
	jc.rem.on();
	
	$('a[name="doVote_href"]').bind('click',function(event){
		event.preventDefault();
		
		$.post(
	       	"${ctx }/vote/randomValidate",
	       	{randomCode:$('#randomCode').val()},
	       	function(json) {
	       		if(json.success){
	       			if($('#isVoteTime').val()=='false'){
	       				layerAlert('当前不是投票有效期，谢谢');
	       				return false;
	       			}
	       			var optionId = $("input[type='radio']:checked").val();
	       			if(optionId == null || optionId == ''){
	       				layerAlert('请选择投票选项');
	       				return false;
	       			}
	       			$.ajax({
	       				type: "POST",
	       	           	url:"${ctx }/vote/doVote",
	       	        	data:{'voteTopic.id':$('#currentTopicId').val(),id:optionId},
	       	        	async: false,
	       	        	success:function(json) {
	       	           		if(json.success){
	       	           			layerAlert('投票成功', function(b){
	       	           				window.location.replace("${ctx }/vote/link?id="+$('#currentTopicId').val());
	       	           			});
	       	           		}else{
	       	           			if(json.code=='401'){
	       	           				layerAlert('请勿重复投票！')
	       	           			}else{
	       	           				layerAlert('失败');
	       	           			}
	       	           		}
	       	           	}    
	       			});	
	       		}else{
	       			if(json.code=='404'){
	       				layerAlert('验证码错误!');
		    			return false;
	       			}
	       		}
	       	}    
	    );
	});
	
	$('a[name="doPost_href"]').bind('click',function(event){
		event.preventDefault();
		
		if($.trim($('textarea[name=postContent]').val()) == ''){
			layerAlert('发表内容不能为空！');return false;
		}
		
		$.ajax({                                                 
	        type: "POST",                                     
	        url: "${ctx}/vote/doPost",
	        async: false,
	        data:{"voteTopic.id":$('#currentTopicId').val(),"postContent":$('textarea[name=postContent]').val()},
	        success: function(json){   
	          	if(json.success){
	          		layerAlert('回复成功', function(b){
	          			window.location.href="${ctx}/vote/index/list";
	          		});
	          	}else{
	          		if(json.code == "406"){layerAlert('抱歉，该投票停止评论！'); return false;}
	          		layerAlert('回复失败'); 
	          	}
	        }   
	   	});
	});
	
});

/*第一种形式 第二种形式 更换显示样式*/
function setTab(name, cursel, n) {
    for (var i = 1; i <= n; i++) {
        var menu = document.getElementById(name + i);
        var con = document.getElementById("con_" + name + "_" + i);
        menu.className = i == cursel ? "t_txt active" : "t_txt";
        con.style.display = i == cursel ? "block" : "none";
    }
}

function doPraise(obj,postId){
	$.post("${ctx }/vote/doPraise",
    	{id:postId},
    	function(json) {
       		if(json.success){
       			layerAlert('点赞成功', function(b){
	  				$(obj).children('span').text(json.message);
       			});
       		}else{
       			if(json.code=='405'){layerAlert('请先登录！');return false;}
       			if(json.code=='402'){layerAlert('请勿重复点赞！');return false;}
       			layerAlert('点赞失败');
       		}
       	}    
	);
}
function doReplayPraise(obj,replayId){
	$.post(
        "${ctx }/vote/doReplayPraise",
    	{id:replayId},
    	function(json) {
       		if(json.success){
       			layerAlert('点赞成功', function(b){
	  				$(obj).children('span').text(json.message);
       			});
       		}else{
       			if(json.code=='405'){ layerAlert('请先登录！');return false;}
       			if(json.code=='402'){ layerAlert('请勿重复点赞！');return false;}
       			layerAlert('点赞失败');
       		}
       	}    
	);
}

function doReport(obj,postId){
	$.post(
       	"${ctx }/vote/doReport",
    	{id:postId},
    	function(json) {
       		if(json.success){
       			layerAlert('举报成功', function(b){
       				$(obj).text("举报("+json.message+")");
       			});
       		}else{
       			if(json.code=='405'){ layerAlert('请先登录！');return false;}
       			if(json.code=='403'){ layerAlert('请勿重复举报！');return false;}
       			layerAlert('举报失败');
       		}
       	}    
	);
}
function doReplayReport(obj,replayId){
	$.post(
       	"${ctx }/vote/doReplayReport",
    	{id:replayId},
    	function(json) {
       		if(json.success){
       			layerAlert('举报成功', function(b){
       				$(obj).text("举报("+json.message+")");
       			});
       		}else{
       			if(json.code=='405'){ layerAlert('请先登录！');return false;}
       			if(json.code=='403'){ layerAlert('请勿重复举报！');return false;}
       			layerAlert('举报失败');
       		}
       	}    
	);
}


function showDialog(postId) {
	
	globalPostId = postId;
	
    jc.dialog.get("${ctx}/vote/replayDialog", function (obj) {
        obj.show();
    }, "token_21");
}

function postReplay(){
	if($('#randomCode2').val() == ''){
		layerAlert('请输入验证码！');return false;
	}
	$.post(
       	"${ctx }/vote/randomValidate",
       	{randomCode:$('#randomCode2').val()},
       	function(json) {
       		if(json.success){
       			if($('#replayContent').val() ==''){
       				layerAlert('回复内容不能为空！');return false;
       			}
       			$.post("${ctx}/vote/doReplay",
   					{'voteTopic.id':$('#currentTopicId').val(),'voteTopicPost.id':globalPostId,
   						'replayContent':$('#replayContent').val()},
   					function(json){
   						if(json.success){
   							window.location.href="${ctx}/vote/link?id="+$('#currentTopicId').val();
   						}else{
   							if(json.code == '405'){
   								layerAlert('请登录后再回复！');return false;
   							}
   							layerAlert('回复失败');
   						}
   					}
   				);       			
       		}else{
       			layerAlert('验证码错误！');return false;
       		}
       	}
	);
}

function countWords(){
	var numb = 255 - parseInt($('textarea[name=postContent]').val().length);
	if(numb<0){
		var subStr = $('textarea[name=postContent]').val().substr(0,255);
		$('textarea[name=postContent]').val(subStr);
		return;
	}
	$('#countWords_span').text(numb);
}

function refresh() {
    $("#imageCode").attr("src","${ctx}/imageServlet?"+Math.random());
}
function refresh2() {
    $("#imageCode2").attr("src","${ctx}/imageServlet?"+Math.random());
}

</script>

</head>

<body>

    <div data-ui="header" class="J_header">
        <div class="h_center">投票</div>

    </div>
    <div class="J_tableTitle">本期投票
       	<input type="hidden" id="isVoteTime"  value="${currentTopic.isVoteTime }">
    	<input type='hidden' id='currentTopicId' value='${currentTopic.id}'> 
    </div>


    <div class="J_vote">
        <div class="v_title">${currentTopic.titleContent}</div>
        <div class="v_content">
			<c:forEach items="${currentTopic.options }" var="option">
          		<div class="c_item">
                  <a href="javascript:">
                  	 <label><input type="radio" name="currentTopic_radio" value="${option.id }"/>${option.optionContent }</label></a>
              	</div>
          	</c:forEach>        
        </div>
    </div>

    <div class="J_tableTitle">本期投票结果（<span class="cOrange">${currentTopic.voteCount}</span>人参与）</div>

    <div class="bgfff">
        <div class="J_voteSuccess">
        	<c:forEach items="${currentTopic.options }" var="option">
	            <div class="v_item">
	          		<div class="i_left">${option.optionContent }</div>
					<div class="i_right">
	            		<c:choose>
	           				<c:when test="${currentTopic.voteCount == null || currentTopic.voteCount == 0 }">
								<div style="width:0%; background-color: #ee6a53;" class="r_bar">
	                   				<div class="b_txt">0%</div>
	                   			</div>                    					
	           				</c:when>
	           				<c:otherwise>
	                  			<div style="width:<fmt:formatNumber type='number' value='${option.voteCount*100/currentTopic.voteCount}' maxFractionDigits='0'/>%; background-color: #ee6a53;" class="r_bar">
	                  				<div class="b_txt"><fmt:formatNumber type="number" value="${option.voteCount*100/currentTopic.voteCount}" maxFractionDigits="0"/>%</div>
	                  			</div>
	                  		</c:otherwise>
	           			</c:choose>
	           		</div>            
	            </div>
	       	</c:forEach>
        </div>

        <div class="J_code mt10">
            <div class="c_inner clearfix">
				<div class="i_left">
                      <div class="l_input">
                          <input placeholder="验证码" type="text" id="randomCode">
                      </div>
                 </div>
                 <div class="i_right">
                      <a href="javascript:refresh();">
                          <img id="imageCode" src="${ctx }/imageServlet" width="120" height="100"/>
                   	  </a>
               	</div>
            </div>
        </div>
        <div class="J_btnGroup">
            <a class="orange" href='' name="doVote_href">我要投票</a>
        </div>
    </div>

    <div class="J_tableTitle">过往投票</div>

    <div class="J_more">
    	<c:forEach items="${historyTopics }" var="historyTopic">
	        <div class="m_item">
	            <div class="i_left">
	                <a href="${ctx }/vote/link?id=${historyTopic.id}"">${historyTopic.titleContent }<span>${historyTopic.voteCount }</span></a>
	            </div>
	            <div class="i_right"><fmt:formatDate value="${historyTopic.startDate}" pattern="yyyy-MM-dd"/></div>
	        </div>
        </c:forEach>    
    </div>

    <div class="J_tableTitle">用户评论</div>

    <div class="J_tab">
        <div class="t_title">
            <div id="one1" onclick="setTab('one',1,2)" class="t_item active">全部评论（${currentTopic.postCount}）</div>
            <div id="one2" onclick="setTab('one',2,2)" class="t_item">我的回复（${currentUserPostNumb}）</div>
        </div>
        <div class="t_main">
            <div id="con_one_1" style="display: block;" class="m_item">
                <div data-ui="commentsList" class="J_commentsList">
                	<c:forEach items="${page.list }" var="post">
	                    <div class="c_item"> 
	                        <div class="i_left">
	                            <div class="l_img">
	                                <img src="${ctx }/static/images/face_03.jpg">
	                            </div>
	                            <div class="l_hg"></div>
	                        </div>
	                        <div class="i_right">
	                            <div class="r_info clearfix">
	                                <div class="fl">
	                                    <div class="i_now">${post.floorNumb }楼</div>
	                                    ${fn:substring(post.publisher.mobile, 0, 3)}****${fn:substring(post.publisher.mobile, 8, 11)} 
	                                    		时间: <fmt:formatDate value="${post.createDate}" pattern="yyyy-MM-dd"/>
	                                </div>
	                                <div class="fr">
                                        <a class="i_replyBtn" href="javascript:;" onclick="doPraise(this,'${post.id }')">
                                        	赞(<span>${post.praiseCount}</span>)</a>
                                        <span>| </span>
                                        <a class="i_replyBtn" href="javascript:showDialog('${post.id }');">回复</a>
                                        <span>| </span>
                                        <a class="i_replyBtn" href="javascript:;" onclick="doReport(this,'${post.id }')">举报(${post.reportCount })</a>
	                                </div>
	                            </div>
	                            <div class="r_content">${post.postContent }</div>
	
	                            <div class="r_reply">
	                            	<c:forEach items="${post.postReplays }" var="replay">
		                                <div class="c_item">
		                                    <div class="i_left">
		                                        <div class="l_img">
		                                            <img src="${ctx }/static/images/face_03.jpg">
		                                        </div>
		                                        <div class="l_hg"></div>
		                                    </div>
		                                    <div class="i_right">
		                                        <div class="r_info clearfix">
		                                            <div class="fl">
		                                                ${fn:substring(replay.replayer.mobile, 0, 3)}****${fn:substring(replay.replayer.mobile, 8, 11)} 
		                                                	回复${fn:substring(post.publisher.mobile, 0, 3)}****${fn:substring(post.publisher.mobile, 8, 11)} 
		                                                	时间: <fmt:formatDate value="${replay.createDate}" pattern="yyyy-MM-dd"/>
		                                            </div>
		                                            <div class="fr">
		                                                <a class="i_replyBtn" href="javascript:;" onclick="doReplayPraise(this,'${replay.id }')">
		                                                	赞(<span>${replay.praiseCount}</span>) </a>
		                                                <span>| </span>
		                                                <a class="i_replyBtn" href="javascript:;" onclick="doReplayReport(this,'${replay.id }')">举报(${replay.reportCount })</a>
		                                            </div>		                                            
		                                        </div>
		                                        <div class="r_content">${replay.replayContent }</div>
		                                    </div>
		                                </div>
	                                </c:forEach>
	                            </div>
	                        </div>
                    	</div>
					</c:forEach>                    
                </div>
            </div>
            <div id="con_one_2" class="m_item">
                <div data-ui="commentsList" class="J_commentsList">
                	<c:forEach items="${currentUserPosts }" var="post">
	                    <div class="c_item">
	                        <div class="i_left">
	                            <div class="l_img">
	                                <img src="${ctx }/static/images/face_03.jpg">
	                            </div>
	                            <div class="l_hg"></div>
	                        </div>
	                        <div class="i_right">
	                            <div class="r_info clearfix">
	                                <div class="fl">${fn:substring(post.publisher.mobile, 0, 3)}****${fn:substring(post.publisher.mobile, 8, 11)} 
	                                			时间: <fmt:formatDate value="${post.createDate}" pattern="yyyy-MM-dd"/>
	                                </div>
	                            </div>
	                            <div class="r_content">${post.postContent }</div>
	                        </div>
	                    </div>
					</c:forEach>	                    
                </div>
            </div>
        </div>
    </div>

    <div class="J_tableTitle">我要评论</div>

    <div class="J_reply">
    
    	<c:if test="${empty sessionScope.login_user }">
	        <div class="r_login">
	            <div class="J_btnGroup clearfix more">
	                <a class="orange left" href="${ctx }/login">登录</a>
	                <a class="blue right" href="${ctx }/register">注册</a>
	            </div>
	        </div>
        </c:if>

        <c:if test="${not empty sessionScope.login_user }">
	        <div class="r_notLogin">
	            <textarea name="postContent"></textarea>
	            <div class="J_btnGroup">
	                <a class="orange" href="" name='doPost_href'>回复</a>
	            </div>
	        </div>
        </c:if>
    </div>

</body>
</html>
