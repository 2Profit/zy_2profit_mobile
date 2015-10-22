<%@ page pageEncoding="UTF-8"%>

<%@include file="jstl.jsp" %>

<c:set var="loginUser" value="${sessionScope.login_user}"/>
<c:set var="loginUserFullName" value="${sessionScope.login_user_full_name}"/>

<link rel="shortcut icon" href="${ctx }/static/favicon/favicon.ico" />

<!-- 设计：黄健聪 | 重构：黄健聪 | 创建：2015/05/09 | 更新：2015/05/10 | -->
<meta name="author" content="Aowork">
<meta name="description" content="">
<meta name="apple-mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, maximum-scale=1.0">
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<title>e桶金</title>

<link href="${ctx }/static/css/mobile.css" rel="stylesheet" />
<link href="${ctx }/static/plugins/layer/need/layer.css" rel="stylesheet" />

<script src="${ctx }/static/js/zepto.min.js" type="text/javascript"></script>
<script src="${ctx }/static/js/common.js" type="text/javascript"></script>
<script src="${ctx }/static/js/uiExtend.js" type="text/javascript"></script>
<script src="${ctx }/static/plugins/jquery/jquery-1.8.3.min.js" type="text/javascript"></script>
<script src="${ctx }/static/plugins/jquery/jquery.form.js" type="text/javascript"></script>
<script src="${ctx }/static/plugins/layer/layer.m.js" type="text/javascript"></script>
<script src="${ctx }/static/plugins/base.js"></script>

<script type="text/javascript">
var ctx = '${ctx}';
</script>

<!--[if IE 6 ]><script type="text/javascript">window.location.href="${ctx }/static/IE6/index.htm"</script><![endif]-->
<!--[if lt IE 9 ]><script type="text/javascript" src="${ctx }/static/js/json2.min.js"></script><![endif]-->

