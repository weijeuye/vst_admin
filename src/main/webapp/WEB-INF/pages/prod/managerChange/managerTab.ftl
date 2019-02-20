<#--页眉-->

<!DOCTYPE html>
<html>
<head>
	<title></title>
	<#include "/base/head_meta.ftl"/>
</head>
<body>

<#--页面导航-->
<div class="iframe_header">
	<i class="icon-home ihome"></i>
	<ul class="iframe_nav">
		<li><a href="#">首页</a> &gt;</li>
		<li><a href="#">产品管理</a> &gt;</li>
		<li class="active">产品归属变更</li>
	</ul>
</div>
<div class="price_tab">
	<ul class="J_tab ui_tab">   
	    <li <#if  mainCheckedTab=="route">class="active"</#if>><a name="tabChange" data="category_route">线路产品归属变更</a></li>
	    <li <#if mainCheckedTab=="hotel">class="active"</#if>><a name="tabChange" data="category_hotel">酒店产品归属变更</a></li>
	</ul>
</div>
<div id="mainContent">
	<#--我的任务 -->
	<br>
	<div id="managerChangeNew">
		<iframe height="1500px" width="100%" scrolling="auto" frameborder="0" src="/vst_admin/prod/managerChange/showManagerChange.do">
		</iframe>
	</div>
	<div id="managerChangeHotel" style="display:none;">
		<iframe height="1500px" width="100%" scrolling="auto" frameborder="0" src="/lvmm_dest_back/prod/managerChange/showManagerChangeMain.do">
		</iframe>
	</div>
</div>
<#--页脚-->
<script>

	$(function() {
		//tab切换
		$("a[name=tabChange]").click(function(){
			var currentTab = $(this);
			if(currentTab.attr("data")=="category_route"){
				$("#managerChangeNew").show();
				$("#managerChangeHotel").hide();
			}
			if(currentTab.attr("data")=="category_hotel"){
				$("#managerChangeNew").hide();
				$("#managerChangeHotel").show();
			}
		})
	});
</script>
</body>
</html>