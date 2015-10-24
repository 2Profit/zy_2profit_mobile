<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<%@ include file="../common/common.jsp"%>
<script type="text/javascript">
	
</script>
</head>

<script type="text/javascript">
	$(function() {
		jc.rem.on();
	});

</script>

<body>
    <div data-ui="header" class="J_header">
        <div class="h_left"><a href="${ctx }/bk/list"></a></div>
        <div class="h_center">经纪商详情</div>
    </div>

    <div class="J_jjsInfo">
        <div class="j_logo">
            <img style="width:2rem;" src="${ctx }/${broker.imageUrlH5}" />
            <a href="#">开户返佣</a>
        </div>
        <%-- <div class="j_list">
            <div class="l_title">
                <span>返佣金额</span>
            </div>
            <div class="l_main clearfix">
                <div class="m_item">
                    <div class="i_title">欧美</div>
                    <div class="i_num">${broker.commissionEurope}$</div>
                </div>
                <div class="m_item">
                    <div class="i_title">黄金</div>
                    <div class="i_num">$${broker.commissionGold}$</div>
                </div>
                <div class="m_item">
                    <div class="i_title">白银</div>
                    <div class="i_num">${broker.commissionSilver}$</div>
                </div>
                <div class="m_item">
                    <div class="i_title">原油</div>
                    <div class="i_num">${broker.commissionOil}$</div>
                </div>
            </div>
        </div> --%>
    </div>


    <div class="J_tableTitle">基本信息</div>

    <div class="J_table">
        <table>
            <tbody>
                <tr>
                    <td style="width: 2rem;" class="t_title">中文名称</td>
                    <td>${broker.cnName}</td>
                </tr>
                <tr>
                    <td class="t_title">英文名称</td>
                    <td>${broker.enName}</td>
                </tr>
                <tr>
                    <td class="t_title">会员/监管编号</td>
                    <td>
                       	<c:if test="${broker.exchangeNo1!=null && broker.exchangeNo1!='' }">金银业贸易场(${broker.exchangeNo1}), </c:if>
                       	<c:if test="${broker.exchangeNo2!=null && broker.exchangeNo2!='' }">证监会(${broker.exchangeNo2}), </c:if>
                        <c:if test="${broker.exchangeNo3!=null && broker.exchangeNo3!='' }">英国FCA(${broker.exchangeNo3}), </c:if>
                        <c:if test="${broker.exchangeNo4!=null && broker.exchangeNo4!='' }">日本FSA(${broker.exchangeNo4}), </c:if>
                    </td>
                </tr>
                <tr>
                    <td class="t_title">会员/监管机构</td>
                    <td>
                       	<c:if test="${broker.exchangeNo1!=null && broker.exchangeNo1!='' }">金银业贸易场, </c:if>
                       	<c:if test="${broker.exchangeNo2!=null && broker.exchangeNo2!='' }">证监会, </c:if>
                        <c:if test="${broker.exchangeNo3!=null && broker.exchangeNo3!='' }">英国FCA, </c:if>
                        <c:if test="${broker.exchangeNo4!=null && broker.exchangeNo4!='' }">日本FSA, </c:if>                    
                    </td>
                </tr>
            </tbody>

        </table>
    </div>



    <div class="J_tableTitle">出入金信息</div>
    <div class="J_table">
        <table>
            <tbody>
                <tr>
                    <td style="width: 2rem;" class="t_title">人民币入金</td>
                    <td>
                       	<c:choose>
                       		<c:when test="${broker.isRmbSupport == '0'}">不支持</c:when>
                       		<c:when test="${broker.isRmbSupport == '1'}">支持</c:when>
                       		<c:otherwise>&nbsp;</c:otherwise>
                       	</c:choose>                    
                    </td>
                </tr>
                <tr>
                    <td class="t_title">银联入金</td>
                    <td>
                   		<c:choose>
                    		<c:when test="${broker.isUnionpay == '0'}">不支持</c:when>
                    		<c:when test="${broker.isUnionpay == '1'}">支持</c:when>
                    		<c:otherwise>&nbsp;</c:otherwise>
                    	</c:choose>                     
                    </td>
                </tr>
                <tr>
                    <td class="t_title">出入金免手续费</td>
                    <td>
                    	<c:choose>
                    		<c:when test="${broker.isInOutFree == '1'}">是</c:when>
                    		<c:when test="${broker.isInOutFree == '0'}">否</c:when>
                    		<c:otherwise>&nbsp;</c:otherwise>
                    	</c:choose>                    
                    </td>
                </tr>
                <tr>
                    <td class="t_title">结算币</td>
                    <td>
                    	<c:choose>
                    		<c:when test="${broker.moneyType == '0'}">美元</c:when>
                    		<c:when test="${broker.moneyType == '1'}">人民币</c:when>
                    		<c:when test="${broker.moneyType == '2'}">港币</c:when>
                    		<c:when test="${broker.moneyType == '3'}">混合</c:when>
                    		<c:otherwise>&nbsp;</c:otherwise>
                    	</c:choose>
                    </td>
                </tr>
                <tr>
                    <td class="t_title">伦敦金开户最低存款</td>
                    <td colspan="3">
                    	<c:choose>
                    		<c:when test="${broker.openMoneyLlg!=null}">${broker.openMoneyLlg}</c:when>
                    		<c:otherwise>&nbsp;</c:otherwise>
                    	</c:choose>
                    </td>
                </tr>
                <tr>
                    <td class="t_title">伦敦银开户最低存款</td>
                    <td colspan="3">
                    	<c:choose>
                    		<c:when test="${broker.openMoneyLls!=null}">${broker.openMoneyLls}</c:when>
                    		<c:otherwise>&nbsp;</c:otherwise>
                    	</c:choose>                    
                    </td>
                </tr>
                <tr>
                    <td class="t_title">港金开户最低存款</td>
                    <td colspan="3">
                    	<c:choose>
                    		<c:when test="${broker.openMoneyHkg!=null}">${broker.openMoneyHkg}</c:when>
                    		<c:otherwise>&nbsp;</c:otherwise>
                    	</c:choose>                    
                    </td>
                </tr>
                <tr>
                    <td class="t_title">人民币公斤条开户最低存款</td>
                    <td colspan="3">
                    	<c:choose>
                    		<c:when test="${broker.openMoneyLkg!=null}">${broker.openMoneyLkg}</c:when>
                    		<c:otherwise>&nbsp;</c:otherwise>
                    	</c:choose>                    
                    </td>
                </tr>
            </tbody>

        </table>
    </div>


    <div class="J_tableTitle">交易信息</div>

    <div class="J_table">
        <table>
            <tbody>
                <tr>
                    <td style="width: 1.8rem;" class="t_title">点差</td>
                    <td>黃金点差: <span class="cOrange">${broker.pointDiffMinLlg}</span> 
                    / 白银点差: <span class="cOrange">${broker.pointDiffMinLls}</span> 
                    / 港金点差: <span class="cOrange">${broker.pointDiffMinHkg}</span>
                    / 人民币公斤条点差: <span class="cOrange">${broker.pointDiffMinLkg}</span></td>
                </tr>
                <tr>
                    <td class="t_title">单次最低交易<br />手数</td>
                    <td>黃金:<span class="cOrange">${broker.minTradeNumLlg}</span>手 
                    / 白銀:<span class="cOrange">${broker.minTradeNumLls}</span>手 
                    / 港金:<span class="cOrange">${broker.minTradeNumHkg}</span>手
                    / 人民币公斤条:<span class="cOrange">${broker.minTradeNumLkg}</span>手</td>
                </tr>
                <tr>
                    <td class="t_title">开仓保险金</td>
                    <td>黃金:<span class="cOrange">${broker.openMoneyLlg}</span> 
                    / 白銀:<span class="cOrange">${broker.openMoneyLls}</span>
                    / 港金:<span class="cOrange">${broker.openMoneyHkg}</span>
                    / 人民币公斤条:<span class="cOrange">${broker.openMoneyLkg}</span></td> 
                </tr>
                <tr>
                    <td class="t_title">多仓利息</td>
                    <td>${broker.longRate}</td>
                </tr>
                <tr>
                    <td class="t_title">空仓利息</td>
                    <td>${broker.shortRate}</td>
                </tr>
                <tr>
                    <td class="t_title">支持EA</td>
                    <td>
                    	<c:choose>
                    		<c:when test="${broker.isEaSupport == '0'}">否</c:when>
                    		<c:when test="${broker.isEaSupport == '1'}">是</c:when>
                    		<c:otherwise>&nbsp;</c:otherwise>
                    	</c:choose>                    
                    </td>
                </tr>
                <tr>
                    <td class="t_title">交易平台</td>
                    <td>
                    	<c:if test="${fn:contains(broker.platform, '0')}">MT4、</c:if>
                    	<c:if test="${fn:contains(broker.platform, '1')}">MT5、</c:if>
                    	<c:if test="${fn:contains(broker.platform, '2')}">GTS1、</c:if>
                    	<c:if test="${fn:contains(broker.platform, '3')}">GTS2、</c:if>
                    	<c:if test="${fn:contains(broker.platform, '4')}">mFinance、</c:if>
                    </td>
                </tr>
            </tbody>

        </table>
    </div>
    <div class="J_btnGroup">
        <a class="orange" href="#">马上开户</a>
    </div>
</body>

</html>
