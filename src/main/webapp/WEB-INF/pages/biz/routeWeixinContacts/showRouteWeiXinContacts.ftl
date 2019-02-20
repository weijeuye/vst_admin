<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<#include "/base/head.ftl"/>
<link rel="stylesheet" href="/vst_admin/css/ui-common.css" type="text/css" />
<link rel="stylesheet" href="/vst_admin/css/ui-components.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/iframe.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/easyui.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/button.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/base.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/normalize.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/calendar.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/jquery.jsonSuggest.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/jquery.ui.autocomplete.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/jquery.ui.theme.css" type="text/css"/>
<link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/v1/vst/base.css"/>
</head>
<body>
<div class="everything">
<div class="iframe_header">
 <i class="icon-home ihome"></i>
    <ul class="iframe_nav">
        <li><a href="#">首页</a> &gt;</li>
        <li><a href="#">线路详情微信客服助手管理</a> &gt;</li>
        <li class="active">微信客服助手列表</li>
    </ul>
</div>
<div class="price_tab">
	<ul class="J_tab ui_tab">   
	    <li <#if weiXinBuType==null || weiXinBuType=="INNER">class="active"</#if>><a name="tabChange" data="INNER">国内</a></li>
	    <li <#if weiXinBuType?? && weiXinBuType=="FOREIGN">class="active"</#if>><a name="tabChange" data="FOREIGN">出境</a></li>
	</ul>
</div>
<div>
	
</div>
<div id="mainContent">
	<#include "/biz/routeWeixinContacts/weiXinContacts.ftl"> 
</div>	
</div>
</body>
</html>

<script type="text/javascript" src="/vst_admin/js/iframe-custom.js"></script>
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.easyui.min-1.3.1.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>
<script type="text/javascript" src="/vst_admin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.lvtip.js"></script>
<script type="text/javascript" src="/vst_admin/js/newpanel.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.jsonSuggest-2.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_pet_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/log.js"></script>

<script>
$(function() { 
	$("a[name=tabChange]").click(function(){
			var currentTab = $(this);
			$("a[name=tabChange]").each(function() {
				if($(this).attr("data") == currentTab.attr("data")) {
					$(this).parent().addClass('active');
				} else {
					$(this).parent().removeClass();
				}
			});
			$.post("/vst_admin/biz/weiXinContacts/changeWeiXinContacts.do",{"weiXinBuType":currentTab.attr("data")},function(returnData){
				if(returnData){
					$("#mainContent").html(returnData);
				}
			});
	});
});
</script>