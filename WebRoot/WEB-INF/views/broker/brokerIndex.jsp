<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<%@ include file="common/common.jsp"%>
<script type="text/javascript">
	
</script>
</head>

<script type="text/javascript">
	$(function() {

	});

	function productTypeQuery(productType){
		window.location.href="${ctx }/bk/list?productType="+productType;
	}
	
	function commissionQuery(orderByParam){
		window.location.href="${ctx }/bk/list?orderByParam="+orderByParam;
	}
	
	function supprotQuery(supportParam){
		window.location.href="${ctx }/bk/list?"+supportParam+"="+1;
	}
	
	function exchangeTypeQuery(exchangeType){
		window.location.href="${ctx }/bk/list?exchangeType="+exchangeType;
	}
	
</script>

<body>
	<div data-ui="header" class="J_header">
        <div class="h_center">经纪商</div>

    </div>

 	<form action="" name="form" id="form" method="post" theme="simple">
	    <div data-ui="nav" class="J_nav clearfix">
	        <div class="n_item">
	            <div class="i_default">
	                <div class="d_txt"><a href="javascript:;">产品</a></div>
	                <div class="d_token"></div>
	                <div class="d_token2"></div>
	            </div>
	            <div class="i_menu">
	                <div class="m_title">不限</div>
	                <div class="m_txt"><a href="javascript:;" onclick="productTypeQuery('0')">国际现货金</a></div>
	                <div class="m_txt"><a href="javascript:;" onclick="productTypeQuery('1')">国际现货银</a></div>
	                <div class="m_txt"><a href="javascript:;" onclick="productTypeQuery('2')">港金</a></div>
	                <div class="m_txt"><a href="javascript:;" onclick="productTypeQuery('3')">人民币公斤条</a></div>
	            </div>
	        </div>
	
	        <div class="n_item">
	            <div class="i_default">
	                <div class="d_txt"><a href="javascript:;">返佣</a></div>
	                <div class="d_token"></div>
	                <div class="d_token2"></div>
	            </div>
	            <div class="i_menu">
	                <div class="m_title">综合推荐</div>
	                <div class="m_txt"><a href="javascript:;" onclick="">高返佣推荐</a></div>
	                <div class="m_txt"><a href="javascript:;" onclick="commissionQuery('commissionEurope')">按欧美返佣</a></div>
	                <div class="m_txt"><a href="javascript:;" onclick="commissionQuery('commissionGold')">黄金返佣</a></div>
	                <div class="m_txt"><a href="javascript:;" onclick="commissionQuery('commissionSilver')">白银返佣</a></div>
	                <div class="m_txt"><a href="javascript:;" onclick="commissionQuery('commissionOil')">原油返佣</a></div>
	            </div>
	        </div>
	
	        <div class="n_item">
	            <div class="i_default">
	                <div class="d_txt"><a href="javascript:;">支持</a></div>
	                <div class="d_token"></div>
	                <div class="d_token2"></div>
	            </div>
	            <div class="i_menu">
	                <div class="m_title"><a href="javascript:;" onclick="supprotQuery('isEaSupport')">出金免手续费</a>支持EA</div>
	                <div class="m_txt"><a href="javascript:;">银联入金</a></div>
	                <div class="m_txt"><a href="javascript:;" onclick="supprotQuery('isCloseFee')">出金免手续费</a></div>
	                <div class="m_txt"><a href="javascript:;" onclick="supprotQuery('isOpenFee')">入金免手续费</a></div>
	            </div>
	        </div>
	
	        <div class="n_item">
	            <div class="i_default">
	                <div class="d_txt"><a href="javascript:;">监管机构</a></div>
	                <div class="d_token"></div>
	                <div class="d_token2"></div>
	            </div>
	            <div class="i_menu">
	                <div class="m_title"><a href="javascript:;" onclick="exchangeTypeQuery('')">不限</a></div>
	                <div class="m_txt"><a href="javascript:;" onclick="exchangeTypeQuery('0')">香港金银贸易市场</a></div>
	                <div class="m_txt"><a href="javascript:;" onclick="exchangeTypeQuery('1')">香港证监会</a></div>
	                <div class="m_txt"><a href="javascript:;" onclick="exchangeTypeQuery('2')">英国FCA</a></div>
	                <div class="m_txt"><a href="javascript:;" onclick="exchangeTypeQuery('3')">日本FSA</a></div>
	            </div>
	        </div>
	
	    </div>
	
	
	    <div data-ui="jjsList" class="J_jjsList">
	    
	    	<c:forEach items="${page.list }" var="broker">
		        <div class="j_item">
		            <div class="i_left">
		                <div class="l_pic"><img style="width:60px; height:20px;" src="${ctx}/${broker.imageUrl }" /></div>
		                <div class="l_btn">
		                    <a href="${ctx }/bk/detail?id=${broker.id }">详细信息</a>
		                </div>
		            </div>
		            <div class="i_right">
		                <div class="r_title">${broker.cnName }</div>
		                <div class="r_txt">黃金点差:<span class="cOrange">${broker.pointDiffMinLlg }</span>
		                				       白银点差:<span class="cOrange">${broker.pointDiffMinLls }</span></div>
		
		                <div class="r_txt mt10">黄金返佣:<span class="cOrange">${broker.commissionGold }</span>美元
		                						 杠杆比例: <span class="cOrange">${broker.leverRate }</span> </div>
		                <div class="r_txt">伦敦金最低开仓保证金: <span class="cOrange">${broker.openMoneyLlg }</span>美元</div>
		
		                <div class="r_txt mt10">
                           	<c:if test="${broker.exchangeType == '0' }">金银业贸易场会员</c:if>
                           	<c:if test="${broker.exchangeType == '1' }">证监会会员</c:if>
                           	<c:if test="${broker.exchangeType == '2' }">英国FCA会员</c:if>
                           	<c:if test="${broker.exchangeType == '3' }">日本FSA会员</c:if>
		                </div>
		            </div>
		        </div>
	    	</c:forEach>
	
	    </div>
	
        <div class="j_page">
           	<tr><td colspan="50" style="text-align:center;"><%@ include file="../common/pager.jsp"%></td></tr>
        </div>
	</form>
</body>
</html>
